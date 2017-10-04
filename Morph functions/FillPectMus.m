function [smoothImg] = FillPectMus(inPectoralMuscle)
%fill the pectoral wall
for x = 1:size(inPectoralMuscle,1)
    for z = 1:size(inPectoralMuscle,3)
        i = size(inPectoralMuscle,2);
        while (i>0 && inPectoralMuscle(x,i,z)== 0) % probe from top to bottom until 1 encounter
                i = i - 1;
        end
        inPectoralMuscle(x,1:(i+1),z) = 1; % fill from bottom to top with 1, 1:1 in case i = 1
    end
end

smoothImg = logical(inPectoralMuscle);
end