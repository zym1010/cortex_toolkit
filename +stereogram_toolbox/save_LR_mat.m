function save_LR_mat(surfaceArray, prefixList, suffixList, mat_dir)
% SAVE_LR_MAT ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 20-Feb-2014 08:18:58 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : save_LR_mat.m 

assert(length(prefixList) == length(surfaceArray));

if nargin < 4
    mat_dir = '.';
end

if nargin < 3
    suffixList = repmat({''},length(surfaceArray),1);
end

for iCondition = 1:length(surfaceArray)
    thisSurfaceArray = surfaceArray{iCondition};
    numberOfSurfaces = length(thisSurfaceArray);
    fprintf('%d:%d surfaces.\n',iCondition,numberOfSurfaces);
    surfacesL = cell(numberOfSurfaces,1);
    surfacesR = cell(numberOfSurfaces,1);
    for iSurface = 1:numberOfSurfaces
        [SLMatrix, SRMatrix] = stereogram_toolbox.screen_coordinates(thisSurfaceArray{iSurface}.positions');
        surfacesL{iSurface}.positions = SLMatrix(1:2,:)';
        surfacesL{iSurface}.colors = thisSurfaceArray{iSurface}.colors;
        surfacesR{iSurface}.positions = SRMatrix(1:2,:)';
        surfacesR{iSurface}.colors = thisSurfaceArray{iSurface}.colors;
        [SLMatrixCorner, SRMatrixCorner] = stereogram_toolbox.screen_coordinates(thisSurfaceArray{iSurface}.cornerPositions');
        surfacesL{iSurface}.cornerPositions = SLMatrixCorner(1:2,:)';
        surfacesR{iSurface}.cornerPositions = SRMatrixCorner(1:2,:)';
    end
    
    
    if numberOfSurfaces == 3 % the second one needs to be fixed
        [retainIdx] = stereogram_toolbox.cluster_suppression(surfacesL{2}.positions,surfacesR{2}.positions);
        fprintf('%d:%d/%d suppressed.\n',iCondition,sum(~retainIdx),length(~retainIdx));
        surfacesL{2}.positions(~retainIdx,:) = [];
        surfacesL{2}.colors(~retainIdx,:) = [];
        surfacesR{2}.positions(~retainIdx,:) = [];
        surfacesR{2}.colors(~retainIdx,:) = [];
    end
    
    surfaces = surfacesL;
    save(fullfile(mat_dir, [prefixList{iCondition} 'L' suffixList{iCondition} '.mat']),'surfaces');
    surfaces = surfacesR;
    save(fullfile(mat_dir, [prefixList{iCondition} 'R' suffixList{iCondition} '.mat']),'surfaces');
end


end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [save_LR_mat.m] ======  
