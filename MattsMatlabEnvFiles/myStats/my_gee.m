function [bhat,alpha,results]=my_gee(Y,X,varnames)
% note this is for rep meas lin regression. 
%
%   Y is a nS x nX size matrix of dependent values.
%   X is a nX x 1 (or 1 x nX) vector of independent values
%       it's assumed right now that X is just the factor of time, but this 
%       could easily be changed to the more general case, allowing for
%       multiple covariates in X. 
%       
% I found the fxn gee in a matlab toolbox available on the web, and I am
% just adjusting the inputs to the function to allow the user to call the
% function the way that I would like to call it.  
% 
% see fxn: RepMeasRegressSim for more nfo

if nargin<3 || isempty(varnames);       varnames={'time','constant'};     end

% make X necessarily a column vector
[r, c]=size(X);
if c>r;     X=X';       end

%keep only subjects that have no nans
if any(any( isnan(Y) ))
    disp('In my_gee. Nan''s detected in the dependent variable. The analysis currently can''t handle this. Removing all subjects with any Nan Values.')
    Y( any( isnan(Y),2 ),: )=[];
end

[nS, nX]=size(Y);
nmeas=nS*nX;

y_gee=Y';
y_gee=y_gee(:);
id=zeros(nmeas,1);
for iS=1:nS
    id( (iS-1)*nX+1:iS*nX )=iS;
end
t_gee=repmat(X,nS,1);
X_gee=[t_gee ones(nmeas,1)];

try
    [bhat,alpha,results]=gee(id,y_gee,t_gee,X_gee,'n','ar1',varnames);
catch
    disp('All subjects had at least one NaN value! Couldn''t run gee')
    bhat=NaN;       alpha=NaN;      
    results.robust{4,5}=NaN;
    results.robust{3,5}=NaN;        
end