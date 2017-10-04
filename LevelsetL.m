% Apply level-set function on the left breast
% margin, or zero padding
ma = 2;
start = 192; finish = 260; % Z-axis specifies where to apply the level set function.
%start = 32; finish = 90; %CAT1459
%start = 72; finish = 115; %CAT1065
%start = 59; finish = 89; %CAT0747
%start = 34; finish = 79; %CAT0781
%start = 72; finish = 115; %CTA1200
%start = 25; finish = 73; %CTA1209
%start = 52; finish = 86; %CTB6057
%start = 73; finish = 120; %CTB5651
%start =66; finish = 108; %CTB5434
%start = 56; finish = 69; %CTA0781
%start = 53; finish = 91; %CTA0780
%start = 80; finish = 115; %CTA1459
%start = 69; finish = 120; %CTA 1741
%start = 75; finish = 116; %CTB 6041
%start = 76; finish = 110; %CTB5063
%start = 75; finish = 106; %CTB4929
%start =97; finish = 132; %type11
%start = 83; finish = 130; %type12
%start = 88; finish = 139; %type21
%start= 86; finish = 140; %type22
%start = 75; finish = 120; %Type23
%start = 73; finish =127; %Type31
%start = 86; finish = 130; %Type 32
%start = 72; finish =110; %Type 33
%start = 83; finish = 127; %Type 41
%Breastnew = RmBreast(start:finish,:,:);% need to check if make sense, ex. the portion that is needed to smooth is right.
Breastnew = LmBreast(start:finish,:,:);% need to check if make sense, ex. the portion that is needed to smooth is right.
Breastnew(1: ma,:,:) = 0;   
Breastnew(end-ma:end,:,:)=0;
Breastnew(:,1:ma,:)= 0;
Breastnew(:,end-ma:end,:)=0;
Breastnew(:,:,1:ma)=0;
Breastnew(:,:,end-ma:end)=0;
Breastdis = sigdis(Breastnew); % need to check if make sense.
[ data, g, data0 ] = LSinp('medium',Breastdis,4);%9 for NICT model. call level set function.the level set result is stored in data 
%d is the propagation speed, the large the faster
CompBreast = overlap2(data,LmBreast,start,finish);% take the zero level set out, then form the composite breast, add-on subcutaneous fat is 20.
CompBreast(CompBreast == 20) = 2;
SBreast = 10*AddSkin(CompBreast,3);%1 for NICT model, Add skin to the data based on 4 connectivity, thickness of skin layer
%writeToVOX( 'Rbreast11.vox', SBreast,'C:\Users\xin\Documents\MATLAB\Scripts Version4\Import breast data');%[ ] = writeToVOX( filename, outputData, pathname)
name = [num2str(size(SBreast,1)), num2str(size(SBreast,2)),num2str(size(SBreast,3))];
writeToVOX( [name 'LbreastCTA1316.vox'], SBreast,'C:\Users\xin\Desktop\Ella model\CTA1316 ');%[ ] = writeToVOX( filename, outputData, pathname)
