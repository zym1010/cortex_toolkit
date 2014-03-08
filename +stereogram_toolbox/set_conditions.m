function set_conditions(IO, G, F, zScreen, interDotDistance)
% SET_CONDITIONS Initialize global conditions, like fixation distance, etc.
%  
%   the interface can be made more convenient... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 15-Feb-2014 03:52:00 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : set_conditions.m 

global CONDITIONS


if nargin < 5
    interDotDistance = 32.9/700*2; % in cm
end

if nargin < 4
    zScreen = -57;   % typical distance of monitor
end
    
if nargin < 3 % experienced fixation
    F = [0; 0; zScreen]; % fixation point is on the monitor (with typical dist)
end

if nargin < 2 % real fixation point
    G = F; % real fixation point is the experienced one
end

if nargin < 1
    IO = 3.8; % typical interocular distance
end

CONDITIONS.F = F;
CONDITIONS.G = G;
CONDITIONS.IO = IO;

CONDITIONS.L = [-IO/2;0;0];
CONDITIONS.R = [IO/2;0;0];
CONDITIONS.zScreen = zScreen;
CONDITIONS.interDotDistance = interDotDistance;

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [set_conditions.m] ======  
