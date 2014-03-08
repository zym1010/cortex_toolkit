function [positions2D, colors, xgrid, ygrid, preservedIndex] = ...
    generate_pattern(halfWidth, halfHeight, dotDensity)
% GENERATE_PATTERN ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 16-Feb-2014 10:56:12 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : generate_pattern.m 


cons = stereogram_toolbox.get_conditions(); 
interDotDistance = cons.interDotDistance;

pointsX = 0:interDotDistance:halfWidth;
pointsX = [ -pointsX(end:-1:2) pointsX ]';

pointsY = 0:interDotDistance:halfHeight;
pointsY = [ -pointsY(end:-1:2) pointsY ]';

[xgrid, ygrid] = meshgrid(pointsX, pointsY);

% Xgrid = Xgrid(:);
% Ygrid = Ygrid(:);

positions2D = [xgrid(:),ygrid(:)];
rng('shuffle');

preservedIndex = randperm(numel(xgrid), ceil(numel(xgrid)*dotDensity));

positions2D = positions2D(preservedIndex,:);
% colors = ones(size(positions2D,1),1);
colors = double(rand(size(positions2D,1),1) > 0.5);

end





% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [generate_pattern.m] ======  
