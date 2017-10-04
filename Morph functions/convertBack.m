%take the 0 contour back to image space
%input is the reuslt contour 3D image
%output is a binary images show the 
function [out] = convertBack(input)
%ma = 10;
%result = input(ma+1:end-ma-1,ma+1:end-ma-1,ma+1:end-ma-1);%margin cut due to initial distance trans map has margin cut to zero
result = input; %
result(result<0)=100;%0.009 need to check here 
result(result~=100)=0;
result(result==100)=1;
result = logical(result);
out = imfill(result,'holes'); % mayby redundant
end
