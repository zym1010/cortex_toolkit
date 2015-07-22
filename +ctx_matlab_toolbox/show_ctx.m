function show_ctx(filename)
% SHOW_CTX ... 
%  
%   show each frame of CTX. assuming a 128-255 color table. 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 22-Jul-2015 16:41:49 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : show_ctx.m 

%% load ctx file
import ctx_matlab_toolbox.loadcx
[imgmtx, dmns, ~]=loadcx(filename);

%% read dimension info
frame_number = dmns(4);
frame_height = dmns(3);
frame_width = dmns(2);

if frame_number == 0 % hack back frame number for single frame movie.
    frame_number = frame_number + 1;
end

assert(dmns(1)==8); % only work on 8 bit depth images.
assert(isequal( size(imgmtx),[frame_height*frame_number,frame_width] ));

for iFrame = 1:frame_number
    frameThis = imgmtx((iFrame-1)*frame_height+1:iFrame*frame_height,:);
    clf;
    imagesc(frameThis,[128, 255]); colormap gray; axis image;
    title(sprintf('frame %d', iFrame));
    pause;
end

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [show_ctx.m] ======  
