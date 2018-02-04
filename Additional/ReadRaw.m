function Raw = ReadRaw(fname,xdim,ydim,zdim,type,varargin)

% Usage image = ReadRaw('image.raw',512,512,128,'int16');
% image = ReadRaw('image.raw',512,512,128,'int16','BigEndian');

Raw = zeros(xdim,ydim,zdim);

fid = fopen(fname, 'r');
i=1;

if strcmp(varargin,'BigEndian')
    mformat = 'ieee-be';
elseif strcmp(varargin,'LittleEndian')    
    mformat = 'ieee-le';
else 
    mformat = [];
end

if isempty(mformat)
    while i<=zdim
        c = fread(fid, [xdim,ydim], type);
        Raw(:,:,i) = c;

        %cent{i} = sparse(c);    
        %position = ftell(fid);
        i=i+1;
    end
else
    while i<=zdim
        c = fread(fid, [xdim,ydim], type, mformat);
        Raw(:,:,i) = c;
    
        %cent{i} = sparse(c);    
        %position = ftell(fid);
        i=i+1;
    end
end

fclose(fid);
