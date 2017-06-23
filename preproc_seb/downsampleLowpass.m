function downsampleLowpass(data)
%%
cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = 25;
data = ft_preprocessing(cfg, data);
data.trialinfo = trialinfo;
data.triggers = triggers;
data.ECGEOG = ECGEOG;

%% Downsampling
calc_downsample(data)

% Save data
data.par = par;
save([par.pathmat par.Sub_Num,'_calc_lp25_100hz.mat'], 'data')   % Save the structure in MAT file
end

