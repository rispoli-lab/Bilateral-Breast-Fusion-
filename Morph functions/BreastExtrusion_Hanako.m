% Breast extrusion for Ella model
function BreastExtrusion = BreastExtrusion_Hanako(Breastdata, Trunk, ClosePec, Chestdataorigion,Breastorigion)

relativeorigion = abs(Breastorigion-Chestdataorigion);
% Morphological filtering for smoothing, then curve project the breast basement to pect. muscle
Chestdata = ClosePec(:,relativeorigion(1):relativeorigion(1)+size(Breastdata,2)-1,relativeorigion(2):size(Breastdata,3)+relativeorigion(2)-1);
% Chestdata(:,relativeorigion(1):relativeorigion(1)+size(Breastdata,2)-1,relativeorigion(2):size(Breastdata,3)+relativeorigion(2)-1)=0;
%figure(1009); imagesc(squeeze((Chestdata(:,33,:))));axis equal; axis tight;

AddSpace_breast = zeros(170+size(Breastdata,1),size(Breastdata,2),size(Breastdata,3)); % increase more space for the breast, the first dim is breast height
AddSpace_breast(1:size(Breastdata, 1),:,:) = Breastdata(1:size(Breastdata, 1),:,:);% now index(y,z,x), used to be indxe(y,x,z)
figure(1009622);imagesc(squeeze(AddSpace_breast(:,floor(size(AddSpace_breast,2)/2),:)));axis equal; axis tight;
%%
% display('Image-colse morpholging...')
% tic
% [ClosePec] = ImClose(Chestdata, 15); 
% toc

% 
Shiftmap = zeros(size(Chestdata,2),size(Chestdata,3));
for k = 1:size(Chestdata,3)
    for j = 1:size(Chestdata,2)
        if isempty(find(Chestdata(:, j, k) ==1,1,'last'))
            Shiftmap(j,k) =0;
        else
        Shiftmap(j,k) = find(Chestdata(:, j, k) ==1,1,'last'); % adding shifted columns together to make the curved breast 
        
        end
        
%         if ~isempty(find(AddSpace_breast(:,j,k),1))
%               if Shiftmap(j,k) ~= 0
%                     AddSpace_breast(:,j,k) = circshift(AddSpace_breast(:,j,k),size(Chestdata,1)- Shiftmap(j,k)  ); 
%               else
%                   AddSpace_breast(:,j,k) = circshift(AddSpace_breast(:,j,k),size(Chestdata,1)- min(Shiftmap(:,k)>0)  );
%               end
%         end                  
    end
end

for k = 1:size(Chestdata,3)
    for j = 1:size(Chestdata,2)
%         if isempty(find(Chestdata(:, j, k) ==1,1,'last'))
%             Shiftmap(j,k) =0;
%         else
%         Shiftmap(j,k) = find(Chestdata(:, j, k) ==1,1,'last'); % adding shifted columns together to make the curved breast 
%         
%         end
%         
        if ~isempty(find(AddSpace_breast(:,j,k),1))
              if Shiftmap(j,k) ~= 0
                  AddSpace_breast(:,j,k) = circshift(AddSpace_breast(:,j,k),size(Chestdata,1)- Shiftmap(j,k)  ); 
              else
                  A = Shiftmap(j,:);
                  AddSpace_breast(:,j,k) = circshift(AddSpace_breast(:,j,k),size(Chestdata,1)- min(A(A>0))  );
              end
        end                  
    end
end




% [x,y]=find(Shiftmap == max(Shiftmap(:)));
AddSpace_breast = flip(AddSpace_breast,1);
Curvedbreast = AddSpace_breast( find(AddSpace_breast(:,floor(size(AddSpace_breast,2)/2),floor(size(AddSpace_breast,3)/2))~=0,1)...
                            - Shiftmap(floor(size(AddSpace_breast,2)/2),floor(size(AddSpace_breast,3)/2)):end , : , :   );
if isempty(find(    AddSpace_breast(:,   floor(size(AddSpace_breast,2)/2)  ,  floor(size(AddSpace_breast,3)/2))  ,1   )   ) 
    error('breast is not centered')
end
figure(11111);imagesc(Shiftmap);

Curvedbreast = uint8(Curvedbreast);
%add missing skin by connectivity check
for i = 2:size(Curvedbreast,1)-1;
    for j = 2:size(Curvedbreast,2)-1;
        for k = 2:size(Curvedbreast,3)-1; 
            
                    if Curvedbreast(i,j,k) ~= 86 && Curvedbreast(i,j,k) ~=0 
                        for n1 = -1:1:1
                            for n2 = -1:1:1
                                for n3 = -1:1:1
                                    if Curvedbreast(i+n1,j+n2,k+n3) == 0
                                        Curvedbreast(i+n1,j+n2,k+n3)= 86;
                                    end
                                    
                                end
                            end
                        end
                    end 
                    
        end
    end
end

% figure(100923);imagesc(Shiftmap);axis equal; axis tight;
% figure(100924);imagesc(squeeze(AddSpace_breast(:,100,:)));axis equal; axis tight;
% figure(1009257);imagesc(squeeze(Curvedbreast(:,37,:)));axis equal; axis tight;
%substitution human-model breast with new breast
%eliminate skin by overlapping check 
% T1 = 199;T2= relativeorigion(1)-1; T3= relativeorigion(2)-1;
nonoverlap =1;
%eliminate extra breast in deep
% for i = 1:nonoverlap;
%     for j = 1:size(Curvedbreast,2);
%         for k = 1:size(Curvedbreast,3); 
%                          
%                     if Curvedbreast(i,j,k) ~=0 
%                         
%                         if Trunk(i, relativeorigion(1)-1+j,relativeorigion(2)-1+k) == 43 && Curvedbreast(i,j,k) ~=86
%                                     Trunk(i, relativeorigion(1)-1+j,relativeorigion(2)-1+k) = Curvedbreast(i,j,k);
%                         end
%                     end  
%                     
%         end
%     end
% end
for i = nonoverlap:size(Curvedbreast,1);
    for j = 1:size(Curvedbreast,2);
        for k = 1:size(Curvedbreast,3); 
                         
                    if Curvedbreast(i,j,k) ~=0 
                        if  (Curvedbreast(i,j,k) ~= 86) || ...
                            (Curvedbreast(i,j,k) == 86 && Trunk(i, relativeorigion(1)-1+j,relativeorigion(2)-1+k) == 0)
                                    Trunk(i, relativeorigion(1)-1+j,relativeorigion(2)-1+k) = Curvedbreast(i,j,k);
                        end
                    end  
                    
        end
    end
end



 BreastExtrusion = Trunk;
                            
% slice = 100;
% figure(10091);imagesc(squeeze(Chestdata(:,slice,:)));axis equal; axis tight;
% figure(10092);imagesc(squeeze(ClosePec(:,slice,:)));axis equal; axis tight;
% figure(100920);imagesc(squeeze(Trunk(:,relativeorigion(1)-1+slice,:)));axis equal; axis tight;
end