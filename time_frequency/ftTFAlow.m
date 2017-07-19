function [TFR, trialinfo] = ftTFAlow(data)

load SensorClassification;
data=ftn_addtypelabelneighb(data);

cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmconvol';
cfg.trials       = 'all' ;
cfg.keeptrials   ='yes';
cfg.trackdatainfo='yes';                
cfg.channel      = All2; 
cfg.foi          = 2:1:34;                    % frequencies of interest [2 to 35 in steps of 1Hz]
cfg.toi          = -0.2:0.04:.8;             % time on which the window is centered = from -0.8s to 1.2s in steps of 0.04 s
cfg.t_ftimwin    = 0.2*ones(length(cfg.foi),1)
%cfg.toi          = -0.5:0.04:4.5;             % time on which the window is centered = from -0.8s to 1.2s in steps of 0.04 s
% for i=1:length(cfg.foi)
%     if cfg.foi(i)<=10
%         cfg.t_ftimwin(i) = 0.5;               % length of time window fixed to 500 ms
%     else
%         cfg.t_ftimwin(i)    = 5./cfg.foi(i);  % length of time window = frequency dependent (5 cycles)
%     end;
% end;
cfg.taper        = 'hanning';

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