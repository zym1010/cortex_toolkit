function [depthGrid] = new_depth_map(width, height)
% NEW_DEPTH_MAP Return a depth map of zScreen everywhere. 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 16-Feb-2014 14:27:46 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : new_depth_map.m 

import stereogram_toolbox.*

depthGrid = ones(height,width)*get_conditions().zScreen;

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [new_depth_map.m] ======  
