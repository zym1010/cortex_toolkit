function [surfaceArray] = ...
    generate_vertical_surface_direct(verticalBoxParametersArray,dotDensity)
% GENERATE_VERTICAL_SURFACE_DIRECT ...
%
%   ...
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 17-Feb-2014 13:58:33 $
%% DEVELOPED : 8.1.0.604 (R2013a)
%% FILENAME  : generate_vertial_patch.m


assert(size(verticalBoxParametersArray,2) == 4);
N = size(verticalBoxParametersArray,1); % number of surfaces to be generated
surfaceArray = cell(N,1);

cons = stereogram_toolbox.get_conditions();
interDotDistance = cons.interDotDistance;

for iSurface = 1:N
    verticalBoxParameters = verticalBoxParametersArray(iSurface,:);
    x = verticalBoxParameters(1);
    z1 = verticalBoxParameters(2);
    z2 = verticalBoxParameters(3);
    halfHeight = verticalBoxParameters(4);
    
    if abs(z1-z2) <= 1e-6
        surfaceArray{iSurface}.positions = zeros(0,3);
        surfaceArray{iSurface}.colors = zeros(0,1);
        surfaceArray{iSurface}.cornerPositions = zeros(0,3);
        continue;
    end
    
    assert(z1~=z2);
    if z2 < z1
        temp = z1;
        z1 = z2;
        z2 = temp;
    end

    assert(z1 < z2);
    assert(halfHeight > 0);
    
    pointsY = 0:interDotDistance:halfHeight;
    pointsY = [ -pointsY(end:-1:2) pointsY ]';
    
    pointsX = 0:interDotDistance:2*abs(x);
    pointsX = [ -pointsX(end:-1:2) pointsX ]';
    
    pointsZ = 0:interDotDistance:2*max(abs(z1),abs(z2));
    pointsZ = [ -pointsZ(end:-1:2) pointsZ ]';
    
    [~, idx] = min(abs(pointsX - x));
%     pointX = pointsX(idx); % I think this is useless...
    pointX = x;

    %display(pointX);
    
    pointsZ(pointsZ > z2) = [];
    pointsZ(pointsZ < z1) = [];
    
    [xgrid, ygrid, zgrid] = meshgrid(pointX, pointsY, pointsZ);
    
    positions3D = [xgrid(:),ygrid(:),zgrid(:)];
    rng('shuffle');
    preservedIndex = randperm(numel(xgrid), ceil(numel(xgrid)*dotDensity));
    positions3D = positions3D(preservedIndex,:);
    colors = double(rand(size(positions3D,1),1) > 0.5);
    
    thisCornerPositions = [x, -halfHeight, z2; % z2 is nearer
                           x, -halfHeight, z1;
                           x, halfHeight, z1;
                           x, halfHeight, z2];
    
    surfaceArray{iSurface}.positions = positions3D;
    surfaceArray{iSurface}.colors = colors;
    surfaceArray{iSurface}.cornerPositions = thisCornerPositions;
                       
end








% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [generate_vertial_patch.m] ======
