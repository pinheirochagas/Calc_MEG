function data_cosmo = calcConvertCOSMO(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Downsampling
cfg = [];
cfg.resample = 200;
% data_ds = ft_resampledata(cfg, data);
% Ft timelock preserving trials
cfg = [];
cfg.keeptrials = 'yes';
datatmp = ft_timelockanalysis(cfg, data); % see if you have to downsample
data_cosmo = cosmo_meeg_dataset(datatmp);
% Add trialinfo to cosmo
fieldNames = fieldnames(data.trialinfo);
for f = 1:length(fieldNames)
    data_cosmo.sa.(fieldNames{f}) = data.trialinfo.(fieldNames{f});
end


end

