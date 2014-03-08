function surfaceArray = generate_slant_surface(positions, colors, ...
    surfaceBoundingBoxes, referencePointsArray)
% GENERATE_SLANT_SURFACE ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

import stereogram_toolbox.*

assert(isequal(size(surfaceBoundingBoxes),size(referencePointsArray)));
assert(size(surfaceBoundingBoxes,2) == 4);
N = size(surfaceBoundingBoxes,1); % number of surfaces to be generated
surfaceArray = cell(N,1);

assert(size(positions,1) == size(colors,1));
assert(size(colors,2) == 1);
assert(size(positions,2) == 2);

% surfaceBoundingBoxes is Nx4, each row [xmin, xmax, ymin, ymax]
% referencePointsArray is Nx4, each row [ x1,z1,x2,z2 ]

for iSurface = 1:N
    surfaceBoundingBox = surfaceBoundingBoxes(iSurface,:);
    referencePoints = referencePointsArray(iSurface,:);
    
    [thisPositions, thisColors, thisCornerPositions] = ...
    slant_surface_calculation_loop(positions,colors,surfaceBoundingBox, referencePoints);
    
    surfaceArray{iSurface}.positions = thisPositions;
    surfaceArray{iSurface}.colors = thisColors;
    surfaceArray{iSurface}.cornerPositions = thisCornerPositions;
end



end


% xThis = xgrid(iPoint);
%     
%     if xThis <= xmax && xThis >= xmin
%         zgrid(iPoint) = z1 + (xThis-x1)/(x2-x1)*(z2-z1);
%     end





% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [generate_slant_surface.m] ======  
