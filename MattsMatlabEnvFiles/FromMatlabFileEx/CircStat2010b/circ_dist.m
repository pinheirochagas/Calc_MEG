function r =  circ_dist_d(x,y)
%
% r = circ_dist(alpha, beta)
%%%% Created by MJN from circ_mean .... this is exactly the same as
%%%% circ_mean, with the exception that this assumes that the angles are in
%%%% degrees (and the first thing the code does is convert them to radians,
%%%% and the last thuing the code does is convert the answer back to
%%%% degrees).
%   Pairwise difference x_i-y_i around the circle computed efficiently.
%
%   Input:
%     alpha      sample of linear random variable
%     beta       sample of linear random variable or one single angle
%
%   Output:
%     r       matrix with differences
%
% References:
%     Biostatistical Analysis, J. H. Zar, p. 651
%
% PHB 3/19/2009
%
% Circular Statistics Toolbox for Matlab

% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html

x=x*pi/180;
y=y*pi/180;

if size(x,1)~=size(y,1) && size(x,2)~=size(y,2) && length(y)~=1
  error('Input dimensions do not match.')
end

r = angle(exp(1i*x)./exp(1i*y));

r=r*180/pi;