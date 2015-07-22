function savecx_movie_permute(filename_old, filename_new, P)
% SAVECX_MOVIE_PERMUTE 
%
% usage 
% savecx_movie_permute('old.ctx','new.ctx',10:-1:1);
% % reverse a 10 frame movie.
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 22-Jul-2015 16:30:39 $
%% DEVELOPED : 8.3.0.532 (R2014a)
%% FILENAME  : savecx_movie_permute.m

import ctx_matlab_toolbox.loadcx
import ctx_matlab_toolbox.savecx

%% load old movie
[imgmtx, dmns, notes]=loadcx(filename_old);

%% read dimension info
frame_number = dmns(4);
frame_height = dmns(3);
frame_width = dmns(2);
assert(dmns(1)==8); % only work on 8 bit depth images.
% check size.
if frame_number == 0 % hack back frame number for single frame movie.
    frame_number = frame_number + 1;
end
assert(isequal( size(imgmtx),[frame_height*frame_number,frame_width] ));

% check valid permutation.
P=P(:);
assert(numel(P)==frame_number);
assert(isequal(unique(P),(1:frame_number)'));

imgmtx_new = zeros(size(imgmtx));

for iFrame = 1:frame_number
    iFrameOld = P(iFrame);
    imgmtx_new((iFrame-1)*frame_height+1:iFrame*frame_height,:) = ...
        imgmtx((iFrameOld-1)*frame_height+1:iFrameOld*frame_height,:);
end

ctx_matlab_toolbox.savecx(filename_new,notes,dmns,imgmtx_new);

end








% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [savecx_movie_permute.m] ======
