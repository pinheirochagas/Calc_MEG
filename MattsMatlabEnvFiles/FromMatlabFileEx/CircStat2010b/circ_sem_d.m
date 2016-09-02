function [stde] = circ_sem_d(alpha, dim)
%   function [stde] = circ_sem_d(alpha, dim)
%
%   Circular Standard Error of the mean- this will calculate the standard error of
%   the mean down the first dimension of the input array data. 


if nargin<2 || isempty(dim);        dim=1;      end

alpha=alpha*pi/180;

n = sum(~isnan(alpha),dim);

stde=sqrt( circ_dispersion(alpha,dim) ./ n ) *180/pi;

