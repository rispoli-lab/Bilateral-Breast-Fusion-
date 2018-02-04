%% load human body model
load('C:\Users\xin\Documents\Breast Morph\version 5\MATLAB\Scripts Version4\Ella0p5_uint8.mat'); % load Ella phantom
Ella = permute(Ella, [2 3 1]);
% figure(1008);imagesc(squeeze(Ella(:,913,:)));axis equal; axis tight;set(gca,'YDir','normal','XDir','reverse');
% % Ella = flip(Ella,3);
% ZProject = Ellacontour(Ella);
%
load('Zproject.mat'); % Z projection in Data folder
load('MuscleBone.mat'); % Z projection in Data folder
%% Read breast information & mtype data from breast data from http://uwcem.ece.wisc.edu/phantomRepository.html
addpath('C:\Users\xin\Documents\Breast Morph\version 5\MATLAB\Scripts Version 12_8_2017\UWM Text files');
Breast.uwm1 = ReadText('mtype11.txt',310,355,253,'%f');
Breast.uwm2 = ReadText('mtype12.txt',267,375,288,'%f');
Breast.uwm3 = ReadText('mtype21.txt',316,352,307,'%f');
Breast.uwm4 = ReadText('mtype22.txt',300,383,270,'%f');
Breast.uwm5 = ReadText('mtype23.txt',258,253,251,'%f');
Breast.uwm6 = ReadText('mtype31.txt',269,332,202,'%f');
Breast.uwm7 = ReadText('mtype32.txt',258,365,248,'%f');
Breast.uwm8 = ReadText('mtype33.txt',219,243,273,'%f');
Breast.uwm9 = ReadText('mtype41.txt',215,328,212,'%f');

% Immersion Medium (air)                      -1
% Skin                                        -2
% Muscle (will be croped)                     -4
% Fibro/glandular(100% fibrogland)             1.1
% Fibro/glandular(75% fibrogland)              1.2
% Firbo/glandular(50% fibrogland)              1.3
% Transitional(25% fibrogland)                 2 (lowest glandular tissue mix)
% Fatty-1                                      3.1
% Fatty-2                                      3.2
% Fatty-3                                      3.3
% Change breast tissue types with models to be the same as that from Duke University
for n =1 :9
%     tic
    eval(['inputM =','Breast.uwm',num2str(n),';']);
    inputM(inputM == -1) = 0;
    inputM(inputM == 3.1 | inputM == 3.2 | inputM == 3.3) = 1;
    inputM(inputM == 1.3) = 3;
    inputM(inputM == 1.2) = 4;
    inputM(inputM == 1.1) = 5;
    inputM(inputM == -2) =  6;
    % crop flat muscle(only needed for breast models from UWM)
    slice1 = squeeze(inputM(:,150,:));
    line1 = slice1(:,1);
    n2loc = find(line1==6,1);
    %n2loc = find(line1==6,1);
    inputM= int8(inputM(1:n2loc-1,:,:));
    eval(['Breast.uwm',num2str(n),'=inputM;']);
end
%inputM dimension (back to front,  head to toe, center to left arm )

%% Read breast models from Duke University http://deckard.duhs.duke.edu/railabs/index.html
addpath('C:\Users\xin\Documents\Breast Morph\version 5\MATLAB\Scripts Version 12_8_2017\Duke breast models');
Breast.CTA1 = ReadRaw('CTA0414_SEGMENT_369_431_259_uint8_LE.raw',369,431,259,'int8','LittleEndian');
Breast.CTA2 = ReadRaw('CTA0680_SEGMENT_466_456_274_uint8_LE.raw',466,456,274,'int8','LittleEndian');
Breast.CTA3 = ReadRaw('CTA0747_SEGMENT_401_479_342_uint8_LE.raw',401,479,342,'int8','LittleEndian');
Breast.CTA4 = ReadRaw('CTA0781_SEGMENT_345_411_173_uint8_LE.raw',345,411,173,'int8','LittleEndian');
Breast.CTA5 = ReadRaw('CTA1008_SEGMENT_435_539_510_uint8_LE.raw',435,539,510,'int8','LittleEndian');
Breast.CTA6 = ReadRaw('CTA1065_SEGMENT_584_707_479_uint8_LE.raw',584,707,479,'int8','LittleEndian');
Breast.CTA7 = ReadRaw('CTA1200_SEGMENT_641_677_487_uint8_LE.raw',641,677,487,'int8','LittleEndian');
Breast.CTA8 = ReadRaw('CTA1209_SEGMENT_658_831_469_uint8_LE.raw',658,831,469,'int8','LittleEndian');
Breast.CTA9 = ReadRaw('CTA1285_SEGMENT_497_529_361_uint8_LE.raw',497,529,361,'int8','LittleEndian');
Breast.CTA10 = ReadRaw('CTA1316_SEGMENT_767_746_510_uint8_LE.raw',767,746,510,'int8','LittleEndian');

