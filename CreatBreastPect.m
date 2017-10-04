%% Read breast information 
[FileName,PathName] = uigetfile('*.txt','Select the breastInfo.txt');
InfoFile = strcat(PathName,FileName); % dialog box that lists files in the current folder
fID = fopen(InfoFile);
C = textscan(fID,'%s %s','Delimiter','=');
fclose(fID);
Values = C{2};
s1 = str2double(Values(2));
s2 = str2double(Values(3));
s3 = str2double(Values(4));

% Read mtype data
[FileName,PathName] = uigetfile('*.txt','Select the mtype.txt');
mtypeFile = strcat(PathName,FileName);
fID2 = fopen(mtypeFile);
C2 = textscan(fID2,'%f');
fclose(fID2);
inputData = cell2mat(C2);
inputM = reshape(inputData,[s1,s2,s3]); % reshape vector into 3d matrix. 
%Breast Phantom Parameters
% Immersion Medium -1
% Skin -2
% Muscle -4
% Fibro/glandular 1.1
% Fibro/glandular 1.2
% Firbo/glandular 1.3
% Transitional  2
% Fatty-1 3.1
% Fatty-2 3.2
% Fatty-3 3.3

% crop the slab of muscle = -4 and fat = 3.2, and set immersion medium = 0.
ii = 266; % the slap start from 272
outputCrop = inputM;
outputCrop(ii:end,1:s2,1:s3) = 0; % crop slabs
outputCrop(outputCrop ==-1) = 0; %set all immersion tissue = 0.
%% resize the breast
im = outputCrop;
ratio = 0.84; % resize to 84% of original size using cubic interpolation
nx=floor(size(im,1)*ratio);ny=floor(size(im,2)*ratio);nz=floor(size(im,3)*ratio); % desired output dimensions, 89% of orignal size.
[y,x,z]= ndgrid(linspace(1,size(im,1),nx),...
          linspace(1,size(im,2),ny),...
          linspace(1,size(im,3),nz));
outputCrop2 =interp3(im,x,y,z,'nearest');
%% Open the pectoral muscle of human model
% the basements of breast are saved into Rvoxel and Lvoxel. 
%addpath('E:\Remcom\projects\Xin\MATLAB\MAT files');
load('Ella0p5.mat') % load Ella phantom

s22 = 310; % x  basement dimensions    s22 is the max s2, s33 is the max of s3
s33 = 400; % z % 
Rvoxel= A(670-floor(s22/2):670+floor(s22/2)+mod(s22,2)-1 , : , 945-floor(s33/2):945+floor(s33/2)+mod(s33,2)-1); % import body phamton first, format(x,y,z)
Lvoxel= A(386-floor(s22/2):386+floor(s22/2)+mod(s22,2)-1 , : , 945-floor(s33/2):945+floor(s33/2)+mod(s33,2)-1); % x: from left hand to right hand.y: from back to front. z: from head to toe.  
LmBreast = AffineT(outputCrop2,Lvoxel,22,250,600);%input breastdata, chest data , muscle index, cutstart/end on chest for affine transformation
RmBreast = AffineT(outputCrop2,Rvoxel,22,250,600); 








 