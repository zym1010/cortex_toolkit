function retainIdx = cluster_suppression(positionsL, positionsR)
% CLUSTER_SUPPRESSION ...
%
%   ...
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 19-Feb-2014 21:03:53 $
%% DEVELOPED : 8.1.0.604 (R2013a)
%% FILENAME  : cluster_suppression.m

conditions = stereogram_toolbox.get_conditions();

threshold = conditions.interDotDistance;

assert(isequal(size(positionsL),size(positionsR)));
assert(size(positionsL,2) == 2);

flag = true;
N = size(positionsL,1);
retainIdx = true(size(positionsL,1),1);
% counter = 0;
while flag
    [flag, idx1, idx2] = cluster_suppression_inner_overlap(positionsL, positionsR, threshold, retainIdx);
    
    if flag
        retainIdx(idx2) = false;
%         counter = counter +1;
%         disp(counter);
    end
end

assert(idx1 == N-1);
assert(isempty(idx2));



end

function [flag, idx1, idx2] = cluster_suppression_inner_overlap(positionsL, positionsR, threshold, retainIdx)

N = size(positionsL,1);

for idx1 = 1:N-1
    
    if ~retainIdx(idx1)
        continue;
    end
    
    iPointL = positionsL(idx1,:);
    iPointR = positionsR(idx1,:);
    
    
    distanceL = bsxfun(@minus,positionsL,iPointL);
    distanceR = bsxfun(@minus,positionsR,iPointR);
    
    distanceL = sqrt(sum(distanceL.^2,2));
    distanceR = sqrt(sum(distanceR.^2,2));
    
    logicalL = (distanceL < threshold) & retainIdx;
    logicalR = (distanceR < threshold) & retainIdx;
    logicalL(1:idx1) = false;
    logicalR(1:idx1) = false;
    
    if any(logicalL) || any(logicalR)
        idx2 = logicalL | logicalR;
        flag = true;
        return;
    end
    
    
%     for idx2 = idx1+1:N
%         jPointL = positionsL(idx2,:);
%         jPointR = positionsR(idx2,:);
%         
%         if (retainIdx(idx1)) && (retainIdx(idx2))
%             if (norm(iPointL-jPointL,2) < threshold || norm(iPointR-jPointR,2) < threshold)
%                 flag = true;
%                 return;
%             end
%         end
%     end
end
idx2 = [];
flag = false;

end






% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [cluster_suppression.m] ======
