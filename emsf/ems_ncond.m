function [trl,msf] = ems_ncond(DATA,conds,grpInd,objFun,varargin)
%
% function [trl,msf] = ems_ncond(DATA,conds,grpInd,objFun,[varargin])
%
% This version operates on the entire timecourse. No time window needs to
% be specified. The result is a spatial filter at each time point and a
% corresponding timecourse. Intuitively, the result gives the similarity
% between the filter at each time point and the data vector (sensors) at
% that timepoint.
%
% The objective function take three parameters and returns one, as follows:
% Input parameters:
%   DATA    : the data matrix [nSensors X nTimePoints X nTrials]
%   conds   : a cell array of logical indices into DATA, one for each cond
%   grpInd  : a numeric grouping variable for the leave-one-out procedure.
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
%   objFun  : an objective function to maximize. Must return a matrix of
%             [nSensors X nTimePoints]
%   [varargin] : additional (optional) parameters to be passed to objFun.
%
% Output parameter:
%   trl       : a set of surrogate trials, nTrials X nTimePoints
%   msf       : a set of spatial filters, nSensors X nTimePoints
%
% AS 25 March 2010
%

%
% MODIFICATION HISTORY
%
% 5 June 2011: Touched up the comments and help text, but did not change
% the code.
%
if isstruct(DATA) % fieldtrip structure
    DATA = myft_ftStruct2dataCube(DATA);
end
clear('fun',func2str(objFun));

szDATA = size(DATA);
tot_nTrials = szDATA(3);
nSensor = szDATA(1);
nTimePoints = szDATA(2);

if iscell(conds)
    trlSel = find(orconds(conds));
else
    trlSel = find(max(conds,[],2));
end
nTrials = length(trlSel);

if ~(nTrials == sum_nTrials(conds))
    error('Selection of trials in cond1 and cond2 must not overlap.')
end

sf = zeros(nSensor,nTimePoints);
trl = spalloc(tot_nTrials,nTimePoints,nTrials*nTimePoints);
%trl = zeros(tot_nTrials,nTimePoints,'single');
trainTrials = false(tot_nTrials,1);

if isempty(grpInd)
    grpInd = [1:tot_nTrials];
    grpInd = grpInd(trlSel);
    grpSelector = grpInd;
else
    grpInd = grpInd(trlSel);
    grpSelector = unique(grpInd);
end
nGrps=length(grpSelector);

for i=1:nGrps
    lvout_ind = trlSel(grpInd==grpSelector(i));
    disp([char(9) 'Processing trial ' num2str(i)])
    % identify training and test trials
    trainTrials(trlSel) = true;
    trainTrials(lvout_ind) = false;
    % compute objective
    d = objFun(DATA,conds,trainTrials,varargin{:});
    for j=1:size(d,2)
        d(:,j) = d(:,j)./norm(d(:,j));
    end
    % update mean spatial filter
        sf = bsxfun(@plus,sf,d);
    % apply spatial filter to "left-out" trial(s)
    if isvector(d)
        for j=1:length(lvout_ind)
           trl(lvout_ind(j),:) = squeeze(DATA(:,:,lvout_ind(j)))' * d;
        end
    else
        for j=1:length(lvout_ind)
           trl(lvout_ind(j),:) = nansum(DATA(:,:,lvout_ind(j)) .* d,1);
        end
    end
    % method below does not seem any faster, and above is easier to read
    %trl(lvout_grpInd,:) = squeeze(sum(bsxfun(@times,DATA(:,:,lvout_grpInd),sf(:,:,i)),1))';
end
msf = sf./nGrps; % mean spatial filter

% project all other trials onto the mean spatial filter
na = sum(conds,2)==0;
trl(na,:) = squeeze(nansum(bsxfun(@times,DATA(:,:,na),d),1))';


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
    

    