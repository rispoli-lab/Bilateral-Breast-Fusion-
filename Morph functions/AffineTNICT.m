% Affine transformation for NICT model
function Ambre = AffineTNICT(Breastdata, Chestdata,CutPara)
bonei = CutPara(1); % bone index
musclei = CutPara(2); % muscle index
s1 = CutPara(3);
e1 = CutPara(4);
s3 = CutPara(5);
e3 = CutPara(6);
outputCrop = 2*Breastdata;% not to confuse with index 1 pectoral muscle
Lvoxel = Chestdata;
ii = size(outputCrop, 1);
%% Read pectoral muscle voxel model and convert to binary
% Model voxel value: Bone is 23, muscle is 22 and breast is 43. 
AddSpace = zeros(size(outputCrop,1)+250,size(outputCrop,2),size(outputCrop,3)); % increase more space for the breast, the first dim is breast height
AddSpace(1:ii,:,:) = outputCrop(1:ii,:,:);% now index(y,z,x), used to be indxe(y,x,z)
Cut = floor(ii*0.81); % the lenght to cut the breast is about 20%.
AddSpaceRf = AddSpace(Cut:end,:,:);% 210 is the cutoff hight of breast. AddSpceRf is the basement for curve and fusion. 
AddSpace(Cut:end,:,:) = 0; % cut breast basement, from cut to end is made zero.
mask = squeeze(AddSpace(Cut-1,:,:)); % this mask is the radius of breast model basment in original form. 
mask = logical(mask);
Lvoxel = Lvoxel(s1:e1,:,s3:e3); % Fat is the fat or breast fat tissue on top of Pect. Muscle
Fat = Lvoxel;
% only takes a portaion (about half) of the total voxel, faster comput.
Lvoxel(Lvoxel == musclei) = 1;
Lvoxel(Lvoxel == bonei) = 1;
Lvoxel(Lvoxel ~= 1) = 0;% only the muscle and bone remained and convert to BW volume.
%% Morphological filtering for smoothing, then curve project the breast basement to pect. muscle
[LClosePec] = ImClose(Lvoxel,5);
[LFPec] = FillPectMus(LClosePec);
[LOpenPec] = ImOpen(LFPec, 5);
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
breastchest = circshift(breastchest,50,1); % shift down the chestbreast composite down, in case it is too close to the boundary
%% Fill the gap between breast basement and breast
for j = 1:size(breastchest,2)
     for k = 1:size(breastchest,3)
        fl = AddSpace(Cut-1,j,k);
        dp = Cut+50; % the cut depth was shifted by 50 
        while mask(j,k)==1 && breastchest(dp,j,k) ==0
            breastchest(dp,j,k) = fl;
            dp = dp +1;
        end
     end
end
%% Add subcutaneous fat layers to the top of the pect. muscel in vicinity to the breast
%first shift the fat and muscle layers to be on the same location as the
%breast basement and breast composite
Fatbase = AddSpaceFt;
Fatbase(Fatbase == 45) = 1;
Fatbase(Fatbase == 49) = 1;
Fatbase(Fatbase ~= 1) = 0;
[x1,trash,trash] = ind2sub(size(Fatbase),find(Fatbase));
[x0,y0,z0] = ind2sub(size(AddSpaceFt),find(AddSpaceFt));
Pecbase = breastchest;
Pecbase(Pecbase ~= 1) = 0;
[x2,trash,trash] = ind2sub(size(Pecbase),find(Pecbase)); 
if (min(x1(:))>= min(x2(:)))
    x0 = x0 - (min(x1(:))-min(x2(:)));
else 
     x0 = x0 + (min(x2(:))-min(x1(:)));
end
shiftFt = zeros(size(AddSpaceFt));
[trash, trash,v]= find(AddSpaceFt);
linearInd = sub2ind(size(AddSpaceFt),x0,y0,z0);
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
%Ambre = fillcon(Fbchest);% fill any empty space in between the layers
Ambre = Fbchest;
end

