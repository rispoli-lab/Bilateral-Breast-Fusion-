% Read a .vox file as a tissue-index 3D matrix in MATLAB
fileIDin = fopen('LbreastType11.vox','r');
formatSpec = '%d %d %d %d'; % define format of data to read
readVa = [4 1]; % shape of the output array
nx = 312;
ny = 81;
nz = 50;
breast = zeros(nx,ny,nz);
while ~feof(fileIDin)
    value = fscanf(fileIDin,formatSpec,readVa);
    if ~isempty(value)
    breast(value(1)+1,value(2)+1,value(3)+1) = value(4) ;
    end
end
fclose(fileIDin);

