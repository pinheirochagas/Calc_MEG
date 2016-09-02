function [b,bint,p] = myRepMeasRegress(Y,X,S)
%
%   Y is a n x 1 column of dependent values for all subjects
%   X is a n x nFac vector of independent values
%       so right now this only written to allow for the inclusion of one
%       factor, but it could be adjusted later (if desired) to account for
%       and test more factors in X...
%
%   Outputs are made to follow those of matlab's regress function, with the
%   addition of the p-value vector
%
%   This analysis runs a linear repeated measures regression (ie
%   considering subjects as a random factor). This is accomplished by
%   performing t-tests over participants on the regression coeeficient for 
%   all factors. This method assumes homosecdasticity if the data. There 
%   are other more complicated models and methods available to perform 
%   these analyses, but this measure still proves useful.  
%
% See Lorch + Myers "Regression Analyses of Repeated Measures Data in
% Cognitive Research" (1990)
%
% Matthew Nelson May-27-2014
% matthew.nelson.neuro@gmail.com

SList=unique(S);
nS=length(SList);
nX=size(X,2);

b_subj=NaN(nS,nX);

for iS=1:nS      
    SInds=S==iS;
    
    b_subj(iS,:)=regress( Y(SInds), X(SInds,:) );
end

[~,p,bint]=ttest( b_subj );

%%% Adjust the output to the b,bint, and pval form to make the outputs 
%%% (roughly) in the same format as matlab's regress function

b=mean(b_subj)';
bint=bint';
p=p';