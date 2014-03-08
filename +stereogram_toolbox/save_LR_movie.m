function [  ] = save_LR_movie( prefixList, imageSize, DirStruct, numFrames, python_location, ...
    executableDir)
%SAVE_LR_MOVIE Save ctx movies using mat files.
%   Detailed explanation goes here

import ctx_matlab_toolbox.*

if nargin < 3
    DirStruct = struct();
end

if ~isfield(DirStruct,'matDir')
    matDir = '.';
else
    matDir = DirStruct.matDir;
end

if ~isfield(DirStruct,'imgDir')
    imgDir = '.';
else
    imgDir = DirStruct.imgDir;
end

if ~isfield(DirStruct,'ctxDir')
    ctxDir = '.';
else
    ctxDir = DirStruct.ctxDir;
end

if nargin < 4
    numFrames = 12;
end

if nargin < 5
    python_location = '/opt/local/bin/python'; % change this if needed
end

if nargin < 6
    executableDir = '.';
end

assert(size(imageSize,2)==2); % Nx2 or 1x2
assert(size(imageSize,1)==1 || size(imageSize,1)==length(prefixList));

for iMovie = 1:length(prefixList)
    prefix = prefixList{iMovie};
    leftImages = cell(numFrames,1);
    rightImages = cell(numFrames,1);
    
    if size(imageSize,1)==1 % single size
        halfWidth = imageSize(1);
        halfHeight = imageSize(2);
    else
        halfWidth = imageSize(iMovie,1);
        halfHeight = imageSize(iMovie,2);
    end
    
    sizeArg = [' --halfwidth '  num2str(halfWidth) ' --halfheight '   num2str(halfHeight) ' --margin 0' ];
    
    for iFrame = 1:numFrames
        
        leftImageFile = fullfile(imgDir,[ prefix  'L' int2str(iFrame) '.png']);
        rightImageFile = fullfile(imgDir,[ prefix  'R' int2str(iFrame) '.png']);
        leftMatFile = fullfile(matDir,[ prefix  'L' int2str(iFrame) '.mat']);
        rightMatFile = fullfile(matDir,[ prefix  'R' int2str(iFrame) '.mat']);
        
        command = [python_location ' ' fullfile(executableDir,'generate_one_stereogram.py') ' ' ...
            leftMatFile  sizeArg ' --output ' leftImageFile  ];
        system(command);
        command = [python_location ' ' fullfile(executableDir,'generate_one_stereogram.py') ' ' ...
            rightMatFile sizeArg  ' --output ' rightImageFile ];
        system(command);
        
        leftImages{iFrame} = imread(leftImageFile);
        leftImages{iFrame} = rgb2gray(leftImages{iFrame});
        leftImages{iFrame} = double(leftImages{iFrame})/255*127+128;
        
        
        
        rightImages{iFrame} = imread(rightImageFile);
        rightImages{iFrame} = rgb2gray(rightImages{iFrame});
        rightImages{iFrame} = double(rightImages{iFrame})/255*127+128; % since 128-255 are usable color values in CORTEX...
    end
    
    fileNameL = fullfile(ctxDir,[ prefix 'L.ctx']);
    fileNameR = fullfile(ctxDir,[ prefix 'R.ctx']);

    sizeImage = size(leftImages{1});
    for iFrame = 1:12
        if iFrame == 1
            savecx_movie_firstframe(fileNameL, '', [8 sizeImage(2) sizeImage(1) 12],...
                leftImages{iFrame});
            savecx_movie_firstframe(fileNameR, '', [8 sizeImage(2) sizeImage(1) 12],...
                rightImages{iFrame});
        else
            savecx_movie_succframe(fileNameL, '', [8 sizeImage(2) sizeImage(1) 12],...
                leftImages{iFrame});
            savecx_movie_succframe(fileNameR, '', [8 sizeImage(2) sizeImage(1) 12],...
                rightImages{iFrame});
        end
    end
    
end

end

