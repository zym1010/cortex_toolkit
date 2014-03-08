function [thisPositions, thisColors, thisCornerPositions] = ...
    slant_surface_calculation_loop(positions,colors,surfaceBoundingBox, referencePoints)
% SLANT_SURFACE_CALCULATION_LOOP ...
%
%   ...
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 19-Feb-2014 16:26:41 $
%% DEVELOPED : 8.1.0.604 (R2013a)
%% FILENAME  : slant_surface_calculation_loop.m

import stereogram_toolbox.get_bounding_box_info

assert(size(positions,1) == size(colors,1));
assert(size(colors,2) == 1);
assert(size(positions,2) == 2);


[xmin, xmax, ymin, ymax, x1, z1, x2, z2, cornerPositions] = ...
    get_bounding_box_info(surfaceBoundingBox, referencePoints);

    function [thisPositions, thisColors] = slant_surface_calculation_loop_inner(positions, colors)
        numPoints = size(positions,1);
        thisPositions = zeros(0,3);
        thisColors = zeros(0,1);
        
        counter = 0;
        
        for jPoint = 1:numPoints
            thisPoint = positions(jPoint,:);
            xThis = thisPoint(1);
            yThis = thisPoint(2);
            if xThis <= xmax && xThis >= xmin && yThis <= ymax && yThis >= ymin
                counter = counter + 1;
                
                thisPositions(counter,1:2) = positions(jPoint,:);
                thisPositions(counter,3) = z1 + (xThis-x1)/(x2-x1)*(z2-z1);
                
                thisColors(counter,1) = colors(jPoint);
            end
        end
        
    end

[thisPositions, thisColors] = slant_surface_calculation_loop_inner(positions, colors);
[thisCornerPositions, ~] = slant_surface_calculation_loop_inner(cornerPositions, colors);


end











% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [slant_surface_calculation_loop.m] ======
