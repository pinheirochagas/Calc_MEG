function dataout = calc_downsample(data) 

% Define configuration file
cfg.resamplefs = 100;
cfg.detrend    = 'no';
cfg.demean     = 'no';
cfg.feedback   = 'text';
cfg.trials     = 'all';

dataout = ft_resampledata(cfg, data);

for i=1:length(data.triggers)
    dataout.triggers{i}(:,1) = round(data.triggers{i}(:,1)/(1000/cfg.resamplefs)); % Correct the timing of the triggers
end

dataout.sampleinfo = data.sampleinfo; % this is the original sample raw information
dataout.trialinfo = data.trialinfo;

end