function [ data, g, data0 ] = LSinp(accuracy,datain,d,step)
% dumbbell1: recreate figure 14.2 from Sethian
%
%   [ data, g, data0 ] = dumbbell1(accuracy)
%
% Recreates figure 14.2 from Sethian chapter 14, 
%   showing motion by mean curvature of a 3D dumbbell shaped region.
%   This example is interesting because it shows pinch off and separation
%   of the implicit surface.
%
% The grid parameters have been chosen to try and get close to the figures.
%   The user can specify the curvature multiplier within the file.
%  
% This function was originally designed as a script file, so most of the
%   options can only be modified in the file.
%
% For example, edit the file to change the grid dimension, boundary conditions,
%   flow field parameters, etc.
%
% Parameters:
%
%   accuracy     Controls the order of the time approximation.
%                  'low'         Use odeCFL1 and upwindFirstFirst.
%                  'medium'      Use odeCFL2 and upwindFirstENO2 (default).
%                  'high'        Use odeCFL3 and upwindFirstENO3.
%                  'veryHigh'    Use odeCFL3 and upwindFirstWENO5.
%                Note that this parameter has no effect on the order
%                  of the spatial approximation, which is always order 2.
%
%   data         Implicit surface function at t_max.
%   g            Grid structure on which data was computed.
%   data0        Implicit surface function at t_0.

% Copyright 2004 Ian M. Mitchell (mitchell@cs.ubc.ca).
% This software is used, copied and distributed under the licensing 
%   agreement contained in the file LICENSE in the top directory of 
%   the distribution.
%
% Ian Mitchell, 5/17/04

%---------------------------------------------------------------------------
% You will see many executable lines that are commented out.
%   These are included to show some of the options available; modify
%   the commenting to modify the behavior.
  
%---------------------------------------------------------------------------
% Make sure we can see the kernel m-files.
%run('../addPathToKernel');
% run('addPathToKernel');

%---------------------------------------------------------------------------
% Default values.
if(nargin < 1)
  accuracy = 'medium';
end

% Curvature multiplier.
%   You can fiddle with either this or tMax to achieve the same effect.
b = d; %1 the small the faster. 

%---------------------------------------------------------------------------
% Integration parameters.
tMax = 0.0249; %0.025                 % End time.
plotSteps = 9;              % How many intermediate plots to produce?
t0 = 0;                      % Start time.
singleStep = 0;              % Plot at each timestep (overrides tPlot).

% Period at which intermediate plots should be produced.
tPlot = (tMax - t0) / (plotSteps - 1);

% How close (relative) do we need to get to tMax to be considered finished?
small = 100 * eps;

%---------------------------------------------------------------------------
% What level set should we view?
level = 0;

% Pause after each plot?
pauseAfterPlot = 0;

%---------------------------------------------------------------------------
% Create the grid.
% g.dim = 3;
% if mod(size(datain,1),2) ==0
%     xmin = -0.01*size(datain,1);
%     xmax = 0.01*(size(datain,1)-2);
% else
%     xmin = -0.01*(size(datain,1)-1);
%     xmax = 0.01*(size(datain,1)-1);
% end
% if mod(size(datain,2),2) ==0
%     ymin = -0.01*size(datain,2);
%     ymax = 0.01*(size(datain,2)-2);
% else
%     ymin = -0.01*(size(datain,2)-1);
%     ymax = 0.01*(size(datain,2)-1);
% end
% if mod(size(datain,3),2) ==0
%     zmin = -0.01*size(datain,3);
%     zmax = 0.01*(size(datain,3)-2);
% else
%     zmin = -0.01*(size(datain,3)-1);
%     zmax = 0.01*(size(datain,3)-1);
% end
% g.min =[xmin;ymin;zmin];%[-1.70;-3.52;-3.06 ];%[ -1.0; -0.5; -0.5 ]; % corresponding to size (171,352,307)
% g.max = [xmax;ymax;zmax];%[1.70; 3.50; 3.06];%[ +1.0; +0.5; +0.5 ];
% g.dx = 1 / 50;
% g.bdry = @addGhostExtrapolate;
% g = processGrid(g);

g.dim = 3;
% step = 1/50;
g.dx = step*2;
if mod(size(datain,1),2) ==0
    xmin = -step*size(datain,1);
    xmax = step*(size(datain,1)-2);
else
    xmin = -step*(size(datain,1)-1);
    xmax = step*(size(datain,1)-1);
end
if mod(size(datain,2),2) ==0
    ymin = -step*size(datain,2);
    ymax = step*(size(datain,2)-2);