for n = 1:10
    eval(['inputM = Breast.CTA',num2str(n),';']);
    inputM = permute(inputM,[3 2 1]);% change oriatation
    inputM  = int8(inputM(end:-1:1,:,:));
    eval(['Breast.CTA',num2str(n),'= inputM;']);
end

% Breast Phantom Parameters
% Immersion Medium (air)                            0
% Skin                                              6
% 100% glandular density (pure glandular tissue)    5
% 75% glandular density                             4
% 50% glandular density                             3
% 25% glandular density                             2
% 0% glandular density (fat)                        1
%inputM dimension (back to front,  head to toe, center to left arm )
%%
names = {'uwm1','uwm2','uwm3','uwm4','uwm5','uwm6','uwm7','uwm8','uwm9','CTA1','CTA2','CTA3','CTA5','CTA6','CTA7','CTA8','CTA9','CTA10'};
for step = 1:18
%     step = 18;
    tic
    loadmodel = char(names(step));
    eval(['Leftbreast = Breast.',loadmodel,';']);
    
    % exeflag=0;
    % Leftbreast = Breast.CTA7;
    %  Leftbreast =  permute(Leftbreast,[1 3 2]); % for CTA breast
    
    % if(strcmp(loadmodel,'CTA1'))
    %     rotateangle = 0;exeflag=1;
    % elseif(strcmp(loadmodel,'CTA2'))
    %     rotateangle = 0;exeflag=1;
    % elseif(strcmp(loadmodel,'CTA3'))
    %     rotateangle = 0;exeflag=1;
    % elseif(strcmp(loadmodel,'CTA4'))
    %     rotateangle = 0;exeflag=1;
    % elseif(strcmp(loadmodel,'CTA5'))
    %     rotateangle = 0;exeflag=1;
    % elseif(strcmp(loadmodel,'CTA8'))
    %     rotateangle = 0;exeflag=1;
    % end
    % if(exeflag==1)
    %     frame1=imrotate(squeeze(Leftbreast(1,:,:)),rotateangle);
    %     Leftbreast2=zeros(size(Leftbreast,1),size(frame1,1),size(frame1,2));
    %     for h1=1:size(Leftbreast,1)
    %         frametemp=imrotate(squeeze(Leftbreast(h1,:,:)),rotateangle);
    %         Leftbreast2(h1,:,:)=frametemp;
    %     end
    %     Leftbreast=Leftbreast2;
    %     if(strcmp(loadmodel,'CTA4'))
    %         Leftbreast=Leftbreast(:,:,50:end-20);
    %     end
    % end
    %
    
    % rotateangle = 180;
    % frame1=imrotate(squeeze(Leftbreast(1,:,:)),rotateangle);
    % Leftbreast2=zeros(size(Leftbreast,1),size(frame1,1),size(frame1,2));
    % for h1=1:size(Leftbreast,1)
    %     frametemp=imrotate(squeeze(Leftbreast(h1,:,:)),rotateangle);
    %     Leftbreast2(h1,:,:)=frametemp;
    % end
    % Leftbreast=Leftbreast2;
    % Leftbreast=Leftbreast(:,:,50:end-20);
    
    Xmin=185;Xmax=527;Zmin=681;Zmax=1144;
    Lvoxel= Ella(:,Zmin:Zmax,Xmin:Xmax); %chestdata dimension (left arm to right arm, back to front,  head to toe, )
    Lvoxelorigion = [Zmin,Xmin];
    
    Xmin2=528;Xmax2=864;Zmin2=681;Zmax2=1144;
    Rvoxel= Ella(:,Zmin2:Zmax2,Xmin2:Xmax2);
    Rvoxelorigion = [Zmin2,Xmin2];
    
    
    
    if(strcmp(loadmodel,'uwm1'))
        ratio1 = 0.9; ratio2 = 0.87; ratio3 = 1.20;%%height, length, width
        Leftbreastorigion=[734,220];
    elseif(strcmp(loadmodel,'uwm2'))
        ratio1 = 1.09; ratio2 = 0.80; ratio3 = 0.96;
        Leftbreastorigion=[730,230];
    elseif(strcmp(loadmodel,'uwm3'))
        ratio1 = 1; ratio2 = 0.88; ratio3 = 0.93;
        Leftbreastorigion=[728,222];
    elseif(strcmp(loadmodel,'uwm4'))
        ratio1 = 0.98; ratio2 = 0.78; ratio3 = 1.18;
        Leftbreastorigion=[742,210];
    elseif(strcmp(loadmodel,'uwm5'))
        ratio1 = 1.15; ratio2 = 1.22; ratio3 = 1.18;
        Leftbreastorigion=[740,222];
    elseif(strcmp(loadmodel,'uwm6'))
        ratio1 = 1.1; ratio2 = 0.9; ratio3 = 1.55;
        Leftbreastorigion=[743,213];
    elseif(strcmp(loadmodel,'uwm7'))
        ratio1 = 1.2; ratio2 = 0.84; ratio3 = 1.19;
        Leftbreastorigion=[742,213];
    elseif(strcmp(loadmodel,'uwm8'))
        ratio1 = 1.5; ratio2 = 1.38; ratio3 = 1.08;
        Leftbreastorigion=[733,213];
    elseif(strcmp(loadmodel,'uwm9'))
        ratio1 = 1.4; ratio2 = 0.96; ratio3 = 1.5;
        Leftbreastorigion=[738,213];
    elseif(strcmp(loadmodel,'CTA1'))
         ratio1 = 0.9;ratio2 = 0.55; ratio3 = 0.58;
        Leftbreastorigion=[753,255];
    elseif(strcmp(loadmodel,'CTA2'))
        ratio1 = 0.9;ratio2 = 0.55; ratio3 = 0.48; 
        Leftbreastorigion=[753,240];
    elseif(strcmp(loadmodel,'CTA3'))
        ratio1 = 0.73;ratio2 =0.52; ratio3 = 0.55; 
        Leftbreastorigion=[753,240];
    elseif(strcmp(loadmodel,'CTA5'))
        ratio1 = 0.45;ratio2 = 0.47; ratio3 = 0.46; 
        Leftbreastorigion=[755,253];
    elseif(strcmp(loadmodel,'CTA6'))
         ratio1 = 0.5;ratio2 = 0.34; ratio3 = 0.36;
        Leftbreastorigion=[759,246];
    elseif(strcmp(loadmodel,'CTA7'))
         ratio1 = 0.51;ratio2 = 0.35; ratio3 = 0.36;
        Leftbreastorigion=[753,243];
    elseif(strcmp(loadmodel,'CTA8'))
         ratio1 = 0.57;ratio2 = 0.37; ratio3 = 0.34;
        Leftbreastorigion=[753,250];
    elseif(strcmp(loadmodel,'CTA9'))
         ratio1 = 0.68;ratio2 = 0.47; ratio3 = 0.43;
        Leftbreastorigion=[755,250];
    elseif(strcmp(loadmodel,'CTA10'))
         ratio1 = 0.45;ratio2 = 0.33; ratio3 = 0.31;%%height, length, width
        Leftbreastorigion=[758,240];
    end
    
    
    % ratio1 = 0.8; ratio2 = 0.32; ratio3 = 0.37;
    %uwm1: ratio1 = 0.8; ratio2 = 0.83; ratio3 = 1.2; %uwm2: ratio1 = 0.8; ratio2 = 0.8; ratio3 = 1.07;
    %uwm3: ratio1 = 0.8; ratio2 = 0.88; ratio3 = 1.03; %uwm4:ratio1 = 0.8; ratio2 = 0.78; ratio3 = 1.19;
    %uwm5:ratio1 = 0.8; ratio2 = 1.2; ratio3 = 1.25; %uwm6:ratio1 = 0.8; ratio2 = 0.9; ratio3 = 1.71;
    %uwm7:ratio1 = 0.8; ratio2 = 0.85; ratio3 = 1.31; %uwm8:ratio1 = 0.8; ratio2 = 1.4; ratio3 = 1.2;
    %uwm9:ratio1 = 0.8; ratio2 = 0.97; ratio3 = 1.6;
    %CTA1:ratio1 = 0.8; ratio2 = 0.54; ratio3 = 0.63;rotateangle = 10;Leftbreast=Leftbreast(:,:,:);
    %CTA2:ratio1 = 0.8; ratio2 = 0.58; ratio3 = 0.51;rotateangle = -50;Leftbreast=Leftbreast(:,:,:);
    %CTA3:ratio1 = 0.8; ratio2 = 0.52; ratio3 = 0.6;rotateangle = 20;Leftbreast=Leftbreast(:,:,:);
    %CTA4:ratio1 = 0.8; ratio2 = 0.55; ratio3 = 0.77;rotateangle = -20;Leftbreast=Leftbreast(:,:,50:end-20);
    %CTA5:ratio1 = 0.8; ratio2 = 0.46; ratio3 = 0.47;rotateangle = 40;Leftbreast=Leftbreast(:,:,:);
    %CTA6:ratio1 = 0.8; ratio2 = 0.32; ratio3 = 0.37;rotateangle = 0;Leftbreast=Leftbreast(:,:,:);
    %CTA7:ratio1 = 0.8; ratio2 = 0.32; ratio3 = 0.37;rotateangle = 0;Leftbreast=Leftbreast(:,:,:);
    %CTA8:ratio1 = 0.8; ratio2 = 0.25; ratio3 = 0.37;rotateangle = 180;Leftbreast=Leftbreast(:,:,:);
    %CTA9:ratio1 = 0.8; ratio2 = 0.43; ratio3 = 0.45;rotateangle = 0;Leftbreast=Leftbreast(:,:,:);
    %CTA10:ratio1 = 0.8; ratio2 = 0.32; ratio3 = 0.32;rotateangle = 0;Leftbreast=Leftbreast(:,:,:);
    
    nx=floor(size(Leftbreast,1)*ratio1);ny=floor(size(Leftbreast,2)*ratio2);nz=floor(size(Leftbreast,3)*ratio3); % desired output dimensions, 89% of orignal size.
    [y,k,j]= ndgrid(linspace(1,size(Leftbreast,1),nx),...
        linspace(1,size(Leftbreast,2),ny),...
        linspace(1,size(Leftbreast,3),nz));
    Leftbreast =interp3(Leftbreast,k,y,j,'nearest'); %The default grid points cover the region, X=1:n, Y=1:m, Z=1:p, where [m,n,p] = size(V).
    
    testlength = size(Leftbreast,3)+ (Leftbreastorigion(2)-Xmin)-size(Lvoxel,3);
    if testlength >= 0
        Leftbreast = Leftbreast( :,:,       1:end-testlength-1   );
    end
    
    
    Rightbreast=flip(Leftbreast,3);%mirro for right breast
    
    
    %uwm1:Leftbreastorigion=[743,209]
    savedpath = 'C:\Users\xin\Documents\Breast Morph\version 5\MATLAB\Scripts Version 12_8_2017\figure1\';
    [Leftbreastorigion, Rightbreastorigion]= plotbreastlocation(Leftbreast,Rightbreast,ZProject,MuscleBone,Leftbreastorigion,...
        Xmin,Xmax,Zmin,Zmax,Xmin2,Xmax2,Zmin2,Zmax2, 882.5, 359,[savedpath, loadmodel]);
    disp(loadmodel);
