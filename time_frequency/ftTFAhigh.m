function [TFR, trialinfo] = ftTFAhigh(data)

% about_trial = 'yes' or 'no' [(trials) x channel x fequency x timepoints]
load SensorClassification;

data=ftn_addtypelabelneighb(data);

cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmconvol';
cfg.trials       = 'all' ;
cfg.keeptrials   ='yes';
cfg.trackdatainfo='yes';                   
cfg.channel      = All2; 
cfg.foi          = 34:2:100;                       % frequencies of interest [34 to 100 in steps of 2Hz]
cfg.toi          = -0.5:0.04:4.5;                  % time on which the window is centered = from -0.5s to 4.2s in steps of 0.04s
cfg.t_ftimwin    = 0.2*ones(length(cfg.foi),1);    % length of time window = fixed to 200 ms
cfg.tapsmofrq    = cfg.foi/5;                      % frequency smoothing 20 % 
cfg.taper        = 'dpss';

TFR = ft_freqanalysis(cfg, data);    
trialinfo = data.trialinfo; 

end





% for sensor=1:3    
%     if sensor==1
%         cfg.channel      = data.typelabel.Mag2;
%     elseif sensor==2
%         cfg.channel      = data.typelabel.Grad2_1;
%     elseif sensor==3
%         cfg.channel      = data.typelabel.Grad2_2;
%     end;
%     
%     TFR{sensor} = ft_freqanalysis(cfg, data);
%     % re-label channels to match the neighbour sensors configuration
%     TFR{sensor}.label=data.typelabel.Mag2;
% end;