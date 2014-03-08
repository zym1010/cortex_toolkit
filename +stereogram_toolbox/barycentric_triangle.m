function [lambda] = barycentric_triangle(P, v)
% BARYCENTRIC_TRIANGLE ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 18-Feb-2014 22:15:08 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : barycentric_triangle.m 

assert(isequal(size(P),[2, 3])); % three vertices

assert(rank(P) == 2); % form a triangle

assert(numel(v)==2);

v = v(:);

lambda = zeros(3,1);

v0 = P(:,1) - P(:,3);
v1 = P(:,2) - P(:,3);
v2 = v - P(:,3);

den = v0(1)*v1(2) - v1(1)*v0(2);
assert( abs(den - det([v0 v1])) < 1e-6);
lambda(1) = (v2(1) * v1(2) - v1(1)*v2(2))/den;
lambda(2) = (v0(1) * v2(1) - v2(1) * v0(2)) / den;
lambda(3) = 1-lambda(1)-lambda(2);
assert( all(abs([v0 v1]*lambda(1:2) - v2) < 1e-6));


end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [barycentric_triangle.m] ======  
