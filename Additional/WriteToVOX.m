function [ ] = WriteToVOX( filename, outputData, pathname)
%WRITETOVOX Write phantom to VOX file
%Input:     filename is the vox file name desired
%           outputData is the data file to be write and saved 
%           pathname is the directory to save the vox data
voxfile = fullfile(pathname, filename);
fileIDout = fopen(voxfile,'w');
for kk=1:size(outputData,3)
    for jj=1:size(outputData,2)
        for ii=1:size(outputData,1)
                  
            if outputData(ii,jj,kk) ~= 0
                fprintf(fileIDout,'%d %d %d %d\n',kk-1,ii-1,jj-1,outputData(ii,jj,kk));
            end
            
        end 
    end 
end 
fclose(fileIDout);
end