function [SEb] = BK3d(radius)
        
[xgrid, ygrid, zgrid] = meshgrid(-radius:radius);
SEb = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= radius);


end