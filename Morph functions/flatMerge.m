% merge two joints inthe same dimensions together in bottom to top ordering in the x direction, 
% the background is zero and joints are nonzero.
%input: joint1 joint2 
%output: merged joint
function [joint] = flatMerge(part1, part2)
joint1 = part1;
joint2 = zeros(size(joint1));
joint2(1:size(part2,1),:,:) = part2;  % make joint2 in the same dimensions as joint1
[x2,y2,z2] = ind2sub(size(joint2),find(joint2)); % find subscripts of nonzeros of joint2 
 x2 = x2 + size(joint2,1) - max(x2(:)); % move the part2 to the bottom
 if  find(joint1(min(x2(:)),:,:)) ~= 0
     error('Cannot joint these two, need more space');
     return
 end 
 while isempty(find(joint1(min(x2(:)),:,:),1)) % move the part2 up untill encounter the part1
     x2 = x2 -1;
 end
 linearInd = sub2ind(size(joint2),x2,y2,z2);
 [trash,trash,v] = find(joint2);
 joint = joint1;
 joint(linearInd) = v;% assign nozeros of moved part to the linear index in joint1 
end
