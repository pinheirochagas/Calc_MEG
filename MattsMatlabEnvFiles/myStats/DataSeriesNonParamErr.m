function Err = DataSeriesNonParamErr(Dat,Type,alpha)
%function Err = DataSeriesNonParamErr(Dat,Type,'alpha)
%
% Calculate non-parametric error bars at every point in the input array 
% Dat, based on Type. If Type is 0, the program will calculate the standard
% error of the mean. If Type is 1 it will calculate (conservative) 
% confidence intervals based on the Vysochanskij–Petunin inequality using
% the standard error of the mean, or if Type is 2 it will use the Chebyshev
% inequality to produce even more conservative confidnece intervals. 
%
% Inputs:   Dat-    Input data series (# of samples x n time points in the 
%                   time series). An error estimate is given for each time 
%                   point. NaNs in the input are ignored.
%           Type-   What type of an error estimate to use. Options are 0
%                   (default) for the standard error of the mean, 1 for
%                   Vysochanskij–Petunin confidence intervals, or 2 for
%                   Chebyshev confidence intervals.
%           alpha-  The alpha level used for the confidence intervals. This
%                   value is ignored if plotting the standard error of the
%                   mean.
%
% Outputs:  Err-    A 2 x nTimePoints array of error estimates, where the
%                   first row stores the High error estimate, and the 
%                   second row stored the Low error estimate.
%
% According to: http://en.wikipedia.org/wiki/Vysochanski%C3%AF-Petunin_inequality 
% the Vysochanskij–Petunin inequality is like the Chebyshev inequality, but
% can be slightly less conservative because of an assumption that the 
% underlying distribution is unimodal.
%
% 100322 by Matthew Nelson 
% nelsonmj@caltech.edu

if nargin<3 || isempty(alpha);      alpha = 0.05;       end
if nargin<2 || isempty(Type);       Type = 0;       end

switch Type
    case 0
        lam=1;
    case 1  %Vysochanskij–Petunin
        lam=sqrt(4/(9*alpha));
    case 2  %Chebyshev
        lam=sqrt(1/alpha);
end

sem= nanstd(Dat,0,1) ./ sqrt( sum(~isnan(Dat),1) ) * lam;
tmpmn=nanmean(Dat,1);

Err=[tmpmn + sem; tmpmn-sem];