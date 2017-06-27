function downsampleLowpass(data, par, lpfreq, resamplefs, task)
%% Directories
InitDirsMEGcalc

%% Low-pass Filter 
trialinfo = data.trialinfo;
triggers = data.triggers;
ECGEOG = data.ECGEOG; 
cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = lpfreq;
data = ft_preprocessing(cfg, data);
data.trialinfo = trialinfo;
data.triggers = triggers;
data.ECGEOG = ECGEOG;

%% Downsampling
%data = calc_downsample(data,resamplefs);

% Save data
%data.par = par;
save([data_dir par.Sub_Num,'_' task '_lp30.mat'], 'data')   % Save the structure in MAT file
end

