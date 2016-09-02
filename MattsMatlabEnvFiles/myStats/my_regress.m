function [b,bint,PreTests,r,rint,stats] = my_regress(y,X,alpha,DispFlag)
% function [b,bint,PreTests,r,rint,stats] = my_regress(y,X,alpha,DispFlag)
%
% Written by MJN on 080410
%
% The intention of this file is to perform tests of the assumptions of a 
% linear regression as I'd like to do them too be sure they aren't violated
% too badly on a dataset before running regress (see my_anovan). If any of 
% the assumptions are violated the program will plot a histogram of the
% resuiduals from the fit, along with a scatter plot of the residuals vs.
% the y variable, while displaying the values of all the various statistics
% in appropriate places. The regression is still ultimately done in all cases, 
% even if the assumptions are considered violated based on the parameters 
% set within this file.
%
% Note- presently the parameters for the assumption Pass/Fail cutoffs are 
% hard-coded into this program. If that becomes a problem and it's desired 
% to make these an input to this function, I can add that later, probably 
% by making an options structure the third input before varargin. (see 
% CorrectData from the impedance study supplementary code)
%
% Also note, this doesn't deal with the independence assumption. See stats
% notes, btu according to a northwestern website, if independence is
% violated, the slope estimates will be unbiased, btu the variance
% estimates will be off (which means confidence intervals and significance
% testing will be off).
%
% Inputs are the same as regress(y,X,alpha)
%
% Outputs are the same as regress except that the third output is a
% structure PreTests that has the following fields: 
%   PreTests.n          -Sample size
%   PreTests.Skew       -Skew statistic of resid
%   PreTests.Kurt       -Kurtosis statistic of resid
%   PreTests.RSl        -slope of residuals (squared) vs. y
%   PreTests.RSlInt     -Conf. Int of Slope of resid (squared) vs. y

%b/c this program may creates plots, we want to record the current figure and axes when
%entering this program, and return to make those current when leaving this
%program
cf=gcf;
ca=gca;

if nargin<4 || isempty(DispFlag)   DispFlag=0;     end      
if nargin<3 || isempty(alpha)   alpha=.05;     end      %Note- matlab's regress can't handle an empty input for alpha, and I don't want to change matlab's regress, so just give it an alpha of 0.05

%%%%% Set the parameter cutoffs
% skewness above 1 (or below -1... i.e. test abs value of skew
% kurtosis below 1.5 or above 5 (kurtosis of a normal dist is 3... see note below for kurtosis and matlab
% We will also test if the squared residuals are correlated with the y-value, and
% determine a violation
CU.Skew=1;
CU.Kurt=[1.5 5];

%initialize
FailTest=0;

NanInds=isnan(y) | any(isnan(X),2);
y=y(~NanInds);
X=X(~NanInds,:);
[b,bint,r,rint,stats] = regress(y,X,alpha);
bint=[bint(:,1) b bint(:,2)];
predY=X*b;

%do tests on normality of resid.
PreTests.n=length(r);
PreTests.Skew=skewness(r,0);
PreTests.Kurt=kurtosis(r,0);

%this would be like a homogenity of variance test... if normailty above holds, this test should be good enough... 
% otherwise we could get into an infinite loop if this called my_regress
% for example
if ~all( isnan(r) )
    [PreTests.RSl,PreTests.RSlInt]=regress(r.^2,[repmat(1,length(y),1) predY]);
end

if abs(PreTests.Skew)>CU.Skew || ~isbetween(PreTests.Kurt,CU.Kurt) || ~xor(PreTests.RSlInt(2,1)>0,PreTests.RSlInt(2,2)>0)
    FailTest=1;
    
    if DispFlag
        disp('Data failed regress asssumption tests.')
        disp(['Skew: ' num2str(PreTests.Skew)])
        disp(['Kurt: ' num2str(PreTests.Kurt)])
        if isfield( PreTests,'RSlInt' )
            disp(['RSlInt: ' num2str(PreTests.RSlInt(2,:))])
        end
    end
    
    %plot the distribution
%     figure 
%     subplot(211)
%     myHist(r,[],[],[],1);
%     title(['my regress normailty test failure. n: ' num2str(PreTests.n) ', skew: ' num2str(PreTests.Skew) ', kurt: ' num2str(PreTests.Kurt)])
%     xlabel(['residual values']);
%     ylabel('count')
%     AxisAlmostTight(.02,1)
%     
%     subplot(212)
%     scatter(predY,r,10,[0 0 0],'o')
%     AxisAlmostTight    
    %If it's too heteroscedastic, try tarnsforming y a=or doing a Spearman rank correlation
end

PreTests.FailTest=FailTest;

%b/c this program may creates plots, we want to record the current figure and axes when
%entering this program, and return to make those current when leaving this
%program
figure(cf);
axes(ca);

