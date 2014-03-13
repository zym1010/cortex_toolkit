function [ctxNameArray] = save_LR_movie( prefixList, imageSize, DirStruct, numFrames, python_location, ...
    executableDir, simulation)
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

if nargin < 7
    simulation = false;
end

assert(size(imageSize,2)==2); % Nx2 or 1x2
assert(size(imageSize,1)==1 || size(imageSize,1)==length(prefixList));

ctxNameArray = cell(length(prefixList)*2,1);



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
    
    if ~simulation
%         for iFrame = 1:numFrames
%             
%             leftImageFile = fullfile(imgDir,[ prefix  'L' int2str(iFrame) '.png']);
%             rightImageFile = fullfile(imgDir,[ prefix  'R' int2str(iFrame) '.png']);
%             leftMatFile = fullfile(matDir,[ prefix  'L' int2str(iFrame) '.mat']);
%             rightMatFile = fullfile(matDir,[ prefix  'R' int2str(iFrame) '.mat']);
%             
%             command = [python_location ' ' fullfile(executableDir,'generate_one_stereogram.py') ' ' ...
%                 leftMatFile  sizeArg ' --output ' leftImageFile  ];
%             system(command);
%             command = [python_location ' ' fullfile(executableDir,'generate_one_stereogram.py') ' ' ...
%                 rightMatFile sizeArg  ' --output ' rightImageFile ];
%             system(command);
%             
%             leftImages{iFrame} = imread(leftImageFile);
%             leftImages{iFrame} = rgb2gray(leftImages{iFrame});
%             leftImages{iFrame} = double(leftImages{iFrame})/255*127+128;
%             
%             rightImages{iFrame} = imread(rightImageFile);
%             rightImages{iFrame} = rgb2gray(rightImages{iFrame});
%             rightImages{iFrame} = double(rightImages{iFrame})/255*127+128; % since 128-255 are usable color values in CORTEX...
%         end

        leftImageFileArray = cell(numFrames,1);
        rightImageFileArray = cell(numFrames,1);
%         leftMatFileArray = cell(numFrames,1);
%         rightMatFileArray = cell(numFrames,1);
%         
        for iFrame = 1:numFrames
            leftImageFile = fullfile(imgDir,[ prefix  'L' int2str(iFrame) '.png']);
            rightImageFile = fullfile(imgDir,[ prefix  'R' int2str(iFrame) '.png']);
%             leftMatFile = fullfile(matDir,[ prefix  'L' int2str(iFrame) '.mat']);
%             rightMatFile = fullfile(matDir,[ prefix  'R' int2str(iFrame) '.mat']);
            
            leftImageFileArray{iFrame} = leftImageFile;
            rightImageFileArray{iFrame} = rightImageFile;
%             leftMatFileArray{iFrame} = leftMatFile;
%             rightMatFileArray{iFrame} = rightMatFile;
        end


        
        % I want to generate png files in one row...
        % this command has specific requirements on filenames.

        command = [python_location ' ' fullfile(executableDir,'generate_stereogram_batch.py') ' ' ...
                  prefix  sizeArg ' --numframes ' int2str(numFrames)  ' --execdir '  '''' executableDir  '''' ...
                  ' --imgdir ' '''' imgDir ''''   ' --matdir ' '''' matDir '''' ...
                  ' --resizeheight '];
        
        system(command);
        
              
        for iFrame = 1:numFrames
            leftImages{iFrame} = imread(leftImageFileArray{iFrame});
            leftImages{iFrame} = rgb2gray(leftImages{iFrame});
            
            leftImages{iFrame} = double(leftImages{iFrame})/255*127+128;
            
            rightImages{iFrame} = imread(rightImageFileArray{iFrame});
            rightImages{iFrame} = rgb2gray(rightImages{iFrame});
            rightImages{iFrame} = double(rightImages{iFrame})/255*127+128; % since 128-255 are usable color values in CORTEX...
        end

    end
    
    
    
    fileNameNoDirL = [ prefix 'L.ctx'];
    fileNameNoDirR = [ prefix 'R.ctx'];
    
    ctxNameArray{2*iMovie-1} = fileNameNoDirL;
    ctxNameArray{2*iMovie} = fileNameNoDirR;
    
    fileNameL = fullfile(ctxDir,fileNameNoDirL);
    fileNameR = fullfile(ctxDir,fileNameNoDirR);
    
    sizeImage = size(leftImages{1});
    
    
    if ~simulation
        for iFrame = 1:numFrames
            if iFrame == 1
                savecx_movie_firstframe(fileNameL, '', [8 sizeImage(2) sizeImage(1) numFrames],...
                    leftImages{iFrame});
                savecx_movie_firstframe(fileNameR, '', [8 sizeImage(2) sizeImage(1) numFrames],...
                    rightImages{iFrame});
            else
                savecx_movie_succframe(fileNameL, '', [8 sizeImage(2) sizeImage(1) numFrames],...
                    leftImages{iFrame});
                savecx_movie_succframe(fileNameR, '', [8 sizeImage(2) sizeImage(1) numFrames],...
                    rightImages{iFrame});
            end
        end
    end
    
end

end

