function d = spf_basic_2cond_diff(DATA,conds,trlSel)
%
% function d = spf_basic_2cond_diff(DATA,conds,trlSel)
%
% A basic objective function for xval_spat_filt_ncond
%

if iscell(conds)
    M1 = squeeze(nanmean(DATA(:,:,conds{1}&trlSel),3));
    M2 = squeeze(nanmean(DATA(:,:,conds{2}&trlSel),3));
else
    M1 = squeeze(nanmean(DATA(:,:,conds(:,1)&trlSel),3));
    M2 = squeeze(nanmean(DATA(:,:,conds(:,2)&trlSel),3));
end
d = M1-M2;


