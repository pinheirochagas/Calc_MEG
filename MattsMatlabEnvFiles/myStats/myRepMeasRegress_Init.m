function [b,bint,p] = myRepMeasRegress_Init(Y,X)
% Done this way initiaLLY for thE Paris Imp project, but a better, more general
% version of this function exists in: myRepMeasRegress.m
%
%
%   Y is a nS x nX size matrix of dependent values.
%   X is a nX x 1 (or 1 x nX) vector of independent values
%       so right now this only written to allow for the inclusion of one
%       factor, but it could be adjusted later (if desired) to account for
%       and test more factors in X...
%
%   This analysis runs a linear repeated measures regression (ie
%   considering subjects as a random factor)
%
%   NOTE- a constant "intercept" factor of 1 is automatically added to
%   the model in X when calling this function...
%
% See Lorch + Myers "Regression Analyses of Repeated Measures Data in
% Cognitive Research" (1990)
%
% This method assumes homosecdasticity if the data. There are other methods
% available that do not require this assumption.
%
% Matthew Nelson Apr-22-2014
% matthew.nelson.neuro@gmail.com

% make X necessarily a column vector
[r c]=size(X);
if c>r;     X=X';       end

[nS, nX]=size(Y);

b_subj=NaN(nS,2);
for iS=1:nS
    if sum(~isnan(Y(iS,:)))>1
        b_subj(iS,:)=regress( Y(iS,:)', [ones(nX,1) X] );
    else
        b_subj(iS,:)=NaN;
    end
end
[~,p,ci]=ttest( b_subj(:,2) );
[~,~,ci2]=ttest( b_subj(:,1) );

%%% Adjust the output to the b,bint, and pval form to make the outputs
%%% (roughly) in the same format as matlab's regress function

b=nanmean(b_subj)';
bint=[ci2'; ci'];
