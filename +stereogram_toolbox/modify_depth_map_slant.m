function zgrid = modify_depth_map_slant(x1, z1, x2, z2, xmin, xmax, xgrid, zgrid)
% MODIFY_DEPTH_MAP_SLANT Modify depth horizontally given reference points 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 16-Feb-2014 14:32:46 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : modify_depth_map_slant.m 

assert(x1~=x2);
assert(isequal(size(xgrid),size(zgrid)));

for iPoint = 1:numel(xgrid)
    xThis = xgrid(iPoint);
    
    if xThis <= xmax && xThis >= xmin
        zgrid(iPoint) = z1 + (xThis-x1)/(x2-x1)*(z2-z1);
    end
end


end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [modify_depth_map_slant.m] ======  