end
    %%
    %
    %
    % Fat is the fat or breast fat tissue on top of Pect. Muscle.
    % only takes a portaion (about half) of the total voxel, faster comput.
    % Ella tissue types are from 0 to 76.
    % Breast tissure types:
    %Breast Phantom Parameters
    % Immersion Medium (air)                            0
    % Skin                                              86
    % 100% glandular density (pure glandular tissue)    85
    % 75% glandular density                             84
    % 50% glandular density                             83
    % 25% glandular density                             82
    % 0% glandular density (fat)                        81
    
    path2 = 'C:\Users\xin\Documents\Breast Morph\version 5\MATLAB\Scripts Version 12_8_2017\joint_figure\';
    %
    %
    % Chestdata= Ella(200:end,Zmin2:Zmax2,:);
    % %  MuscleBone = Ellacontour(Ella2);
    % %  MuscleBone = permute(MuscleBone, [2 1]);
    % %  MuscleBone = logical(MuscleBone(Zmin2:Zmax2,Xmin2:Xmax2));
    % %  figure(33);imagesc(MuscleBone);axis equal; axis tight; axis off;
    % Chestdata(Chestdata ~= 22 & Chestdata ~= 23) = 0;% Model voxel value: Bone is 23, muscle is 22 and breast is 43.
    % Chestdata = logical(Chestdata);
    % %figure(10096);imagesc(squeeze(AddSpace_breast(:,100,:)));axis equal; axis tight;
    % display('Image-colse morpholging...')
    % tic
    % [ClosePec] = ImClose(Chestdata, 15);
    % toc
    
    load('Pectoral.mat');
    %
    LClosePec=  ClosePec(:,:,Xmin:Xmax); %chestdata dimension (left arm to right arm, back to front,  head to toe, )
    RClosePec=  ClosePec(:,:,Xmin2:Xmax2);
    
    %
    
    
    Leftbreast(Leftbreast ~=0) = Leftbreast(Leftbreast ~=0) + 80;
    % figure(1004);imagesc(squeeze(Leftbreast(:,107,:)));axis equal; axis tight;
    figure(1005);imagesc(squeeze(Lvoxel(:,:,174)));axis equal; axis tight;
    % figure(1006);imagesc(squeeze(ClosePec(:,190,:)));axis equal; axis tight;
    
    BreastExtrusion_Left = BreastExtrusion_Ella(Leftbreast,Lvoxel,LClosePec, Lvoxelorigion,Leftbreastorigion);
    
