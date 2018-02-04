function ZProject = Ellacontour(Ella)
% Plot a 2D contour map of Ella. 
% Imported Ella model in matlab dimensions(left_arm to right_arm, back to front, head to toe)
ZProject = zeros(size(Ella,3),size(Ella,2));
for j = 1:size(Ella,2)
    for k = 1:size(Ella,3)
        for i = size(Ella,1):-1: 1
            if Ella(i,j,k) ~= 0
                ZProject(k,j) = i;
                break 
            end
        end
    end
end
% figure(11);imagesc(ZProject);axis equal; axis tight;
% set(gca,'YDir','normal');
end