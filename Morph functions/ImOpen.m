function [OpenImage]= ImOpen(inPectoralMuscle, kernalR)
%inPectoralMuscle(inPectoralMuscle ~= 22) = 0;% only the muscle remained and convert to BW volume
%inPectoralMuscle(inPectoralMuscle == 22) = 1;
inPectoralMuscle = logical(inPectoralMuscle); % Input should be binary
ball = BK3d(kernalR);
EroImage = imerode(inPectoralMuscle,ball); % image dilation 
DiaImage = imdilate(EroImage, ball); % image erosion
OpenImage = DiaImage;
end