%     if(strcmp(loadmodel(1),'C'))
%         Skinwall1=  BreastExtrusion_Left(216:358,:,70:109);
%         Skinwall1(Skinwall1==82|Skinwall1==83|Skinwall1==84|Skinwall1==85|Skinwall1==86) = 81;
%         BreastExtrusion_Left(216:358,:,70:109) = Skinwall1;
%         Skinwall2=  BreastExtrusion_Left(381:419,:,231:286);
%         Skinwall2(Skinwall2==82|Skinwall2==83|Skinwall2==84|Skinwall2==85|Skinwall2==86) = 81;
%         BreastExtrusion_Left(381:419,:,231:286)= Skinwall2;
%         Skinwall3=  BreastExtrusion_Left(324:412,291:314,:);
%         Skinwall3(Skinwall3==82|Skinwall3==83|Skinwall3==84|Skinwall3==85|Skinwall3==86) = 81;
%         BreastExtrusion_Left(324:412,291:314,:)= Skinwall3;
%     end
    
    LeftAxial = squeeze(BreastExtrusion_Left(:,202,:));
    LeftAxial(LeftAxial ==43)= 81;
     LeftSagittal = squeeze(BreastExtrusion_Left(:,:,174));
     LeftSagittal(LeftSagittal ==43)= 81;
    figure10 = figure(100920);imagesc(LeftAxial);axis equal; axis tight;colormap(jet(50));caxis([0 86]);title('Axial')
    saveas(figure10,[path2,loadmodel,'Left_Axial.fig']);
    
    figure12 = figure(100922);imagesc(LeftSagittal);axis equal; axis tight;colormap(jet(50));caxis([0 86]);title('Sagittal')
    saveas(figure12,[path2,loadmodel,'Left_sagittal.fig']);
    
    %
    Rightbreast(Rightbreast ~=0) = Rightbreast(Rightbreast ~=0) + 80;
    BreastExtrusion_Right = BreastExtrusion_Ella(Rightbreast,Rvoxel,RClosePec, Rvoxelorigion,Rightbreastorigion);
    
    
