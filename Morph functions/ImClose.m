function [CloseImage]= ImClose(inPectoralMuscle, kernalR)
%inPectoralMuscle(inPectoralMuscle ~= 22) = 0;% only the muscle remained and convert to BW volume
%inPectoralMuscle(inPectoralMuscle == 22) = 1;
inPectoralMuscle = logical(inPectoralMuscle);% Input should be binary
ball = BK3d(kernalR);
DiaImage = imdilate(inPectoralMuscle,ball); % image dilation 
EroImage = imerode(DiaImage, ball); % image erosion
CloseImage = EroImage;
end