% Apply level-set function on the right breast
% margin, or zero padding
ma = 2;
%start = 76; finish = 120; %type41
%start = 75; finish = 114; %type33
%start = 86; finish = 129; %type32
%start = 74; finish= 131;%type31
%start = 79; finish =120; %Type23
%start = 83; finish =140; %Type22
%start = 90; finish =142; %Type21
%start = 83; finish =132; %Type12
%start = 95; finish = 137; %Type11
%start = 72; finish = 120; %  CTA 1065 
%start = 60; finish = 98; % CTA0747
%start = 28; finish = 72; % nCTA0781
%start = 71; finish = 120; %CTA 1200
%start = 72; finish = 120; % CTB5651
%start = 52; finish = 81; % ctb6057
%start = 64;  finish = 108;%CTB5434
%start = 56; finish = 76; %CTA0781
%start = 66; finish = 87;%CTA0780
%start = 74; finish = 115;%CTA1459
%start = 70; finish = 120; %CTA1741
%start = 75; finish = 119; %CTB6041
%start = 71; finish = 111; %CTB4643
start = 192; finish = 260; % Z-axis specifies where to apply the level set function.
Breastnew = RmBreast(start:finish,:,:);% need to check if make sense, ex. the portion that is needed to smooth is right.
Breastnew(1: ma,:,:) = 0;   
Breastnew(end-ma:end,:,:)=0;
Breastnew(:,1:ma,:)= 0;
Breastnew(:,end-ma:end,:)=0;
Breastnew(:,:,1:ma)=0;
Breastnew(:,:,end-ma:end)=0;
Breastdis = sigdis(Breastnew); % need to check if make sense.
[ data, g, data0 ] = LSinp('medium',Breastdis,4);%9 for nict, call level set function.the level set result is stored in data 
%d is the propagation speed, the large the faster
CompBreast = overlap2(data,RmBreast,start,finish);% take the zero level set out, then form the composite breast, add-on subcutaneous fat is 20.
CompBreast(CompBreast == 20) = 2;
SBreast = 10*AddSkin(CompBreast,3);% Add skin to the data based on 4 connectivity, thickness of skin layer
%SBreast(78:end,:,:) = 0;
name = [num2str(size(SBreast,1)), num2str(size(SBreast,2)),num2str(size(SBreast,3))];
writeToVOX( [name 'RbreastCTA1316.vox'], SBreast,'C:\Users\xin\Desktop\Ella model\CTA1316');%[ ] = writeToVOX( filename, outputData, pathname)
 