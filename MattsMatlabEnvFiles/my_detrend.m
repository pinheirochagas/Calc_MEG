function out = my_detrend(in,t)
%function out = my_detrend(in,t)
%
% This will detrend ignoroing Nan values (doing so using a linear 
% regression on all the non Nan valued samples). In the second input, you 
% can optionally input the time values associated with each sample if the
% sampling is irregular.

n=length(in);
if nargin<2 || isempty(t);    t=[1:n]';   end

if size(in,2)>size(in,1);   
    in=in';     
    rotflag=1;
else
    rotflag=0;
end
if size(t,2)>size(t,1);   t=t';     end

X=[t repmat(1,n,1)];
%Note that: REGRESS treats NaNs in X or Y as missing values, and removes them.
B=regress(in,X);
out=in-X*B;
if rotflag;     out=out';   end