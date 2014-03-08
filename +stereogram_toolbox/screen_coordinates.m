function [SLMatrix, SRMatrix, kLMatrix, kRMatrix, PLMatrix, PRMatrix, PLiMatrix, PRiMatrix] = ...
    screen_coordinates(PMatrix)
% SCREEN_COORDINATES Get screen coorindates in world reference frame
%
%   PMatrix is a [3 x N] matrix of all points that to be displayed,
%   SRMatrix and are matrices of [3 x N] contating screen coordiates for
%   left and right screens.
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 15-Feb-2014 10:32:11 $
%% DEVELOPED : 8.1.0.604 (R2013a)
%% FILENAME  : screen_coordinates.m

import stereogram_toolbox.*

assert(size(PMatrix,1) == 3);

conditions = stereogram_toolbox.get_conditions();

[anglesFL, anglesFR, anglesGL, anglesGR] = rotation_angles();

[RyFL] = rotation_matrix(-anglesFL(1), 2);
[RxFL] = rotation_matrix(-anglesFL(2), 1);
[RyFR] = rotation_matrix(-anglesFR(1), 2);
[RxFR] = rotation_matrix(-anglesFR(2), 1);

[RyGLi] = rotation_matrix(anglesGL(1), 2);
[RxGLi] = rotation_matrix(anglesGL(2), 1);
[RyGRi] = rotation_matrix(anglesGR(1), 2);
[RxGRi] = rotation_matrix(anglesGR(2), 1);

% fprintf('new def!\n');

% coordinates in eye reference frames
PLiMatrix = RxFL*RyFL*bsxfun(@minus, PMatrix, conditions.L);
PRiMatrix = RxFR*RyFR*bsxfun(@minus, PMatrix, conditions.R);

% PLMatrix = RyGLi*RxGLi*RxFL*RyFL*bsxfun(@minus, PMatrix, conditions.L);
% PRMatrix = RyGRi*RxGRi*RxFR*RyFR*bsxfun(@minus, PMatrix, conditions.R);

PLMatrix = RyGLi*RxGLi*PLiMatrix;
PRMatrix = RyGRi*RxGRi*PRiMatrix;

kLMatrix = conditions.zScreen./PLMatrix(3,:);
kRMatrix = conditions.zScreen./PRMatrix(3,:);

SLMatrix = bsxfun(@plus, bsxfun(@times, kLMatrix, PLMatrix), conditions.L);
SRMatrix = bsxfun(@plus, bsxfun(@times, kRMatrix, PRMatrix), conditions.R);





end








% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [screen_coordinates.m] ======
