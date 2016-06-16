function stderr = ems_bootstrap(nIters,trl,conds,objFun,varargin)
%
% function stderr = ems_bootstrap(nIters,trl,conds,objFun,varargin)
%
% Computes the bootstrap standard error of the given objective function
% applied to the surrogate trials.
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
ind = randi(nTrials,[nTrials,nIters]);

for i=1:nIters
    D(i,:) = objFun(trl(:,:,ind(:,i)),conds,allTrials,varargin{:});
end

stderr = std(D,0,1);

return