%     if(strcmp(loadmodel(1),'C'))
%         Skinwall1=  BreastExtrusion_Right(239:369,:,228:275);
%         Skinwall1(Skinwall1==82|Skinwall1==83|Skinwall1==84|Skinwall1==85|Skinwall1==86) = 81;
%         BreastExtrusion_Right(239:369,:,228:275) = Skinwall1;
%         Skinwall2=  BreastExtrusion_Right(388:420,:,78:108);
%         Skinwall2(Skinwall2==82|Skinwall2==83|Skinwall2==84|Skinwall2==85|Skinwall2==86) = 81;
%         BreastExtrusion_Right(388:420,:,78:108)= Skinwall2;
%     end
%     
    
    
    
    RightAxial = squeeze(BreastExtrusion_Right(:,202,:));
    RightAxial(RightAxial ==43)= 81;
    figure11 = figure(100921);imagesc(RightAxial);axis equal; axis tight;colormap(jet(50));caxis([0 86]);
    saveas(figure11,[path2,loadmodel,'Right_axial.fig']);    
    combinedimage = zeros(    size(LeftAxial,1),size(LeftAxial,2)+ ...
        size(RightAxial,2)  );
    combinedimage(:,1:size(LeftAxial,2)) = LeftAxial;
    combinedimage(:,size(LeftAxial,2)+1:size(LeftAxial,2)+size(RightAxial,2)) = RightAxial;
    
    figure101 = figure(1009220);imagesc(combinedimage);axis equal; axis tight;colormap(jet(50));caxis([0 86]);
    saveas(figure101,[path2,loadmodel,'Combined_axial.fig']);
    
    save([loadmodel,'.mat'],'BreastExtrusion_Left','BreastExtrusion_Right')   
