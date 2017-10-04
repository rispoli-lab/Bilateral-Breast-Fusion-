function [ curvature, gradMag ] = curvatureSecond(grid, data)
% curvatureSecond: second order centered difference approx of the curvature.
%
%   [ curvature, gradMag ] = curvatureSecond(grid, data)
%
% Computes a second order centered difference approximation to the curvature.
%
%       \kappa = divergence(\grad \phi / | \grad \phi |)
%
% See O&F section 1.4 for more details.  In particular, this routine
%   implements equation 1.8 for calculating \kappa.
%
% parameters:
%   grid	Grid structure (see processGrid.m for details).
%   data        Data array.
%
%   curvature   Curvature approximation (same size as data).
%   gradMag	Magnitude of gradient |\grad \phi|
%                 Incidentally calculated while finding curvature,
%                 also second order centered difference.

% Copyright 2004 Ian M. Mitchell (mitchell@cs.ubc.ca).
% This software is used, copied and distributed under the licensing 
%   agreement contained in the file LICENSE in the top directory of 
%   the distribution.
%
% Ian Mitchell, 6/3/03

%---------------------------------------------------------------------------
% Get the first and second derivative terms.
[ second, first ] = hessianSecond(grid, data);

%---------------------------------------------------------------------------
% Compute gradient magnitude.
gradMag2 = first{1}.^2;
for i = 2 : grid.dim
  gradMag2 = gradMag2 + first{i}.^2;
end
gradMag = sqrt(gradMag2);

%---------------------------------------------------------------------------
curvature = zeros(size(data));
a1 = second{2,2}.*second{3,3}-second{3,2}.*second{3,2};
b1 = second{3,1}.*second{3,2}-second{2,1}.*second{3,3};
c1 = second{2,1}.*second{3,2}-second{3,1}.*second{2,2};
a2 = second{3,2}.*second{3,1}-second{2,1}.*second{3,3};
b2 = second{1,1}.*second{3,3}-second{3,1}.*second{3,1};
c2 = second{2,1}.*second{3,1}-second{1,1}.*second{3,2};
a3 = second{2,1}.*second{3,2}-second{2,2}.*second{3,1};
b3 = second{2,1}.*second{3,1}-second{1,1}.*second{3,2};
c3 = second{1,1}.*second{2,2}-second{2,1}.*second{2,1};
curvature = (a1.*first{1} + b1.*first{2} + c1.*first{3}).*first{1}+ ...
            (a2.*first{1} + b2.*first{2} + c2.*first{3}).*first{2}+ ...
            (a3.*first{1} + b3.*first{2} + c3.*first{3}).*first{3} ;
%----------------------------------------------------------------------

for i = 1 : grid.dim;
  curvature = curvature + second{i,i} .* (gradMag2 - first{i}.^2);
%  for j = 1 : i - 1
%    curvature = curvature - 2 * first{i} .* first{j} .* second{i,j};
%  end
%end


% Be careful not to stir the wrath of "Divide by Zero".
%  Note that gradMag == 0 implies curvature == 0 already, since all the
%  terms in the curvature approximation involve at least one first dervative.
nonzero = find(gradMag > 0);
%curvature(nonzero) = curvature(nonzero) ./ gradMag(nonzero).^3;
curvature(nonzero) = -curvature(nonzero) ./ gradMag(nonzero).^4;
% - sign so now the saddle will have neg curvature, convex have positive curvature


