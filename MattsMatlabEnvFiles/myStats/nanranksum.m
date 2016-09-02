function [p,h,stat]=nanranksum(x,y,varargin)
%[p,h,stat]=nanranksum(x,varargin)
%
% This is exactly like matlab's signrank, but adjusts the input to remove
% nans first.

%note- yes this is fine to just throw out all the NaN x's and NaN y's independently of each other... remember this is a b/t groups test, so the samples don't match at all- and there's no reason to say, throw out a given y value because of a nan in an x value for example    
x(isnan(x))=[];
y(isnan(y))=[];

switch nargin
    case 2;     [p,h,stat]=ranksum(x,y);
    case 3;     [p,h,stat]=ranksum(x,y,varargin{1});
    case 4;     [p,h,stat]=ranksum(x,y,varargin{1},varargin{2});
    case 5;     [p,h,stat]=ranksum(x,y,varargin{1},varargin{2},varargin{3});
    case 6;     [p,h,stat]=ranksum(x,y,varargin{1},varargin{2},varargin{3},varargin{3});   
end

