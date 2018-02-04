%   Read a .raw file into matlab as a tissue-index 3D matrix, raw data was
%   saved as non-binary file 
%   Enter number of elements in x,y,z dimension.
nx = 320;
ny = 160;
nz = 804;
Female = zeros(nx,ny,nz);%integer id(nx,ny,nz)
fin = fopen('Female-v1.raw','r');
irec = 0;
for iz = 1:nz
	for iy = 1:ny
		for ix = 1:nx
				irec = irec+1;
				Female(ix,iy,iz) = fread(fin,1);
        end
    end
end
fclose(fin);
