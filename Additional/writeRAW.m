% write a tissue-index 3D matrix as a .raw file
nx = 320;
ny = 160;
nz = 804;
fin = fopen('Hanako.raw','w');
irec = 0;
for iz = 1:nz
	for iy = 1:ny
		for ix = 1:nx
				irec = irec+1;
                fwrite(fin,Hanako(ix,iy,iz),'int');
        end
    end
end
fclose(fin);
