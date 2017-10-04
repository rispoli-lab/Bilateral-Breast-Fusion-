% merge two joints inthe same dimensions together in bottom to top ordering in the x direction, 
% the background is zero and joints are nonzero.
%input: joint1 joint2 
%output: merged joint
function [joint] = curveMerge(part1, part2)
joint1 = part1;
joint2 = zeros(size(joint1));
joint2(1:size(part2,1),:,:) = part2;  % make joint2 in the same dimensions as joint1
[x2,y2,z2] = ind2sub(size(joint2),find(joint2)); % find subscripts of nonzeros of joint2 
 x2 = x2 + size(joint2,1) - max(x2(:)); % move the part2 to the bottom
 linearInd = sub2ind(size(joint2),x2,y2,z2);
 [trash,trash,v] = find(joint2);
 joint2 = zeros(size(joint2)); joint2(linearInd) = v;
 if  find(joint1(min(x2(:)),:,:)) ~= 0
     error('Cannot joint these two, need more space');
     return
 end 
 n2 = floor(size(joint2,2)/2);
 n3 = floor(size(joint2,3)/2);
 n1 = find(joint2(:,n2,n3), 1); % prob the height of the center of joint2
 while joint1(n1,n2,n3) == 0 % move the part2 up untill encounter the part1
     n1 = n1 -1;
     x2 = x2 -1;
 end
 linearInd = sub2ind(size(joint2),x2,y2,z2);
 [trash,trash,v] = find(joint2);
 joint = joint1;
 joint(linearInd) = v;% assign nozeros of moved part to the linear index in joint1 
end
