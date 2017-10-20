% write a tissue-index 3D matrix as a .raw file
nx = 312;
ny = 81;
nz = 50;
fin = fopen('breast.raw','w');
irec = 0;
for iz = 1:nz
	for iy = 1:ny
		for ix = 1:nx
				irec = irec+1;
                fwrite(fin,breast(ix,iy,iz),'int');
        end
    end
end
fclose(fin);
