function [z_candidate1,z_candidate2] = solve_depth(xp, desiredDisparityDegrees)
% SOLVE_DEPTH Calculate the depth of a point, given x, and disparity.
%  
%   y is assumed to be zero. 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 16-Feb-2014 12:16:26 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : solve_depth.m 

import stereogram_toolbox.*

conditions = get_conditions();

IO = conditions.IO;
%zScreen = conditions.zScreen;
F = conditions.F;

% fprintf('old definition');
% alpha = 2*atan(-IO/2/zScreen);

% fprintf('fixed definition');
alpha = 2*atan(-IO/2/F(3));

phi = @(z) atan((-xp - IO/2)  ./ z  ) -  atan((-xp + IO/2)  ./ z  );

opts = optimset('Display','notify');

desiredDisparityRadians = degtorad(desiredDisparityDegrees);

funcForDisparity1 = @(z) alpha-phi(z) - desiredDisparityRadians;
z_candidate1 = fzero(funcForDisparity1,[-1000,-0.1],opts);

assert(abs(funcForDisparity1(z_candidate1)) < 1e-6);

funcForDisparity2 = @(z) alpha-phi(z) + desiredDisparityRadians;
z_candidate2 = fzero(funcForDisparity2,[-1000,-0.1],opts);

assert(abs(funcForDisparity2(z_candidate2)) < 1e-6);

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [solve_depth.m] ======  
