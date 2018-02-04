% Apply level-set function on the left breast
% margin, or zero padding
function [] = Levelset_Hanako(BreastExtrusion,loadmodel,start,finish)

% BreastExtrusion(341,79,end-6) = 23; % defect of model
path2 = 'C:\Users\xin\Documents\Breast Morph\version 5\MATLAB\Scripts Version 12_8_2017\Hanako_Levelset';
image1 = squeeze(BreastExtrusion(:,43,:));
%image1(image1 == 51) = 60; %skin
 image1(image1 == 48) = 15;% SAT
 image1(image1 == 49) = 35;%pectoral muscle
image1(image1 == 86 | image1 == 51) = 60;
image1(image1 == 85) = 40;
image1(image1 == 84) = 36;
image1(image1 == 83) = 30;
image1(image1 == 82) = 26;
image1(image1 == 81) = 11;
figure1 = figure(100811511);imagesc(image1);axis equal; axis tight;title('Before level-set (Axial)');
set(gca,'FontSize', 18);colormap(hot(22));caxis([0 60]);
saveas(figure1,[path2,'\',loadmodel,'Before_level_set_Axial.fig']);


image2 = squeeze(BreastExtrusion(:,:,32));
%image2(image2 == 27) = 60; %skin
 image2(image2 == 48) = 15;% SAT
 image2(image2 == 49) = 35;%pectoral muscle
image2(image2 == 86 | image2 == 51) = 60;
image2(image2 == 85) = 40;
image2(image2 == 84) = 36;
image2(image2 == 83) = 30;
image2(image2 == 82) = 26;
image2(image2 == 81) = 11;
figure2 = figure(100811512);imagesc(image2);axis equal; axis tight;title('Before level-set (Saggital)');
set(gca,'FontSize', 18);colormap(hot(22));caxis([0 60]);
saveas(figure2,[path2,'\',loadmodel,'Before_levele_set_Saggital.fig']);


%start = 363; finish = 436; % uwm1
%Breastnew = RmBreast(start:finish,:,:);% need to check if make sense, ex. the portion that is needed to smooth is right.
%Breastjoint = BreastExtrusion(start:finish,:,:);% need to check if make sense, ex. the portion that is needed to smooth is right.
ma = 2;
if strcmp(loadmodel(5),'L')
ma2 = 10 ;% need to check if make sense, ex. the portion that is needed to smooth is right.
ma3 = ma;
else
   ma2 = ma;
   ma3 = 15;
end
Breastjoint = BreastExtrusion(start:finish,:,:);% need to check if make sense, ex. the portion that is needed to smooth is right.


% figure(1005);imagesc(squeeze(BreastExtrusion(:,:,150)));axis equal; axis tight;set(gca,'YDir','normal')

Breastjoint(1: ma,:,:) = 0;   
Breastjoint(end-ma:end,:,:)=0;
Breastjoint(:,1:ma,:)= 0;
Breastjoint(:,end-ma:end,:)=0;
Breastjoint(:,:,1:ma2)=0;
Breastjoint(:,:,end-ma3:end)=0;
Breastjoint = logical(Breastjoint); % need to check if make sense.
Breastboundary = zeros(size(Breastjoint));
% figure(9);imagesc(squeeze(Breastjoint(:,190,:)));axis equal; axis tight;

% [Fx,Fy,Fz] = gradient(double(Breastnew));
% sd= abs(Fx) + abs(Fy) +abs(Fz); % nozero boundaries are saved in sd
 for i = 1:size(Breastjoint,1)
    for j = 1:size(Breastjoint,2)
        for k = 1:size(Breastjoint,3)
             if Breastjoint(i,j,k) ~= 0
                 
                 
                 for n1 = -1:1:1
                     for n2 = -1:1:1
                         for n3 = -1:1:1
                            if Breastjoint(i+n1,j+n2,k+n3)== 0
                                Breastboundary(i,j,k) = 1;
                            end
                         
                         end
                     end
                 end
                                
                 
             end
        end
    end
 end
Breastboundary = logical(Breastboundary);
figure3 = figure(91);imagesc(  imfill(squeeze(Breastboundary(:,43,:)), 'holes') );axis equal; axis tight;title('Joint with un-natural curvature');set(gca,'FontSize', 18);
saveas(figure3,[path2,'\',loadmodel,'Joint_with_un_natural_curvature.fig']);
%

Signeddistance = bwdist(Breastboundary); % unsigned distance transformation
figure(1007);imagesc(squeeze(Signeddistance(:,43,:)));axis equal; axis tight;

 for i = 1:size(Signeddistance,1)
    for j = 1:size(Signeddistance,2)
        for k = 1:size(Signeddistance,3)
            if Breastjoint(i,j,k) ~= 0
                Signeddistance(i,j,k) = -Signeddistance(i,j,k);
            end
        end
    end
 end
% figure(1008);imagesc(squeeze(Signeddistance(:,190,:)));axis equal; axis tight; 
%
display('Applying level-set method ...')
 tic
 [ data, g, data0 ] = LSinp('low',Signeddistance,9,1/50);%9 for NICT model. call level set function.the level set result is stored in data 
 toc
% tic
% [ data2, g, data0 ] = LSinp('high',Signeddistance,4,1/50);%9 for NICT model. call level set function.the level set result is stored in data 
% toc
%


smoothedjoint = data; %
smoothedjoint(smoothedjoint<0)=100;%0.009 need to check here 
smoothedjoint(smoothedjoint~=100)=0;
smoothedjoint(smoothedjoint==100)=1;
smoothedjoint = logical(smoothedjoint);
smoothedjoint = imfill(smoothedjoint,'holes'); % same as Breastjoint dimsions

figure4 = figure(1001);imagesc(squeeze(smoothedjoint(:,43,:)));axis equal; axis tight;title('Joint with natural curvature');set(gca,'FontSize', 18);
saveas(figure4,[path2,'\',loadmodel,'Joint_with_natural_curvature.fig']);
%
smoothedbreastchest = BreastExtrusion;
for i = start+1:finish-1
    for j = 2:size(BreastExtrusion,2)-1
        for k = 2:size(BreastExtrusion,3)-1
           
            if smoothedjoint(i-start+1,j,k)==1 
                
                if smoothedbreastchest(i,j,k) == 0
                    smoothedbreastchest(i,j,k) = 100;% subcutaneouse fat 30
                end
                
                if smoothedbreastchest(i,j,k)== 51 %skin
                    smoothedbreastchest(i,j,k) = 101;% subcutaneouse fat 30
                end
                
                if smoothedbreastchest(i,j,k)== 86 
                    smoothedbreastchest(i,j,k) = 100;% subcutaneouse fat 30
                end
                                                          
            end    
            
            
        end
    end
end
% figure(1002);imagesc(squeeze(smoothedbreastchest(:,43,:)));axis equal; axis tight;colormap(hot(100));caxis([0 101]);

% takeoutskin = smoothedbreastchest(start-50:start+1,:,:);
% takeoutskin(takeoutskin==51) = 101; % subcutaneouse fat 30
% smoothedbreastchest(start-50:start+1,:,:) = takeoutskin;

% %
for i = start:finish-1
    for j = 2:size(smoothedbreastchest,2)-1
        for k = 2:size(smoothedbreastchest,3)-1
   
              if smoothedbreastchest(i,j,k) ~= 0

                 for n1 = -1:1:1
                     for n2 = -1:1:1
                         for n3 = -1:1:1 
                            
                            if smoothedbreastchest(i + n1  ,j + n2 ,  k + n3)== 0 
                               smoothedbreastchest(i,j,k) = 86; % skin
                            end
                            
                         end
                     end         
                 end
                 
                 
                 
              end
                 
                 
        end
    end
end

image1 = squeeze(smoothedbreastchest(:,43,:));
 image1(image1 == 48) = 15;% SAT
 image1(image1 == 49) = 35;%pectoral muscle
image1(image1 == 86 | image1 == 51) = 60;
image1(image1 == 100 | image1 == 101) = 30; %subcutaneouse fat
image1(image1 == 86) = 60;
image1(image1 == 85) = 40;
image1(image1 == 84) = 36;
image1(image1 == 83) = 30;
image1(image1 == 82) = 26;
image1(image1 == 81) = 11;
figure5 = figure(1003);imagesc(image1);axis equal; axis tight;title('After level-set (Axial)');
set(gca,'FontSize', 18);colormap(hot(22));caxis([0 60]);
saveas(figure5,[path2,'\',loadmodel,'After_level_set_Axial.fig']);

image2 = squeeze(smoothedbreastchest(:,:,32));
 image1(image1 == 48) = 15;% SAT
 image1(image1 == 49) = 35;%pectoral muscle
image1(image1 == 86 | image1 == 51) = 60;
image2(image2 == 100 | image2 == 101) = 30; %subcutaneouse fat
image2(image2 == 86) = 60;
image2(image2 == 85) = 40;
image2(image2 == 84) = 36;
image2(image2 == 83) = 30;
image2(image2 == 82) = 26;
image2(image2 == 81) = 11;
figure6 = figure(1004);imagesc(image2);axis equal; axis tight;title('After level-set (Saggital)');
set(gca,'FontSize', 18);colormap(hot(22));caxis([0 60]);
saveas(figure6,[path2,'\',loadmodel,'After_level_set_Saggital.fig']);

save([path2,'\',loadmodel,'.mat'],'smoothedbreastchest')  


smoothedbreastchest(smoothedbreastchest< 80) =0;
% image2 = squeeze(smoothedbreastchest(:,:,199));
% image2(image2 == 27) = 60; %skin
% image2(image2 == 100 | image2 == 101) = 30; %subcutaneouse fat
% image2(image2 == 86) = 60;
% image2(image2 == 85) = 40;
% image2(image2 == 84) = 36;
% image2(image2 == 83) = 30;
% image2(image2 == 82) = 26;
% image2(image2 == 81) = 11;
% figure(1005);imagesc(image2);axis equal; axis tight;title('After levle-set (Saggital, breast only)');
% set(gca,'FontSize', 18);colormap(hot(22));caxis([0 60]);
Yplacement = 130;
Croppedbreastchest = smoothedbreastchest(Yplacement/2:end,:,:);
Croppedbreastchest(Croppedbreastchest==101)=100;
%figure(10041);imagesc(squeeze(Croppedbreastchest(:,43,:)));axis equal; axis tight;title('After level-set (Saggital)');
%
%writeToVOX( 'Rbreast11.vox', SBreast,'C:\Users\xin  \Documents\MATLAB\Scripts Version4\Import breast data');%[ ] = writeToVOX( filename, outputData, pathname)
name = loadmodel;
filesize = [size(Croppedbreastchest,1) , size(Croppedbreastchest,2) , size(Croppedbreastchest,3)];
path = ['C:\Users\xin\Documents\Breast Morph\version 5\MATLAB\Scripts Version 12_8_2017\Outputmodel\ForHanako\'];
WriteToVOX( [name,'.vox'], Croppedbreastchest, path);%[ ] = writeToVOX( filename, outputData, pathname)
WriteTommf( name, filesize, path,2);%[ ] = writeToVOX( filename, outputData, pathname)
end