% Add skin to the data
%input data is composited breast image, d is the depth of skin layer
%output is the skin assigned for the out layer
function [out] = AddSkin(datain,d)
ref = datain;
ref(ref ~=0 ) = 1;
ref = logical(ref);
for j = 2:size(datain,2)-1
    for k = 2:size(datain,3)-1
        for i = 2:size(datain,1)-1
            if ref(i,j,k) ==1
                if ref(i-1,j,k)==0 || ref(i+1,j,k)==0 || ref(i,j-1,k)==0 || ref(i,j+1,k)==0 || ref(i,j,k-1)==0 || ref(i,j,k+1)==0
                    datain(i,j,k) = -1;
                end
            end
        end
    end
end
dep = floor(size(datain,1)/2);
%dep = floor(size(datain,1));
while d > 1 
    ref = datain;
    ref(ref ~=0 ) = 1;
    ref = logical(ref);
    for j = 2:size(datain,2)-1
        for k = 2:size(datain,3)-1
            for i = 2:size(datain,1)-1
                if ref(i,j,k) ==1
                    if ref(i-1,j,k)==0 || ref(i+1,j,k)==0 || ref(i,j-1,k)==0 || ref(i,j+1,k)==0 || ref(i,j,k-1)==0 || ref(i,j,k+1)==0
                        datain(i-1,j,k)= -1;
                        datain(i+1,j,k)= -1 ;
                        datain(i,j-1,k)= -1 ;
                        datain(i,j+1,k)= -1 ;
                        datain(i,j,k-1)= -1 ;
                        datain(i,j,k+1)= -1 ;
                    end
                    
                end
            end
        end
    end
    d = d - 1;
end
datain(datain==1) = 0;
out = datain(1:dep,:,:);
end