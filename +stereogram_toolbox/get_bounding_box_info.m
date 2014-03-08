function [xmin, xmax, ymin, ymax, x1, z1, x2, z2, cornerPositions] = ...
    get_bounding_box_info(surfaceBoundingBox, referencePoints)
% GET_BOUNDING_BOX_INFO ...
%
%   ...
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 19-Feb-2014 16:21:04 $
%% DEVELOPED : 8.1.0.604 (R2013a)
%% FILENAME  : get_bounding_box_info.m


xmin = surfaceBoundingBox(1);
xmax = surfaceBoundingBox(2);
ymin = surfaceBoundingBox(3);
ymax = surfaceBoundingBox(4);

assert(xmin < xmax);
assert(ymin < ymax);

x1 = referencePoints(1);
z1 = referencePoints(2);
x2 = referencePoints(3);
z2 = referencePoints(4);

assert(x1~=x2);

cornerPositions = [xmin, ymin;
    xmax, ymin;
    xmax, ymax;
    xmin, ymax];

end

% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [get_bounding_box_info.m] ======
