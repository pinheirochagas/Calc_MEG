function B = make_unit_norm(A,dim)
%
% function B = make_unit_norm(A,dim)
%
% Normalize, dividing each vector by its norm, along the dimension dim.
%
% Aaron Schurger
% Sep 2013
%

N = sqrt(sum(A.^2,dim));
B = bsxfun(@rdivide,A,N);
return