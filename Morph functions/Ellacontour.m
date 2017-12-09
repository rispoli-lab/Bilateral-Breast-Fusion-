function ZProject = Ellacontour(Ella)
% Plot a 2D contour map of Ella. 
% Imported Ella model in matlab dimensions(left_arm to right_arm, back to front, head to toe)
ZProject = zeros(size(Ella,1),size(Ella,3));
for i = 1:size(Ella,1)
    for k = 1:size(Ella,3)
        for j = size(Ella,2):-1: 1
            if Ella(i,j,k) ~= 0
                ZProject(i,k) = j;
                break 
            end
        end
    end
end
imagesc(ZProject);axis equal; axis tight; axis off
end