% Affine transformation for Ella model
function Ambre = AffineT(Breastdata, Chestdata)
outputCrop = 2*Breastdata;
Lvoxel = Chestdata;
ii = size(outputCrop, 1);
%% Read pectoral muscle voxel model and convert to binary
% Model voxel value: Bone is 23, muscle is 22 and breast is 43. 
AddSpace = zeros(size(outputCrop,1)+400,size(outputCrop,2),size(outputCrop,3)); % increase more space for the breast, the first dim is breast height
AddSpace(1:ii,:,:) = outputCrop(1:ii,:,:);% now index(y,z,x), used to be indxe(y,x,z)
Cut = floor(size(Breastdata,1)*(7/8)); % the lenght to cut the breast
AddSpaceRf = AddSpace(Cut:end,:,:);% 210 is the cutoff hight of breast. AddSpceRf is the basement for curve and fusion. 
AddSpace(Cut:end,:,:) = 0; % cut breast basement, from cut to end is made zero.
mask = squeeze(AddSpace(Cut-1,:,:)); % this mask is the radius of breast model basment in original form. 
mask = logical(mask);
Fat = Lvoxel(:,250:600,:); % Fat is the fat or breast fat tissue on top of Pect. Muscle.
Lvoxel = Fat;% only takes a portaion (about half) of the total voxel, faster comput.
Lvoxel(Lvoxel ~= 22) = 0;% only the muscle remained and convert to BW volume.
Lvoxel(Lvoxel == 22) = 1;
%% Morphological filtering for smoothing, then curve project the breast basement to pect. muscle
[LClosePec] = ImClose(Lvoxel, 15);
[LFPec] = FillPectMus(LClosePec);
[LOpenPec] = ImOpen(LFPec, 15);
[LCurvedBreastB,CropPect, ConFat]= CurveBreast(LOpenPec, AddSpaceRf,0,Fat); %offset max = (x1-x2)/2, L breast is possitve, R breat is negetive
% rearange the dimensions of pect. muscle wall, so it has the same oder of
% dimensions as the breast.
LOpenFat = permute(ConFat,[2 3 1]); % LOpenFat is for the left breast, describing the fat on top of pect. muscle
LOpenDisr = permute(CropPect,[2 3 1]);% LOpenDisr describes the pect. muscle
%% Fuse brest and brest basement
bbase = flatMerge(AddSpace,LCurvedBreastB);% creat breast and breast basement joint by falt interface Merge the breat and curved breast basement in the First index (x)
%% Fuse breast basement and pect. muscle
AddSpaceFt = zeros(size(bbase));
AddSpaceFt(1:size(LOpenFat,1),:,:) = LOpenFat(size(LOpenFat,1):-1:1,:,:); % AddSpaceFt is the fat layer above pect. muscle
AddSpacePt = zeros(size(bbase));
AddSpacePt(1:size(LOpenDisr,1),:,:) = LOpenDisr(size(LOpenDisr,1):-1:1,:,:);% AddSpacebr is the pect. muscle laver below the breast
breastchest = curveMerge(bbase,AddSpacePt);%creat breat and pectoral muscle joints by merging the curved interface
%% Fill the gap between breast basement and breast
for j = 1:size(breastchest,2)
     for k = 1:size(breastchest,3)
        fl = AddSpace(Cut-1,j,k);
        dp = Cut;
        while dp <=size(breastchest,1) && mask(j,k)==1 && breastchest(dp,j,k) ==0
            breastchest(dp,j,k) = fl;
            dp = dp +1;
        end
     end
end
%% Add subcutaneous fat layers to the top of the pect. muscel in vicinity to the breast
%first shift the fat and muscle layers to be on the same location as the
%breast basement and breast composite
[x1,y1,z1] = ind2sub(size(AddSpaceFt),find(AddSpaceFt)); 
[x2,y2,z2] = ind2sub(size(breastchest),find(breastchest)); 
if (max(x1(:))>= max(x2(:)))
    x1 = x1 - (max(x1(:))-max(x2(:)));
else 
     x1 = x1 + (max(x2(:))-max(x1(:)));
end
shiftFt = zeros(size(AddSpaceFt));
[trash, trash,v]= find(AddSpaceFt);
linearInd = sub2ind(size(AddSpaceFt),x1,y1,z1);
shiftFt(linearInd) = v;
%% Add subcutaneous fat layers to the top of the pect. muscel in vicinity to the breast
Fbchest = breastchest;% the fat + breast + chest model
for i = 1:size(Fbchest,1)  
    for j = 1:size(Fbchest,2)
        for k = 1:size(Fbchest,3)
            if shiftFt(i,j,k) ~= 0 && Fbchest(i,j,k) == 0
                Fbchest(i,j,k) = 2; % assign the desire value. eg mucle, this value will be equal to zero in the end if we want to eliminate the basement
            end
        end
    end
end
Ambre  = Fbchest;
end

