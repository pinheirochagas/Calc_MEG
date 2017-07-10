function [TFR, trialinfo] = ftTFAcres(data)

% about_trial = 'yes' or 'no' [(trials) x channel x fequency x timepoints]
load SensorClassification;

data=ftn_addtypelabelneighb(data);

cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.trials       = 'all' ;
cfg.keeptrials   = 'yes';
cfg.trackdatainfo= 'yes';                   
cfg.channel      = Grad2; 
cfg.foi          = 1:1:40;                       % frequencies of interest [34 to 100 in steps of 2Hz]
cfg.tapsmofrq    = cfg.foi/5;                      % frequency smoothing 20 % 
cfg.taper        = 'hanning';

TFR = ft_freqanalysis(cfg, data);    
trialinfo = data.trialinfo; 

end
