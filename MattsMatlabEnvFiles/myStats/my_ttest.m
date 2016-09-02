function [h,p,ci,PreTests,stats] = my_ttest(x,m,alpha,tail,dim,TransFlag,noplots)
% function [h,p,ci,PreTests,stats] = my_ttest(x,m,alpha,tail,dim,TransFlag,noplots)
%
% Written by MJN on 080410
%
% Unlike matlab's t-test, this assumes the differences are in x.... so
% don't input x and y
% 
% Set TransFlag to 1 do a sqrt transformation (moderate severity) or to 2
% to do a log10 transformation (more severe). Set to 0 to do no
% transformation (the DEFAULT). If a transformation is done, the confidence
% intervals are re-transformed to their appropriate values
%
% If noplots is set to 1, it won't plot the distribution if it fails the
% tests. default is for it to plot the dist. upon normality failure
%
% The intention of this file is to perform the tests as I'd like to do them
% to be sure that the ttest2 assumptions aren't violated too badly on a 
% dataset before running a ttest2 (see anovan). If any of the assumptions 
% are violated the program will plot a histogram of all the cells, while 
% displaying the values of all the various statistics in appropriate 
% places. The anovan is still ultimately in all cases, even if the 
% assumptions are considered violated based on the parameters set within 
% this file.
%
% The only test really to be performed is the normality one.
%
% Note- presently the parameters for the assumption Pass/Fail cutoffs are 
% hard-coded into this program. If that becomes a problem and it's desired 
% to make these an input to this functino, I can add that later, probably 
% by making an options structure the third input before varargin. (see 
% CorrectData from the impedance study supplementary code)
%
% Also note, this doesn't deal with the independence assumption. All RTs
% (and I'd be willing to bet trial by trial neural data too) show
% correlations between trials, but provided that the parameters being
% investigated is randomly assorted across trials it shouldn't matter (see
% the non-stationary ms for more details.)
%
% Inputs are the same as ttest2(y, group, varargin)
%
% Outputs are the same as ttest2 except that the second output is a
% structure PreTests that has the following fields: 
%   PreTests.n          -cell array of Samp Sizes per cell (i.e. cell of the ANOVA)
%   PreTests.Skew       -cell array of Skew statistic per cell
%   PreTests.Kurt       -cell array of Kurtosis statistic per cell
%
%   Of course for ttest2 there are always only 2 cells (the above was
%   copied from my_anovan)


%Note- accoridng to one paper, testing for ... therefore the default will
%be to do the unequal variances test and not test for variance... if
%vartype is input as 'equal' though, we will test for the variance ratio
%
% The ref for not testing for equality of variances: Zimmerman DW A note on preliminary tests of equality of variances Br J Math Stat Psychol. (2004)
if nargin<7 || isempty(noplots)   noplots=0;     end
if nargin<6 || isempty(TransFlag)   TransFlag=0;     end
if nargin<5 || isempty(dim)   dim=[];     end
if nargin<4 || isempty(tail)   tail='';     end
if nargin<3 || isempty(alpha)   alpha=[];     end
if nargin<2 || isempty(m)   m=[];     end

%%%%% Set the parameter cutoffs for test failure
% ratio of largest to smallest variance > 4
% unequal cell sizes- ratio of largest to smallest cell >2
% skewness above 1 (or below -1... i.e. test abs value of skew
% kurtosis below 1.5 or above 5 (kurtosis of a normal dist is 3... see note below for kurtosis and matlab
CU.VarRat=4;
CU.SizeRat=2;
CU.Skew=1;
CU.Kurt=[1.5 5];

%initialize
FailTest=0;

%remove nans
x=x(~isnan(x)); 

if TransFlag
    if TransFlag==1;        x=sqrt(x);      end
    if TransFlag==2;        x=log10(x);      end    
end

%do tests
PreTests.n=length(x);
PreTests.Skew=skewness(x,0);
PreTests.Kurt=kurtosis(x,0);

if abs(PreTests.Skew)>CU.Skew || ~isbetween(PreTests.Kurt,CU.Kurt)
    FailTest=1;
    disp('Data failed ttest asssumption tests.')    
    disp(['Skew: ' num2str(PreTests.Skew)])
    disp(['Kurt: ' num2str(PreTests.Kurt)])
    
    %plot the distribution
    if ~noplots
        cf=gcf;
        myHist(x);
        title(['n: ' num2str(PreTests.n) ', skew: ' num2str(PreTests.Skew) ', kurt: ' num2str(PreTests.Kurt)])
        xlabel(['sample values']);
        ylabel('count')
        AxisAlmostTight(.02,1)
        figure(cf);
    end
end

[h,p,ci,stats] = ttest(x,m,alpha,tail,dim);
ci=[ci(1) mean(ci) ci(2)];
if TransFlag
    if TransFlag==1;         ci=ci.^2;       end
    if TransFlag==2;         ci=10.^ci;         end    
end
PreTests.FailTest=FailTest;