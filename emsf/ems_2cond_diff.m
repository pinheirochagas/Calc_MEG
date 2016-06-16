function [trl,msf,C] = ems_2cond_diff(DATA,conds,grpInd,varargin)
%
% function [trl,msf] = ems_2cond_diff(DATA,conds,grpInd,[noiseCov])
%
% Same as ems_ncond, but specific for 2-cond difference, and
% optimized to run fast for this specific objective function.
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
% [noiseCov]: A binary flag (0 or 1) to multiply by the inverse noise
%             covariance matrix. The matrix is computed based on the
%             pooled residuals around the condition means. With this option
%             enabled, the function implements Fisher's linear discriminant
%             (FLD). Caveat: the topographies of the spatial filter(s) are
%             not directly interpretable with this option enabled, although
%             it may improve sensitivity to very weak effects.
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

[noiseCov, tWin] = parse_varargin(varargin);

if ~isempty(tWin)
    error('Time window functionality is not implemented yet!');
end

szDATA = size(DATA);
tot_nTrials = szDATA(3);
nSensor = szDATA(1);
nTimePoints = szDATA(2);

if iscell(conds)
    % make sure cell array is horizontal before cell2mat
    if iscolumn(conds)
        conds = conds';
    end
    conds = cell2mat(conds);
end
conds = (conds==1); % force to be logical index

trlSel = find(max(conds,[],2));
nTrials = length(trlSel);

if ~(nTrials == sum_nTrials(conds))
    error('Selection of trials in cond1 and cond2 must not overlap.')
end

sf = zeros(nSensor,nTimePoints);
trl = spalloc(tot_nTrials,nTimePoints,nTrials*nTimePoints);
if nargout>2
    C = spalloc(tot_nTrials,nTimePoints,nTrials*nTimePoints);
end
%trl = zeros(tot_nTrials,nTimePoints,'single');
trainTrials = false(tot_nTrials,1);

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
    nlo1 = length(lvout_ind1); nlo2 = length(lvout_ind2);
    % trials to project on to the spatial filter
    proj_ind = [lvout_ind1; lvout_ind2];
    nproj = length(proj_ind);
    % go...
    if mod(i,10)==0
        disp([char(9) 'Processing trial ' num2str(i)])
    end
    % identify training and test trials
    trainTrials(trlSel) = true;
    trainTrials([lvout_ind1, lvout_ind2]) = false;
    % compute objective
    if isempty(lvout_ind1)
        M1 = (SUM1)./(N1);
    else
        M1 = (SUM1-nansum(DATA(:,:,lvout_ind1),3))./(N1-nlo1);
    end
    if isempty(lvout_ind2)
        M2 = (SUM2)./(N2);
    else
        M2 = (SUM2-nansum(DATA(:,:,lvout_ind2),3))./(N2-nlo2);
    end
    %%%%%%%%%%
    d = M1-M2;
    %%%%%%%%%%
    if noiseCov % apply noise covariance matrix, if asked for
        nc = makeNoiseCovMat(DATA,trainTrials,conds,(N1-nlo1),(N2-nlo2),M1,M2);
        if (N1-nlo1)==0 || (N2-nlo2)==0
            invnc=1; % else you will get an error from pinv
        else
            invnc = pinv(nc);
        end
        %invnc = invnc ./ norm(invnc);
        d = invnc*d;
    end
    for j=1:nTimePoints % norm the spatial filters
        d(:,j) = d(:,j)./norm(d(:,j));
    end
    % update mean spatial filter
        sf = sf+d;
    % apply spatial filter to "left-out" trial(s)
    for j=1:nproj
       trl(proj_ind(j),:) = nansum(DATA(:,:,proj_ind(j)) .* d,1);
       if nargout>2
           C(proj_ind(j),:) = nansum(((M1+M2)./2) .* d,1);
       end
    end
end
msf = sf./nGrps; % mean spatial filter
msf = make_unit_norm(msf,1); % after averaging, re-norm the columns

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
    

function [noiseCov, tWin] = parse_varargin(V)

    % default values
    noiseCov=[];
    tWin=[];
    
    % assigned values
    if ~isempty(V)
        noiseCov = V{1};
        if length(V)>1 % time window
            tWin = varargin{1};
        end
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

