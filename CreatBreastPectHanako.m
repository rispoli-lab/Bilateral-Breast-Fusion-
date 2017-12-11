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


%% resize the breast
% of original size using nearst interpolation
% desired output dimensions.
ratio = 1/4;
nx=floor(size(inputM,1)*ratio); ny=floor(size(inputM,2)*ratio); nz=floor(size(inputM,3)*ratio);
[y,x,z]= ndgrid(linspace(1,size(inputM,1),nx),...
          linspace(1,size(inputM,2),ny),...
          linspace(1,size(inputM,3),nz));
ResizedBreast =interp3(inputM,x,y,z,'nearest');
ExtraBoundBreast = zeros(nx,ny+10,nz);
cut = 66;% crop at layer #
ExtraBoundBreast(end-cut+1:end,6:end-5,:)= ResizedBreast(1:cut,:,:);%type11
ExtraBoundBreast(ExtraBoundBreast==-1)=0; % freespace
ExtraBoundBreast(ExtraBoundBreast==-2)=6; % skin
ExtraBoundBreast(ExtraBoundBreast==1.1)=5; % FGT-1-2-3
ExtraBoundBreast(ExtraBoundBreast==1.2)=4;
ExtraBoundBreast(ExtraBoundBreast==1.3)=3;
%transitional tissue is class 2
ExtraBoundBreast(ExtraBoundBreast==3.1)=1; % Fat-1-2-3
ExtraBoundBreast(ExtraBoundBreast==3.2)=1;
ExtraBoundBreast(ExtraBoundBreast==3.3)=1;

%% Open the pectoral muscle of human model
% the basements of breast are saved into Rvoxel and Lvoxel. 
load('Hanako2p0.mat'); % load Hanako model phantom
Female = Female(:,end:-1:1,:); % change orientation 
s22 = 110; % x  basement dimensions    s22 is the max s2, s33 is the max of s3
s33 = 145; % z % 
Rvoxel= Female(207-floor(s22/2):207+floor(s22/2), : , 209-floor(s33/2):209+floor(s33/2)); % import body phamton first, format(x,y,z)
Lvoxel= Female(114-floor(s22/2):114+floor(s22/2), : , 209-floor(s33/2):209+floor(s33/2)); % x: from left hand to right hand.y: from back to front. z: from head to toe.
%Cut parameters for the chest segmentation:bone index, muscle index,start and end segment for 1st dimension, start and end segment for 3rd dimenison 
CutParaL = [45,49,33,102,13,117];
CutParaR = [45,49,6,77,11,115];
LmBreast = AffineTNICT(ExtraBoundBreast,Lvoxel,CutParaL);%input breastdata, chest data , muscle index, cutstart/end on chest for affine transformation
LmBreast(LmBreast == 12) = 2;
RmBreast = AffineTNICT(ExtraBoundBreast,Rvoxel,CutParaR); 
RmBreast(RmBreast == 12) = 2;
%need to cut extra bottom layer of chest   







 