end
    
    %%
    names = {'uwm1','uwm2','uwm3','uwm4','uwm5','uwm6','uwm7','uwm8','uwm9','CTA1','CTA2','CTA3','CTA5','CTA6','CTA7','CTA8','CTA9','CTA10'};
    for step = 1:18;
            loadmodel = char(names(step));

    
%     
%       if(strcmp(loadmodel,'uwm1'))
%         Lstart = 357; Lfinish = 440;
%         Rstart = 354; Rfinish = 440;
%     elseif(strcmp(loadmodel,'uwm2'))
%      Lstart = 357; Lfinish = 440;
%         Rstart = 354; Rfinish = 440;
%     elseif(strcmp(loadmodel,'uwm3'))
%          Lstart = 357; Lfinish = 440;
%         Rstart = 354; Rfinish = 440;
%     elseif(strcmp(loadmodel,'uwm4'))
%        Lstart = 357; Lfinish = 440;
%         Rstart = 354; Rfinish = 440;
%     elseif(strcmp(loadmodel,'uwm5'))
%      Lstart = 357; Lfinish = 440;
%         Rstart = 354; Rfinish = 440;
%     elseif(strcmp(loadmodel,'uwm6'))
%          Lstart = 357; Lfinish = 440;
%         Rstart = 354; Rfinish = 440;
%     elseif(strcmp(loadmodel,'uwm7'))
%          Lstart = 346; Lfinish = 440;
%         Rstart = 346; Rfinish = 440;
%     elseif(strcmp(loadmodel,'uwm8'))
%           Lstart = 346; Lfinish = 440;
%         Rstart = 346; Rfinish = 440;
%     elseif(strcmp(loadmodel,'uwm9'))
%           Lstart = 346; Lfinish = 440;
%         Rstart = 346; Rfinish = 440;
%     elseif(strcmp(loadmodel,'CTA1'))
%          Lstart = 346; Lfinish = 440;
%         Rstart = 346; Rfinish = 440;
%     elseif(strcmp(loadmodel,'CTA2'))
%         ratio1 = 0.9;ratio2 = 0.55; ratio3 = 0.48; 
%         Leftbreastorigion=[753,240];
%     elseif(strcmp(loadmodel,'CTA3'))
%         ratio1 = 0.73;ratio2 =0.52; ratio3 = 0.55; 
%         Leftbreastorigion=[753,240];
%     elseif(strcmp(loadmodel,'CTA5'))
%         ratio1 = 0.45;ratio2 = 0.47; ratio3 = 0.46; 
%         Leftbreastorigion=[755,253];
%     elseif(strcmp(loadmodel,'CTA6'))
%          ratio1 = 0.5;ratio2 = 0.34; ratio3 = 0.36;
%         Leftbreastorigion=[759,246];
%     elseif(strcmp(loadmodel,'CTA7'))
%          ratio1 = 0.51;ratio2 = 0.35; ratio3 = 0.36;
%         Leftbreastorigion=[753,243];
%     elseif(strcmp(loadmodel,'CTA8'))
%          ratio1 = 0.57;ratio2 = 0.37; ratio3 = 0.34;
%         Leftbreastorigion=[753,250];
%     elseif(strcmp(loadmodel,'CTA9'))
%          ratio1 = 0.68;ratio2 = 0.47; ratio3 = 0.43;
%         Leftbreastorigion=[755,250];
%     elseif(strcmp(loadmodel,'CTA10'))
%          ratio1 = 0.45;ratio2 = 0.33; ratio3 = 0.31;%%height, length, width
%         Leftbreastorigion=[758,240];
%     end
     Lstart = 357; Lfinish = 440;
     Rstart = 354; Rfinish = 440;
 
    load([loadmodel,'.mat']);
    Levelset(BreastExtrusion_Left,[loadmodel,'Leftbreast'],Lstart,Lfinish);
    Levelset(BreastExtrusion_Right,[loadmodel,'Rightbreast'],Rstart,Rfinish);
    
    end
    
    
