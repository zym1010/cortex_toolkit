function plot_point_scatter(positionsArray)
% PLOT_POINT_SCATTER ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 19-Feb-2014 15:32:36 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : plot_point_scatter.m 

figure;
hold on;
colorArray = {'y','m','c','r','g','b','w','k'};

for iSurface = 1:length(positionsArray)
    colorSpecifier = rem(iSurface,8) + 1;
    positions = positionsArray{iSurface}.positions;
    
    cornerPositions = positionsArray{iSurface}.cornerPositions;
    if ~isempty(cornerPositions)
        cornerPositions(5,:) = cornerPositions(1,:);
    end
    
    if size(positions,2) == 3
        scatter3(positions(:,1),positions(:,2),positions(:,3),colorArray{colorSpecifier} );
        plot3(cornerPositions(:,1),cornerPositions(:,2),cornerPositions(:,3),'Color',colorArray{colorSpecifier} );
    else
        scatter(positions(:,1),positions(:,2),colorArray{colorSpecifier} );
        plot(cornerPositions(:,1),cornerPositions(:,2),'Color',colorArray{colorSpecifier} );
    end
end

hold off;

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [plot_point_scatter.m] ======  
