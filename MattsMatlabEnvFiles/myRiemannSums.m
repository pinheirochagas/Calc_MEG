function int=myRiemannSums(x,y)
% function int=myRiemannSums(x,y)
%
%   Integreates using a Riemann sum approximations, using the average
%   between endpoints as the y value for each Riemann rectangle.
%
%   If x and y are arrays, it operates down the ROWS of x and y, assuming
%   each COLUMN is a trial
%
%   begun 070715 by MJN

[r,c]=size(x);

if r==1 || c==1;    int=sum(diff(x).*( diff(y)/2+y(1:end-1) ));
else
    warning('In myRiemannSums for non-vector entry... I don''t think this works yet')
    %int=sum(diff(x).*( diff(y)/2+y(1:end-1,:) ));
    int=sum(diff(x).*diff(y)/2+y(1:end-1,:));
end