else
    ymin = -step*(size(datain,2)-1);
    ymax = step*(size(datain,2)-1);
end
if mod(size(datain,3),2) ==0
    zmin = -step*size(datain,3);
    zmax = step*(size(datain,3)-2);
else
    zmin = -step*(size(datain,3)-1);
    zmax = step*(size(datain,3)-1);
end
g.min =[xmin;ymin;zmin];%[-1.70;-3.52;-3.06 ];%[ -1.0; -0.5; -0.5 ]; % corresponding to size (171,352,307)
g.max = [xmax;ymax;zmax];%[1.70; 3.50; 3.06];%[ +1.0; +0.5; +0.5 ];
g.bdry = @addGhostExtrapolate;
g = processGrid(g);

%---------------------------------------------------------------------------
% Create initial conditions (a dumbbell)
%radius = 0.3;			% Radius of the dumbbell spheres.
%offset = 0.5;			% Offset of the center of the dumbbell spheres.
%width = 0.2;			% Width of the dumbbell center cylinder.

% Right sphere.
% right = sqrt((g.xs{1} - offset).^2 + g.xs{2}.^2 + g.xs{3}.^2) - radius;

% Left sphere.
% left = sqrt((g.xs{1} + offset).^2 + g.xs{2}.^2 + g.xs{3}.^2) - radius;

% Center cylinder, runs horizontally to the middle of the spheres.
% center = max(abs(g.xs{1}) - offset, sqrt(g.xs{2}.^2 + g.xs{3}.^2) - width);

% Union the three portions together.
 data = datain * 3.4/size(datain,1); %min(center, min(left, right));
 data0 = -data;

%---------------------------------------------------------------------------
% Set up time approximation scheme.
integratorOptions = odeCFLset('factorCFL', 0.5, 'stats', 'on');

% Choose approximations at appropriate level of accuracy.
%   Same accuracy is used by both components of motion.
switch(accuracy)
 case 'low'
  derivFunc = @upwindFirstFirst;
  integratorFunc = @odeCFL1;
 case 'medium'
  derivFunc = @upwindFirstENO2;
  integratorFunc = @odeCFL2;
 case 'high'
  derivFunc = @upwindFirstENO3;
  integratorFunc = @odeCFL3;
 case 'veryHigh'
  derivFunc = @upwindFirstWENO5;
  integratorFunc = @odeCFL3;
 otherwise
  error('Unknown accuracy level %s', accuracy);
end

if(singleStep)
  integratorOptions = odeCFLset(integratorOptions, 'singleStep', 'on');
end

%---------------------------------------------------------------------------
% Set up curvature motion.
schemeFunc = @termCurvature;
schemeData.grid = g;
schemeData.curvatureFunc = @curvatureSecond;
schemeData.b = b;

%---------------------------------------------------------------------------
% Initialize Display:
%   One figure showing a contour slice through the dumbbell,
%   the other showing a sequence of surface plots.
%fContour = figure;

% Set up subplot parameters for surface plot.
%fSurface = figure;
rows = ceil(sqrt(plotSteps));
cols = ceil(plotSteps / rows);
plotNum = 1;
subplot(rows, cols, plotNum);

%h = showDumbbell(g, data, fContour, fSurface, level, [ 't = ' num2str(t0) ]);

%hold on;

%---------------------------------------------------------------------------
% Loop until tMax (subject to a little roundoff).
tNow = t0;
startTime = cputime;
while(tMax - tNow > small * tMax)

  % Reshape data array into column vector for ode solver call.
  y0 = -data(:); % y0 = data(:); % inside is positive and outside nege

  % How far to step?
  tSpan = [ tNow, min(tMax, tNow + tPlot) ];
  
  % Take a timestep.
  [ t y ] = feval(integratorFunc, schemeFunc, tSpan, y0,...
                  integratorOptions, schemeData);
  tNow = t(end);

  % Get back the correctly shaped data array
  data = -reshape(y, g.shape); %data = reshape(y, g.shape); 
  %data = -data;

  if(pauseAfterPlot)
    % Wait for last plot to be digested.
    pause;
  end

  % Move to next subplot in the surface plot.
%  figure(fSurface);
  plotNum = plotNum + 1;
 % subplot(rows, cols, plotNum);

  % Create new visualization.
%  h = showDumbbell(g, data, fContour, fSurface, level, ['t = ' num2str(tNow)]);

end

endTime = cputime;
fprintf('Total execution time %g seconds\n', endTime - startTime);


  
