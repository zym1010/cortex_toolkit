function [PLiAzi, PLiElevation, PRiAzi, PRiElevation] = retina_coordinates(PMatrix)
% RETINA_COORDINATES Compute retina coordinates given 3D points 
%  
%   results are in azimuth/elevation.
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 15-Feb-2014 22:18:56 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : retina_coordinates.m 

import stereogram_toolbox.*

[~,~,~,~,~,~,PLiMatrix, PRiMatrix] = screen_coordinates(PMatrix);

% put the point to the back of the eye
PLiMatrix = -PLiMatrix; 
PRiMatrix = -PRiMatrix; 

PLiAzi = atan2( PLiMatrix(1,:), PLiMatrix(3,:));
PLiElevation = atan2( PLiMatrix(2,:), sqrt(PLiMatrix(1,:).^2 + PLiMatrix(3,:).^2) );

PRiAzi = atan2( PRiMatrix(1,:), PRiMatrix(3,:));
PRiElevation = atan2( PRiMatrix(2,:), sqrt(PRiMatrix(1,:).^2 + PRiMatrix(3,:).^2) );


end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [retina_coordinates.m] ======  
