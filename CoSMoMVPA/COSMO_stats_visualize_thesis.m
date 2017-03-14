%%
load('E:\Semdim_Valentina_2014/data/results_TFA/COSMO/Results/FT_Average_sound_lda_ch10_tbin1_frbin1.mat')
load('E:\Semdim_Valentina_2014/data/results_TFA/COSMO/Stats/TFCE_FT_sound_lda_ch10_tbin1_frbin1.mat')

% load data
Average = tmp2;
Stat = all_ft;
clear tmp2 all_ft

% average frequencies of interest
cfg = [];
cfg.frequency = [4 12];
cfg.avgoverfreq = 'yes';
tmpA = ft_selectdata(cfg,Average);
tmpA.avg = squeeze(tmpA.powspctrm);
tmpA.dimord = 'chan_time';
tmpA = rmfield(tmpA,{'powspctrm','freq'});
%plot
figure(1);
cfg = [];
cfg.xlim=[0.1:0.08:0.6];
cfg.zlim = [0.48 0.53];
cfg.layout       = 'neuromag306cmb.lay';
cfg.comment = 'xlim';
cfg.style = 'straight';
cfg.commentpos = 'title';
ft_topoplotER(cfg, tmpA);
colormap(redblue)

%%

load('E:\Semdim_Valentina_2014/data/results_TFA/COSMO/Results/FT_Average_video_lda_ch10_tbin1_frbin1.mat')
load('E:\Semdim_Valentina_2014/data/results_TFA/COSMO/Stats/TFCE_FT_video_lda_ch10_tbin1_frbin1.mat')

% load data
Average = all_ft;
Stat = all_ft;
clear tmp2 all_ft

% average frequencies of interest
cfg = [];
cfg.frequency = [4 12];
cfg.avgoverfreq = 'yes';
tmpA = ft_selectdata(cfg,Average);
tmpA.avg = squeeze(tmpA.powspctrm);
tmpA.dimord = 'chan_time';
tmpA = rmfield(tmpA,{'powspctrm','freq'});
%plot
figure(2);
cfg = [];
cfg.xlim=[0.7:0.08:0.6];
cfg.zlim = [0.48 0.53];
cfg.layout       = 'neuromag306cmb.lay';
cfg.comment = 'xlim';
cfg.style = 'straight';
cfg.commentpos = 'title';
ft_topoplotER(cfg, tmpA);
colormap(redblue)

%%

load('E:\Semdim_Valentina_2014/data/results_TFA/COSMO/Results/FT_Average_cat_lda_ch10_tbin1_frbin1.mat')
load('E:\Semdim_Valentina_2014/data/results_TFA/COSMO/Stats/TFCE_FT_cat_lda_ch10_tbin1_frbin1.mat')

% load data
Average = tmp2;
Stat = all_ft;
clear tmp2 all_ft

% average frequencies of interest
cfg = [];
cfg.frequency = [4 12];
cfg.avgoverfreq = 'yes';
tmpA = ft_selectdata(cfg,Average);
tmpA.avg = squeeze(tmpA.powspctrm);
tmpA.dimord = 'chan_time';
tmpA = rmfield(tmpA,{'powspctrm','freq'});
%plot
figure(3);
cfg = [];
 cfg.xlim=[0.5:0.25:2.5];
%cfg.zlim = [0.48 0.53];
cfg.layout       = 'neuromag306cmb.lay';
cfg.comment = 'xlim';
cfg.style = 'straight';
cfg.commentpos = 'title';
ft_topoplotER(cfg, tmpA);
colormap(redblue)
