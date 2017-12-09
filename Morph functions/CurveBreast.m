function [CurvedBreast, CropPect, Fat]= CurveBreast(inPectoralMuscle, inBreast,offset, Fatin)
%CropPect is the pectoral muscle only, the Fat is the fat on the top of Pect. muscle. 
CurvedBreast = inBreast; % make the CurvedBreast the same size as the inBreast
MoveDis =  zeros(size(inBreast,3),size(inBreast,2));
n = size(inPectoralMuscle,2);
offsetx = floor(size(inPectoralMuscle,1)/2)-floor(size(inBreast,3)/2)+offset; % x and z of input of pectroal muscle are larger than that of in put breast
offsetz = floor(size(inPectoralMuscle,3)/2)-floor(size(inBreast,2)/2); % the offset is then added. s22 = 400; % s22 is the max s2, s33 is the max of s3
                                                                       % s33 is the max of s3  s33 = 310; 
                                                                 
for x = 1:size(inBreast,3)
    for z = 1:size(inBreast,2)
        i = n;
        while (i > 0 && inPectoralMuscle(x+offsetx,i,z+offsetz) < 1) 
              i = i - 1;
        end
        MoveDis(x, z) = n - i;  % the offset is, for example 600-i, saved for validation
           
        AftershiftCo = circshift(squeeze(inBreast(:, z, x)),n - i); % shift each column of the breast to the prestcal muscle
        CurvedBreast(:, z, x) = AftershiftCo; % adding shifted columns together to make the curved breast 

    end
end
CropPect = inPectoralMuscle(offsetx:offsetx+size(inBreast,3)-1,:,offsetz:offsetz+size(inBreast,2)-1) ;
Fat = Fatin(offsetx:offsetx+size(inBreast,3)-1,:,offsetz:offsetz+size(inBreast,2)-1);
end