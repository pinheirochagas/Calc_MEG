function [decision, tgt] = ems_2cond_decode(DATA,conds,grpInd,varargin)
%
% function [decision, tgt] = ems_2cond_decode(DATA,conds,grpInd,[error_metric])
% Similar to ems_2cond_diff, but in addition applies a nearest mean 
% classifier to each trial. A nested call to ems_2cond_diff is used to
% estimate a filter and produce a template for each condition. So this
% function takes significantly longer to run than ems_2cond_diff.
%
% Input parameters:
%   DATA    : The data matrix [nSensors X nTimePoints X nTrials]
%   conds   : A cell array of logical indices into DATA, one for each cond.
%             Can also be a matrix where each column is a logical index
%             into DATA. Each column selects a subset of trials belonging
%             to one experimental condition or category.
%   grpInd  : A numeric grouping variable for the leave-one-out procedure.
%             If specified then the leave-one-out procedure will leave one
%             out PER GROUP. For example, if the grouping vector numbers
%             the trials in condition A [1,2,3,...] and the trials in 
%             condition B [1,2,3,...] then: On each round two trials will
%             be left out, one from each condition. On the first round,
%             trials A(1) and B(1) will be left out, on the second round
%             trials A(2) and B(2) will be left out, and so on. If
%             performing the filtering across subjects, then you can use
%             this parameter to LEAVE ONE SUBJECT OUT PER ROUND. I.e. leave
%             out all trials belonging to a specific subject on each round.
% [error_metric] : How to decide which class each exemplar belongs to.
%                  1 = arithmetic difference (nearest mean) - DEFAULT
%                  2 = Gaussian naive-Bayes (highest posterior probability)
%
% Output parameter:
%   trl       : a set of surrogate trials, nTrials X nTimePoints
%   msf       : a set of spatial filters, nSensors X nTimePoints
%
% AS 9 Sep 2012
%

if isstruct(DATA) % fieldtrip structure
    DATA = myft_ftStruct2dataCube(DATA);
end

[error_metric] = parse_varargin(varargin);

szDATA = size(DATA);
tot_nTrials = szDATA(3);
nSensor = szDATA(1);
nTimePoints = szDATA(2);

if iscell(conds)
    conds = cell2mat(conds);
end

trlSel = find(max(conds,[],2));
nTrials = length(trlSel);
nConds = size(conds,2);

if ~(nTrials == sum_nTrials(conds))
    error('Selection of trials in cond1 and cond2 must not overlap.')
end

trl = spalloc(tot_nTrials,nTimePoints,nTrials*nTimePoints);
if nargout>2
    C = spalloc(tot_nTrials,nTimePoints,nTrials*nTimePoints);
end
msf = zeros(nSensor,nTimePoints);
M = zeros(nConds,nTimePoints);
S = zeros(nConds,nTimePoints);
decision = zeros(nTrials,nTimePoints);
trainTrials = true(tot_nTrials,1);
tst = zeros(1,nTimePoints);
tgt = conds * [1:nConds]'; % the correct decisions

if isempty(grpInd)
    grpInd = [1:tot_nTrials]';
    grpInd = grpInd(trlSel);
    grpSelector = grpInd;
else
    grpInd = grpInd(trlSel);
    grpSelector = unique(grpInd);
end
nGrps=length(grpSelector);

% idea is that mean with trial(x) left out is overall sum minus trial(x),
% divided by nTrials-1
SUM1 = nansum(DATA(:,:,conds(:,1)),3); % across trials for cond 1
N1 = sum(conds(:,1)); % number
SUM2 = nansum(DATA(:,:,conds(:,2)),3); % across trials for cond 1
N2 = sum(conds(:,2));    

for i=1:nGrps
    % trials to leave out of the computation
    lvout_ind1 = trlSel(grpInd==grpSelector(i) & conds(trlSel,1));
    lvout_ind2 = trlSel(grpInd==grpSelector(i) & conds(trlSel,2));
    % trials to project on to the spatial filter
    proj_ind = [lvout_ind1; lvout_ind2];
    % go...
    if mod(i,10)==0
        disp([char(9) 'Processing trial ' num2str(i)])
    end
    % identify training and test trials
    trainTrials(:) = true;
    trainTrials([lvout_ind1; lvout_ind2]) = false;
    nTrain = sum(trainTrials);
    
    [trl(trainTrials,:),msf(:)] = ems_2cond_diff(DATA(:,:,trainTrials),conds(trainTrials,:),grpInd(trainTrials),varargin{:});
    
    for j=1:nConds
        M(j,:) = nanmean(trl(conds(:,j)&trainTrials,:),1);
        S(j,:) = nanstd(trl(conds(:,j)&trainTrials,:),0,1);
    end
    
    for j=1:length(proj_ind)
        % apply mean spatial filter to left-out trial to get test measure
        tst(:) = nansum(DATA(:,:,proj_ind(j)) .* msf,1);
        % DECIDE
        if error_metric == 1 % nearest mean
            [~,decision(proj_ind(j),:)]=min(abs(bsxfun(@minus,full(tst),M)),[],1);
        elseif error_metric == 2 % GNB
            [decision(proj_ind(j),:)]=2-gnb_decide(M(2,:),S(2,:),M(1,:),S(1,:),tst,0,1);
        else
            error('Invalid error metric. Must be 1 (distance) or 2 (GNB).')
        end
    end
end

% project other trials onto the mean spatial filter
nConds = size(conds,2);
if nConds>2
    na = ~(sum(conds(:,3:nConds),2)==0);
else
    na = 0;
end
if sum(na)>0
    trl(na,:) = squeeze(nansum(bsxfun(@times,DATA(:,:,na),d),1))';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function condunion = orconds(conds)
%
% recursively put together union of all conds in cell array
%

    nConds = length(conds);

    if nConds==0
        condunion = [];
    elseif nConds==1
        condunion = conds{1};
    else
        condunion = or(conds{1},orconds(conds(2:nConds)));
    end


function nTrials = sum_nTrials(conds)
%
% compute the total number of trials in all conditions in cell array conds
%

    nTrials = 0;
    if iscell(conds)
        for i=1:length(conds)
            nTrials = nTrials+sum(conds{i});
        end
    else
        nTrials = sum(sum(conds));
    end
    

function [error_metric] = parse_varargin(V)

    % default values
    error_metric = 1;
    
    % assigned values
    if ~isempty(V)
        error_metric = V{1};
    end
    
function nc = makeNoiseCovMat(DATA,lvin,conds,n1,n2,M1,M2)

    sz = size(DATA);
    mat1 = (reshape(bsxfun(@minus,DATA(:,:,conds(:,1)&lvin),M1),sz(1),sz(2)*n1)');
    mat2 = (reshape(bsxfun(@minus,DATA(:,:,conds(:,2)&lvin),M2),sz(1),sz(2)*n2)');
    cov1 = (mat1' * mat1) / (n1-1);
    cov2 = (mat2' * mat2) / (n2-1);
    nc = (cov1*n1 + cov2*n2) ./ (n1+n2); % weighted avg covariance
    return
    
%     nc = cov([ reshape(bsxfun(@minus,DATA(:,:,conds(:,1)&lvin),M1),sz(1),sz(2)*n1),...
%                reshape(bsxfun(@minus,DATA(:,:,conds(:,2)&lvin),M2),sz(1),sz(2)*n2)]');

