function [h,p,ci,PreTests,stats] = my_ttest2(x,y,alpha,tail,vartype,dim)
% function [h,p,ci,PreTests,stats] = my_ttest2(x,y,alpha,tail,vartype,dim)
%
% Written by MJN on 080410
%
% vartype determines if equal or unexual variances are used...
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
%   PreTests.Var        -cell array of Variances per cell
%   PreTests.Skew       -cell array of Skew statistic per cell
%   PreTests.Kurt       -cell array of Kurtosis statistic per cell
%   PreTests.MaxVarRat  -scalar ratio of largest cell variance to smalles cell variance 
%   PreTests.MaxNRat    -scalar ratio of largest cell num of samps to smallest cell num of samps
%   PreTests.FailTest=FailTest;
%
%   Of course for ttest2 there are always only 2 cells (the above was
%   copied from my_anovan)



%
if nargin<6 || isempty(dim)   dim=[];     end
if nargin<5 || isempty(vartype)
    if length(x)==length(y)
        vartype='equal';
    else
        vartype='unequal';
    end    
else
    %Note- accoridng to one paper, testing for ... therefore the default will
    %be to do the unequal variances test and not test for variance... if
    %vartype is input as 'equal' though, we will test for the variance ratio
    if strcmp(vartype,'equal')     warning('See Zimmerman raticle. Pre-test for eq. variances is a bad idea. Always doing the unequal variances test is recommended.');     end
    % The ref for not testing for equality of variances: Zimmerman DW A note on preliminary tests of equality of variances Br J Math Stat Psychol. (2004)
    % ... BUT, there is increased power in the equal variances test..., so there is some reason to sometimes try that
    %   but only do this if vars AND sample sizes in both groups are equal...
end
%note- matlab's ttest2 assumes equal variances if no val for vartype is
%given to it...

if nargin<4 || isempty(tail)   tail='';     end
if nargin<3 || isempty(alpha)   alpha=[];     end


%%%%% Set the parameter cutoffs
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
x=x(~isnan(x));      y=y(~isnan(y)); 

%do tests
for iv=1:2
    if iv==1     cv=x;      else    cv=y;   end
    PreTests.n(iv)=length(cv);
    PreTests.Var(iv)=var(cv);
    PreTests.Skew(iv)=skewness(cv,0);
    PreTests.Kurt(iv)=kurtosis(cv,0);
end
PreTests.MaxVarRat=max(PreTests.Var)/min(PreTests.Var);
PreTests.MaxNRat=max(PreTests.n)/min(PreTests.n);

if PreTests.MaxVarRat>CU.VarRat || PreTests.MaxNRat>CU.SizeRat || any(abs(PreTests.Skew)>CU.Skew) || any(~isbetween(PreTests.Kurt,CU.Kurt))
    FailTest=1;
    disp('Data failed anovan asssumption tests.')
    disp(['MaxVarRat: ' num2str(PreTests.MaxVarRat) ' MaxNRat: ' num2str(PreTests.MaxNRat)])
    disp(['Skew: ' num2str(PreTests.Skew)])
    disp(['Kurt: ' num2str(PreTests.Kurt)])
    
    %plot the two distributions
    cf=gcf;
    figure
    for iv=1:2
        if iv==1     cv=x;      else    cv=y;   end
        h(iv)=subplot(1,2,iv);
        myHist(cv,[],[],[],1);
        title(['n: ' num2str(PreTests.n(iv)) ', var: ' num2str(PreTests.Var(iv)) ', skew: ' num2str(PreTests.Skew(iv)) ', kurt: ' num2str(PreTests.Kurt(iv))])
        xlabel(['samp ' num2str(iv) ' values']);
        ylabel('count')
        AxisAlmostTight(.02,1)
    end
    StandardizeAxes(h);
    figure(cf);
end
 
[h,p,ci,stats] = ttest2(x,y,alpha,tail,vartype,dim);
PreTests.FailTest=FailTest;