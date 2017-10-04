% this function generate the signed distance based on MATLAB bwdist()
function [sd] = sigdis(data)
data(data~=0) = 10;
[Fx,Fy,Fz] = gradient(data);
sd= abs(Fx) + abs(Fy) +abs(Fz); % nozero boundaries are saved in sd
sd = bwdist(sd); % unsigned distance transformation
for i = 1:size(sd,1)
    for j = 1:size(sd,2)
        for k = 1:size(sd,3)
            if data(i,j,k) ~= 0
                sd(i,j,k) = -sd(i,j,k);
            end
        end
    end
end
              
end