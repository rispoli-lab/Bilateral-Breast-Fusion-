function Breast = ReadText(fname,xdim,ydim,zdin,type)
File.fID = fopen(fname);
File.C2 = textscan(File.fID,type);
fclose(File.fID);
inputData = cell2mat(File.C2);
Breast = reshape(inputData,[xdim,ydim,zdin]); 
end
