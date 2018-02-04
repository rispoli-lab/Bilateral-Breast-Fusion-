function [ ] = WriteTommf( filename, filesize, pathname,resolution)
%WRITETOVOX Write phantom to VOX file
%Input:     filename is the vox file name desired
%           outputData is the data file to be write and saved 
%           pathname is the directory to save the vox data
mmffile = fullfile(pathname, [filename,'.mmf']);
fileIDout = fopen(mmffile,'w');
fprintf(fileIDout,'<!DOCTYPE TissueMeshData SYSTEM "TissueMeshData.dtd">\n');
fprintf(fileIDout,'<TissueMeshData FileName="%s.vox" DataType="Voxel" Name= "%s" Format="0" >\n',filename,filename);
fprintf(fileIDout,'\t<MeshData XCount="%d" YCount="%d" ZCount="%d" >\n',filesize(3),filesize(1),filesize(2));
fprintf(fileIDout,'\t\t<Resolution X="%.1f" Y="%.1f" Z="%.1f" Units="mm" />\n',resolution,resolution,resolution );
fprintf(fileIDout,'\t</MeshData>\n');
fprintf(fileIDout,'\t<TissueData Count="%d" >\n',9);
fprintf(fileIDout,'\t\t<Tissue Name="Skin" Value="%d" Visible="Yes"/>\n',86);
fprintf(fileIDout,'\t\t<Tissue Name="FGT(100)" Value="%d" Visible="Yes"/>\n',85);
fprintf(fileIDout,'\t\t<Tissue Name="FGT(75)" Value="%d" Visible="Yes"/>\n',84);
fprintf(fileIDout,'\t\t<Tissue Name="FGT(50)" Value="%d" Visible="Yes"/>\n',83);
fprintf(fileIDout,'\t\t<Tissue Name="FGT(25)" Value="%d" Visible="Yes"/>\n',82);
fprintf(fileIDout,'\t\t<Tissue Name="Breast Fat" Value="%d" Visible="Yes"/>\n',81);
fprintf(fileIDout,'\t\t<Tissue Name="Subcut. Fat" Value="%d" Visible="Yes"/>\n',100);
fprintf(fileIDout,'\t\t<Tissue Name="Ambient Air" Value="%d" Visible="Yes"/>\n',0);
fprintf(fileIDout,'\t\t</TissueData>\n');
fprintf(fileIDout,'</TissueMeshData>');
fclose(fileIDout);
end