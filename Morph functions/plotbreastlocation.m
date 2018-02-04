function [Leftbreastorigion, Rightbreastorigion]= plotbreastlocation(Leftbreast,Rightbreast,ZProject,MuscleBone,Leftbreastorigion,...
    Xmin,Xmax,Zmin,Zmax,Xmin2,Xmax2,Zmin2,Zmax2, coilcenter1 , coilcenter2,loadmodel)

[columnsInImage rowsInImage] = meshgrid(1:1060, 1:3360);
theta1=linspace(0,2*pi,1000);
Dr_outer = 386.8;
Dr_inner = 304;

allfigure=figure(123);imagesc(ZProject);axis equal;axis tight;set(gca,'YDir','normal');hold on;

MuscleBone = logical(MuscleBone);
[r1,c1]=find( MuscleBone ==1,  1 );
MuscleBonecontour = bwtraceboundary(MuscleBone,[r1,c1],'W');
plot(MuscleBonecontour(:,2),MuscleBonecontour(:,1),'c','linewidth',1);set(gca,'YDir','normal');hold on;% plot 24 pixel offset of curve

offsetz = -30;
txtx=(Zmax+Zmin)/2 +offsetz;txty=(Xmax+Xmin)/2;
circX_outer=coilcenter1 + Dr_outer/2*sin(theta1);
circY_outer=coilcenter2 + Dr_outer/2*cos(theta1);
plot(circX_outer,circY_outer,'k','linewidth',3);set(gca,'YDir','normal');hold on;%coil location

circX_inner=coilcenter1 + Dr_inner/2*sin(theta1);
circY_inner=coilcenter2 + Dr_inner/2*cos(theta1);
plot(circX_inner,circY_inner,'k','linewidth',3);set(gca,'YDir','normal');hold on;%coil location

rectangle('Position',[270,431,50,200],'FaceColor','w');set(gca,'YDir','normal');hold on;%cover face
% rectangle('Position',[1706,400,200,200],'FaceColor','w');set(gca,'YDir','normal');hold on;%cover virg
scatter(0,0,120,'w','filled');set(gca,'YDir','normal');hold on

% Xmin=227;Xmax=527;Zmin=681;Zmax=1144;

rectangle('Position',[Zmin,Xmin,Zmax-Zmin,Xmax-Xmin],'EdgeColor','g');set(gca,'YDir','normal');hold on;%left chest location

% Xmin2=528;Xmax2=824;Zmin2=681;Zmax2=1144;
% circX=(xmin+xmax)/2+Dr/2*sin(theta1);
% circY=(ymin+ymax)/2+Dr/2*cos(theta1);
rectangle('Position',[Zmin2,Xmin2,Zmax2-Zmin2,Xmax2-Xmin2],'EdgeColor','r');set(gca,'YDir','normal');hold on;%right chest location
scatter(Zmin,Xmin,40,'w','filled');set(gca,'YDir','normal');hold on % chestdata origion
scatter(Zmin2,Xmin2,40,'w','filled');set(gca,'YDir','normal');hold on 



Leftbreast = logical(Leftbreast);
scatter(Leftbreastorigion(1),Leftbreastorigion(2),40,'y','filled');set(gca,'YDir','normal');hold on 
rectangle('Position',[Leftbreastorigion(1),Leftbreastorigion(2),...
    size(Leftbreast,2),size(Leftbreast,3)],'EdgeColor','w');set(gca,'YDir','normal');hold on;%leftbreast location

breast1_Z = squeeze(sum(Leftbreast,1)); %axial projection
% figure(10201);imagesc(breast_Z);axis equal;axis tight; 
[r1,c1]=find(breast1_Z==1,1);
contour1_Z = bwtraceboundary(breast1_Z,[r1,c1],'W');

contour1_Z(:,1)=contour1_Z(:,1) + Leftbreastorigion(1);
contour1_Z(:,2)=contour1_Z(:,2) + Leftbreastorigion(2);


circlePixels1 = 0;
for h1=1:10:length(contour1_Z(:,2))
    circlePixels2 = (columnsInImage - contour1_Z(h1,2)).^2 ...
    + (rowsInImage - contour1_Z(h1,1)).^2 <= 24.^2 ;
    circlePixels1 = circlePixels2 + circlePixels1;
