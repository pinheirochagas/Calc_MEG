function RunAvg=filtRunAvg(X,winlen)
% function RunAvg=filtRunAvg(X,winlen)
%
% Will perform a running average DOWN THE ROWS of X, outputting the running
% average over the nearest winlen samples at every point, using the FILTER
% functino in matlab. This is pretty fast- I didn't really make this, it
% was suggested in matlab's help; I'm just making it a function for ease of
% use.
%
%   BUT- you do need to adjust the output to get the running average at
%   time t... which I've set this up to do

RunAvg=( filter(ones(1,winlen)/winlen,1,X') )';
RunAvg=RunAvg(:,winlen:end);