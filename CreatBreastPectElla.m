%% Read breast information 
[File1.FileName1,File1.PathName1] = uigetfile('*.txt','Select the breastInfo.txt');
File1.InfoFile = strcat(File1.PathName1,File1.FileName1); % dialog box that lists files in the current folder
File1.fID = fopen(File1.InfoFile);
File1.C = textscan(File1.fID,'%s %s','Delimiter','=');
fclose(File1.fID);
File1.Values = File1.C{2};
File1.s1 = str2double(File1.Values(2));
File1.s2 = str2double(File1.Values(3));
File1.s3 = str2double(File1.Values(4));

%% Read mtype data
[File2.FileName,File2.PathName] = uigetfile('*.txt','Select the mtype.txt');
File2.mtypeFile = strcat(File2.PathName,File2.FileName);
File2.fID = fopen(File2.mtypeFile);
File2.C2 = textscan(File2.fID,'%f');
fclose(File2.fID);
inputData = cell2mat(File2.C2);
inputM = reshape(inputData,[File1.s1,File1.s2,File1.s3]); % reshape vector into 3d matrix. 
% Breast Phantom Parameters
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

%% Open the pectoral muscle of human model
% the basements of breast are saved into Rvoxel and Lvoxel. 
% addpath('E:\Remcom\projects\Xin\MATLAB\MAT files');
load('C:\Users\xin\Documents\Breast Morph\version 5\MATLAB\Scripts Version4\Ella0p5_uint8.mat'); % load Ella phantom
% Imported Ella model in matlab dimensions(left_arm to right_arm, back to front, head to toe)
s22 = 310; % x  basement dimensions    s22 is the max s2, s33 is the max of s3
s33 = 400; % z % 

Rvoxel= Ella(670-floor(s22/2):670+floor(s22/2)+mod(s22,2)-1 , : , 945-floor(s33/2):945+floor(s33/2)+mod(s33,2)-1); % import body phamton first, format(x,y,z)
Lvoxel= Ella(386-floor(s22/2):386+floor(s22/2)+mod(s22,2)-1 , : , 945-floor(s33/2):945+floor(s33/2)+mod(s33,2)-1); % x: from left hand to right hand.y: from back to front. z: from head to toe.  



% crop the slab of muscle = -4 and fat = 3.2, and set immersion medium = 0.
ii = 176; % the slap start from 272
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

LmBreast = AffineT(outputCrop2,Lvoxel);
RmBreast = AffineT(outputCrop2,Rvoxel); 








 