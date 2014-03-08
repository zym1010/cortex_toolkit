function [anglesFL, anglesFR, anglesGL, anglesGR] = rotation_angles()
% ROTATION_ANGLES Return rotation angles given F, L, R.
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 15-Feb-2014 04:09:53 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : rotation_angles.m 

conditions = stereogram_toolbox.get_conditions();

% could use a for loop for better maintenance...

anglesFL = rotation_angles_inner(conditions.F, conditions.L);
anglesFR = rotation_angles_inner(conditions.F, conditions.R);
anglesGL = rotation_angles_inner(conditions.G, conditions.L);
anglesGR = rotation_angles_inner(conditions.G, conditions.R);

% tempL = (conditions.F - conditions.L);
% anglesFL(1) = atan(tempL(1)/tempL(3));
% %anglesL(2) = atan( tempL(2)/sqrt( tempL(1).^2 + tempL(3).^2 ));
% anglesFL(2) = atan( tempL(2)/  ( -sin(anglesFL(1))*tempL(1) - cos( anglesFL(1) ) * tempL(3)   )   );
% 

end

function anglesLR = rotation_angles_inner(F, R)

anglesLR = zeros(2,1);

tempLR = F-R;
anglesLR(1) = atan(tempLR(1)/tempLR(3));
% eq. used in the paper, which is correct.
anglesLR(2) = atan( tempLR(2)/  ( -sin(anglesLR(1))*tempLR(1) - cos( anglesLR(1) ) * tempLR(3)   )   );
end







% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [rotation_angles.m] ======  