%  figure(1239);imagesc(circlePixels1);axis equal;axis tight;hold on;
end
Boundary = logical(circlePixels1);
[r2,c2]=find(Boundary==1,1);
contour_boundary = bwtraceboundary(Boundary,[r2,c2],'W');
plot(contour_boundary(:,1),contour_boundary(:,2),'w','linewidth',1);set(gca,'YDir','normal');hold on;% plot 24 pixel offset of curve

plot(contour1_Z(:,1),contour1_Z(:,2),'w','linewidth',3);set(gca,'YDir','normal');hold on;%plot axial projection


bottom = squeeze(Leftbreast(end,:,:)); 
[r1,c1]=find(bottom==1,1);
contour1_b = bwtraceboundary(bottom,[r1,c1],'W');
contour1_b(:,1) =  contour1_b(:,1)  + Leftbreastorigion(1); %-(min(contour1_b(:,1)) +max(contour1_b(:,1)))/2+(Xmin+Xmax)/2;
contour1_b(:,2) =  contour1_b(:,2) + Leftbreastorigion(2);%( min(contour1_b(:,2))+max(contour1_b(:,2)))/2+(Zmax+Zmin)/2 +offsetz;
plot(contour1_b(:,1),contour1_b(:,2),'m','linewidth',3);set(gca,'YDir','normal');hold on;%bottom is the bottom axial slice of breat model


% 515 824, 745 1144

Rightbreast = logical(Rightbreast);
Rightbreastorigion= [Leftbreastorigion(1),2*Xmin2 - Leftbreastorigion(2)-size(Rightbreast,3)];
rectangle('Position',[Rightbreastorigion(1),Rightbreastorigion(2),...
    size(Rightbreast,2),size(Rightbreast,3)],'EdgeColor','r');hold on;%Rightbreast location
 scatter(Rightbreastorigion(1),Rightbreastorigion(2),40,'y','filled');set(gca,'YDir','normal');hold on 
% plot right breast
breast2_Z = squeeze(sum(Rightbreast,1)); %axial projection
%  figure(10200);imagesc(breast_Z);axis equal;axis tight; 
[r1,c1]=find(breast2_Z==1,1);
contour2_Z = bwtraceboundary(breast2_Z,[r1,c1],'W');
contour2_Z(:,1)=contour2_Z(:,1)+ Rightbreastorigion(1);
contour2_Z(:,2)=contour2_Z(:,2)+ Rightbreastorigion(2);

plot(contour2_Z(:,1),contour2_Z(:,2),'r','linewidth',3);set(gca,'YDir','normal');hold on;
% text(txtx,2*Xmin2-txty,['x = ',num2str(txtx),', y = ',num2str(2*Xmin2-txty)]);

% plot 24 pixel offset of curve
circlePixels1 = 0;
for h1=1:10:length(contour2_Z(:,2))
    circlePixels2 = ( columnsInImage- contour2_Z(h1,2)).^2 ...
    + (rowsInImage - contour2_Z(h1,1)).^2 <= 24.^2 ;
    circlePixels1 = circlePixels2 + circlePixels1;
%     plot(circX1,circY1,'g','linewidth',1);hold on;
end
Boundary = logical(circlePixels1);
[r2,c2]=find(Boundary==1,1);
contour_boundary = bwtraceboundary(Boundary,[r2,c2],'W');
plot(contour_boundary(:,1),contour_boundary(:,2),'r','linewidth',1);hold off;
% figure(10200);imagesc(permute(breast1_Z,[2 1]));axis equal;axis tight;title('Left breast'); set(gca,'YDir','normal');
% figure(10201);imagesc(permute(breast2_Z,[2 1]));axis equal;axis tight; title('Right breast');set(gca,'YDir','normal');
% set(gcf,'position',[1921,1,1920,1004]); 
saveas(allfigure,[loadmodel,'_wholebody.fig']);
% left1=figure(10200);imagesc(permute(breast1_Z,[2 1]));axis equal;axis tight; title('Left breast');
% saveas(left1,[loadmodel,'_leftbreast.fig']);
% right1=figure(10201);imagesc(permute(breast2_Z,[2 1]));axis equal;axis tight; title('Right breast');
% saveas(right1,[loadmodel,'_rightbreast.fig']);
end          
              
              