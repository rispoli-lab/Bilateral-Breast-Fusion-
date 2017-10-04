%overlap two sets of images: the original breast data image and the
%smoothed basement. 
% Input: smoothed basement
%        Breat data 
% Output: Composite breast, the add-on fat(smoothed fat) is the 20.
function [out] = overlap2(data,AddSpacefl2,start,finish)
back = convertBack(data); % take the zero level set 
reference = AddSpacefl2(start:finish,:,:);
for i = 1:size(reference, 1)
    for j = 1:size(reference,2)
        for k = 1:size(reference,3)
            if back(i,j,k)==1 && reference(i,j,k) == 0
                reference(i,j,k) = 20;
            end
        end
    end
end
AddSpacefl2(start:finish,:,:) = reference;
out = AddSpacefl2;
end