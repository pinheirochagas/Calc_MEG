function D = ems_permute(nIters,trl,conds,objFun,varargin)
%
% function D = ems_permute(nIters,trl,conds,objFun,varargin)
%
% Performs a permutation test on the given objective function applied to 
% the surrogate trials. Returns the distribution at each time point.
% The return value, D, has time in the columns and iteration in the rows.
%
% Aaron Schurger
% 30 October 2012
%

trl = full(trl)'; % need to transpose so that [time x trials]
sz = size(trl);
nTP = sz(1);
nTrials = sz(2);
trl = reshape(trl,[1 sz]);
D = zeros(nIters,nTP);
allTrials = true(nTrials,1);
shfls = shuffle([1:nTrials]',nIters);
if iscell(conds)
    if iscolumn(conds)
        conds = conds';
    end
    conds = cell2mat(conds);
end

for i=1:nIters
    disp(i)
    D(i,:) = objFun(trl,conds(shfls(:,i),:),allTrials,varargin{:});
end

return