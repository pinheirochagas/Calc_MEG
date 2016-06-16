function [data_epoch, ECGEOG, alltrigNew] = calc_definetrial(par, dataset, databh, data_cont)
cfg = [];
cfg.headerformat        = 'neuromag_mne';
cfg.dataformat          = 'neuromag_mne';
cfg.dataset             = dataset;
cfg.databh              = databh;
cfg.trialdef.channel    = 'STI101';
cfg.trialdef.eventvalue = par.EventValue;
cfg.trialdef.prestim    = par.epoch(1);
cfg.trialdef.poststim   = par.epoch(2);
cfg.sampleinfo          = data_cont.sampleinfo;
cfg.trialfun            = 'calc_trialfun_neurospin';
cfg.photodelay          = 0.05; % in seconds
% cfg.sampleinfo          = data_cont.sampleinfo;

% Retrieve trials from behavior  
[trigger_bh, onsets_bh] = retrieveEventsCalc(cfg);

% Retrieve trials from MEG correcting for behavior
[trl, alltrig, alltrigNew, hdr] = calc_trialfun_neurospin(cfg, trigger_bh);

% Correct triggers
% [trl,alltrig] = calc_correctTriggers(trl, alltrig, trigger_bh)
cfg.trl = trl;

%%
data_epoch = ft_redefinetrial(cfg, data_cont);

% % downsample
% cfg = [];
% cfg.resamplefs = 250;
% cfg.detrend    = 'no';
% cfg.demean     = 'no';
% cfg.feedback   = 'text';
% cfg.trials     = 'all';
% data_epoch= ft_resampledata(cfg,data_epoch);

data_epoch.triggers.trl = trl;
data_epoch.triggers.alltrig = alltrig;

ECGEOG =data_epoch.trial;
idxEOGECG = [find(strcmp('EOG061', data_epoch.label)), ...
    find(strcmp('EOG062', data_epoch.label)), ...
    find(strcmp('ECG063', data_epoch.label))];
for tmp=1:length(ECGEOG)
    ECGEOG{tmp}=ECGEOG{tmp}(idxEOGECG,:);
end
param = [];
param.channel = {'MEG*'};
data_epoch = ft_selectdata_new(param, data_epoch);
% data_epoch.ECGEOG = ECGEOG;

