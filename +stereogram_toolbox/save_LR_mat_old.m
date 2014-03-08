function save_LR_mat( PArray, colors , prefix, saveFlag)
% SAVE_LR_MAT Save patterns and colors for left & right eyes to MAT files.
%
%   ...
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 16-Feb-2014 15:10:29 $
%% DEVELOPED : 8.1.0.604 (R2013a)
%% FILENAME  : save_LR_mat.m

if nargin < 4
    saveFlag = 'both';
end

[SLMatrix, SRMatrix] = stereogram_toolbox.screen_coordinates(PArray);

% only save left
if isequal(saveFlag,'both') || isequal(saveFlag,'left')
    positions = SLMatrix(1:2,:)';
    save([prefix 'L' '.mat'],'positions','colors');
end
% only save right
if isequal(saveFlag,'both') || isequal(saveFlag,'right')
    positions = SRMatrix(1:2,:)';
    save([prefix 'R' '.mat'],'positions','colors');
end

end








% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [save_LR_mat.m] ======
