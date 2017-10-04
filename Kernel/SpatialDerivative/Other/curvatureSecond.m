function [ curvature, gradMag ] = curvatureSecond(grid, data)
    %[ curvature, gradMag ] = curvatureSecond(grid, data)
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

% Copyright 2004 Ian M. Mitchell (mitchell@cs.ubc.ca). modified by Xin Li (li2542@purdue.edu)
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
%this part is modified by Xin Li li2542@purdue.edu
curvatureG = zeros(size(data));
a1 = second{2,2}.*second{3,3}-second{3,2}.*second{3,2};
b1 = second{3,1}.*second{3,2}-second{2,1}.*second{3,3};
c1 = second{2,1}.*second{3,2}-second{3,1}.*second{2,2};
a2 = second{3,2}.*second{3,1}-second{2,1}.*second{3,3};
b2 = second{1,1}.*second{3,3}-second{3,1}.*second{3,1};
c2 = second{2,1}.*second{3,1}-second{1,1}.*second{3,2};
a3 = second{2,1}.*second{3,2}-second{2,2}.*second{3,1};
b3 = second{2,1}.*second{3,1}-second{1,1}.*second{3,2};
c3 = second{1,1}.*second{2,2}-second{2,1}.*second{2,1};
curvatureG = (a1.*first{1} + b1.*first{2} + c1.*first{3}).*first{1}+ ...
            (a2.*first{1} + b2.*first{2} + c2.*first{3}).*first{2}+ ...
            (a3.*first{1} + b3.*first{2} + c3.*first{3}).*first{3} ;
nonzero = find(gradMag > 0);
curvatureG(nonzero) = curvatureG(nonzero) ./ gradMag(nonzero).^4;
%---------------------------------------------------------------------------
curvatureM = zeros(size(data));
for i = 1 : grid.dim;
  curvatureM = curvatureM + second{i,i} .* (gradMag2 - first{i}.^2);
  for j = 1 : i - 1
    curvatureM = curvatureM - 2 * first{i} .* first{j} .* second{i,j};
  end
end
nonzero = find(gradMag > 0);
curvatureM(nonzero) = curvatureM(nonzero) ./ gradMag(nonzero).^3;
%---------------------------
curvature = zeros(size(data));
k1 = curvatureM + (curvatureM.^2 -curvatureG).^0.5;
k1(k1<0) = 0;
k2 = curvatureM - (curvatureM.^2 -curvatureG).^0.5;
k2(k2<0) = 0;
curvature = 0.5*(k1+k2);
% Be careful not to stir the wrath of "Divide by Zero".
%  Note that gradMag == 0 implies curvature == 0 already, since all the
%  terms in the curvature approximation involve at least one first dervative.

% - sign so now the saddle will have neg curvature, convex have positive curvature


