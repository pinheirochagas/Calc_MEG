function d = spf_basic_2time_diff(DATA,conds,trlSel,tWin,t0,SR)
%
% function d = spf_basic_2time_diff(DATA,conds,trlSel,tWin,SR,t0)
%
% A basic objective function for xval_spat_filt_ncond
%
% Takes a difference between the mean in two time windows.
% The second parameter, conds, is just a placeholder. Not used here.
% DATA is [sensors x timePoints x trials]
% tWin is a cell array with two items, each selecting a time range in
% seconds, as [t1 t2].
%
persistent sWin

if isempty(sWin)
    sWin{1} = range2vec(seconds2samples(tWin{1},t0,SR));
    sWin{2} = range2vec(seconds2samples(tWin{2},t0,SR));
end

if iscell(conds)
    M1 = squeeze(nanmean(nanmean(DATA(:,sWin{1},trlSel),3),2));
    M2 = squeeze(nanmean(nanmean(DATA(:,sWin{2},trlSel),3),2));
else
    M1 = squeeze(nanmean(nanmean(DATA(:,sWin{1},trlSel),3),2));
    M2 = squeeze(nanmean(nanmean(DATA(:,sWin{2},trlSel),3),2));
end
d = repmat(M1-M2,1,size(DATA,2));


