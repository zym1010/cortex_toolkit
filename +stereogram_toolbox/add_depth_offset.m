function surfaceArray = add_depth_offset(surfaceArray, offset)
% ADD_DEPTH_OFFSET ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 20-Feb-2014 10:17:09 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : add_depth_offset.m 

assert(size(surfaceArray,2) == 1);

for iSurface = 1:length(surfaceArray)
    surfaceArray{iSurface}.positions(:,3) = ...
        surfaceArray{iSurface}.positions(:,3) + offset;
    surfaceArray{iSurface}.cornerPositions(:,3) = ...
        surfaceArray{iSurface}.cornerPositions(:,3) + offset;
end

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [add_depth_offset.m] ======  
