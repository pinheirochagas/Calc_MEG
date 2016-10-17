function [p F Adj_df eps EffectList table stats] = myRepMeasAnovan(Y,g,varargin)
%NOTE- this is unfinsihed... if I ever need this, i can finish it
%
%
% The only remaining thing that needs to be done to complete this is code
% up a way to match the eps corrections to the proper row values in
% table...
% To do so would require using pascal's triangle to find each effect we
% care about in the table output, given the number of factors input
%
%
%[p F Adj_df eps table stats] = myRepMeasAnovan(Y,g,varargin)
%
% Given the observation that a Repeated measures anov
%
%
% Inputs:
%       Y:      The dependent variable. A column vector of observations
%       g:      The group array. Can be a numeric array or a cell array. 
%               the length of its dimension related to observations must
%               match that of Y
%varargin:      Any otehr params you woudl send in to anovan
%       Or, if you can only input the two params, and the program will call
%       anovan as needed to perform the within subjects anova (Recommended)
%
%       This assumes that the last variable enetered is the subjects
%       variable
%
% Outputs:
%       p:      The pvalue


% Note, for right now, this is only designed to work when all the factors
% are repeated


%Note- I have no idea how one would specify w/in vs b/t subj factors... I
%think the result is that subjects are nested within b/t subj factors,
%and fully crossed w/ b/t subj factors...
%
%I'm not worrying about mixed models at the moment though... only purely
%w/in subj tests, as I think that's what I'll have to deal with the most
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EpsType=2;  %1 for HF, 2 For GG

SubjFac=size(g,2);  %assume subj. is the last factor


if nargin>2
    astr='';
    for iV=1:length(varargin)
        if ischar(varargin{iV})
            astr=[astr ',''' varargin{iV} '''' ];
        elseif isnumeric(varargin{iV})
            astr=[astr ',[' num2str(varargin{iV}) ']'];
        elseif iscell(varargin{iV})
            astr=[astr ',{' varargin{iV} '}'];
        end
    end
    
    eval(['[initp,table,stats] = anovan(Y,g' astr ');'])
else
    % notes on using anovan with random effects for the subject factor to do rep meas anovas:          
    % it doesn't matter if the intercation term(s) between the random subject factor 
    % and everything else is included in the model or not. Such factors are calculated by matlab as 
    % p-values of NaN. The reality is that these MS's are the error terms for tetsing all other effects.   
    
    [initp,table,stats] = anovan(Y,g,'display','off','random',SubjFac,'model','full');
end

[eps1,EffectList,eps2]=GenCalcHFEps(Y,[],g(:,1:end-1),g(:,end));



if EpsType==1;      
    disp('Using HF epsilon')
    eps=eps1;       
else
    disp('Using GG epsilon')
    eps=eps2;
end

%below an example of how to do correction for the sceond main effect in a
%2-way rep meas anova...
F2=table{3,6};
dfnum2=table{3,3};
dfden2=table{3,11};
adjp2 =1 - fcdf(F2,dfnum2*eps(2),dfden2*eps(2));