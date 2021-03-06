




cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'all';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.foi          = 2:2:30;                         % analysis 2 to 30 Hz in steps of 2 Hz 
cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 0.5 sec
cfg.toi          = -0.5:0.05:4.5;                  % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
TFRhann = ft_freqanalysis(cfg, data);

cfg = [];
cfg.baseline     = [-0.5 -0.1]; 
cfg.baselinetype = 'absolute'; 
% cfg.zlim         = [-3e-27 3e-27];	        
cfg.showlabels   = 'yes';	
cfg.layout       = 'neuromag306cmb.lay';
figure 
ft_multiplotTFR(cfg, searchlight_ft_allsub);



cfg = [];
cfg.baseline     = [-0.5 -0.1];
cfg.baselinetype = 'absolute';  
cfg.maskstyle    = 'saturation';	
cfg.zlim         = [-3e-26 3e-26];	
cfg.channel      = 'MEG2041';
figure(1)
ft_singleplotTFR(cfg, TFR);
figure(2)



cfg = [];
cfg.baseline     = [-0.5 -0.1];	
cfg.baselinetype = 'absolute';
cfg.xlim         = [1.6 2.4];   
cfg.zlim         = [-1.5e-27 1.5e-27];
cfg.ylim         = [0 10];
cfg.layout       = 'neuromag306mag.lay';
cfg.marker       = 'on';
figure 
ft_topoplotTFR(cfg, TFRhann);








%% Addition and subtraction
data_addsub = data;
addsub_trials = data_addsub.trialinfo.operator ~= 0;





data_addsub.ECGEOG = data_addsub.ECGEOG(addsub_trials);
data_addsub.trial = data_addsub.trial(addsub_trials);
data_addsub.sampleinfo = data_addsub.sampleinfo(addsub_trials,:);
data_addsub.triggers = data_addsub.triggers(addsub_trials);
data_addsub.time = data_addsub.time(addsub_trials);

fieldnames_ti = fieldnames(data_addsub.trialinfo);

for i = 1:length(fieldnames_ti)
    data_addsub.trialinfo.(fieldnames_ti{i}) = data_addsub.trialinfo.(fieldnames_ti{i})(addsub_trials);
end



%% TF


cfg              = [];
cfg.keeptrials   ='yes';
cfg.trackdatainfo='yes';
cfg.output       = 'pow';
cfg.channel      = 'all';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.foi          = 2:2:30;                         % analysis 2 to 30 Hz in steps of 2 Hz 
cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 0.5 sec
cfg.toi          = -0.5:0.05:4.5;                  % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
data_addsub_TF = ft_freqanalysis(cfg, data_addsub);


cfg.toi          = -0.8:0.04:1.2;                  % time on which the window is centered = from -0.8s to 1.2s in steps of 0.04 s
cfg.t_ftimwin    = 0.2*ones(length(cfg.foi),1);    % length of time window = fixed to 200 ms


data_addsub.trialinfo.operator'

% convert to cosmomvpa struct
ds_tf=cosmo_meeg_dataset(data_addsub_TF);

% set the target (conditions' labels)
ds_tf.sa.targets=data_addsub.trialinfo.operator';

ds_tf.sa = rmfield(ds_tf.sa, 'cumtapcnt')


cfg = [];
% cfg.baseline     = [-0.5 -0.1]; 
cfg.baselinetype = 'absolute'; 
% cfg.zlim         = [-3e-27 3e-27];	        
cfg.showlabels   = 'yes';	
cfg.layout       = 'neuromag306mag.lay';
figure 
ft_multiplotTFR(cfg, all_ft);


cfg = [];
% cfg.baseline     = [-0.5 -0.1]; 
cfg.baselinetype = 'absolute'; 
% cfg.zlim         = [-3e-27 3e-27];	        
cfg.showlabels   = 'yes';	
cfg.layout       = 'neuromag306mag.lay';
figure 
ft_multiplotTFR(cfg, TFR);



cfg = [];
cfg.baseline     = [-0.5 -0.1];
cfg.baselinetype = 'absolute';  
cfg.maskstyle    = 'saturation';	
% cfg.zlim         = [-3e-30 3e-30];	
cfg.channel      = 'MEG2111';
figure(1)
ft_singleplotTFR(cfg, all_ft);
figure(5)

