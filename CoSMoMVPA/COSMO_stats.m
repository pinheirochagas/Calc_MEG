%% Searchlight STATS

%% set up

% need cosmo
cd /neurospin/unicog/protocols/IRMf/SPANUM_de-Hevia_2013/tmp/CoSMoMVPA-master/mvpa
cosmo_set_path
% set configuration
config=cosmo_config();
% need fieldtrip
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/fieldtrip_latest' 
ft_defaults  
cd /neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/results_TFA/COSMO/Results
clc;

%%  compute random-effect cluster statistics corrected for multiple comparisons

% http://cosmomvpa.org/matlab/cosmo_montecarlo_cluster_stat.html
% http://cosmomvpa.org/matlab/cosmo_cluster_neighborhood.html

data_path     = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/results_TFA/COSMO';
subnips       = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'};
contrast      = 'cat';   % 'cat', 'sound', 'video'
spacesphere   = 10; % 10 sensors in each sphere
timesphere    = 1;  % should be 1*2+1=3 time-bin, each is 40 ms
freqsphere    = 1;  % should be 1*2+1=3 frequency-bin, each is 1 Hz

% load data all subjects  [not sure how to do this]
all = [];
for sub=1:length(subnips);
 tmp = load(['cat_' subnips{sub} '_lda_ch10_tbin1_frbin1.mat']);
 all = [all,tmp];
end

% put subjects together in one dataset
sl_tf_ds = all.sl_tf_ds;
ds_stacked=cosmo_stack({all.sl_tf_ds});
n_subjects=size(ds_stacked.samples,1);
ds_stacked.sa.targets=ones(n_subjects,1);
ds_stacked.sa.chunks=(1:n_subjects)';

% neighborhood [can decide to correct along specif dimensions, default = all]
nbrhood = cosmo_cluster_neighborhood(ds_stacked);
%fprintf('Cluster neighborhood:\n');
%cosmo_disp(nbrhood);

% options
opt=struct();
opt.cluster_stat='tfce';    % Threshold-Free Cluster Enhancement
opt.niter=1000;             % 1000 for inference (`3h), 10000 for publication
opt.h0_mean=0.5;            % 0 for correlation, for decoding =1/C, with C the number of classes
%fprintf('Running multiple-comparison correction with these options:\n');
%cosmo_disp(opt);

% compute correct zscores
ds_z=cosmo_montecarlo_cluster_stat(ds_stacked,nbrhood,opt);
%fprintf('TFCE z-score dataset\n');
%cosmo_disp(ds_z);
save([data_path '/Stats/TFCE_' contrast '_lda_ch' num2str(spacesphere)...
    '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere) '.mat'], 'ds_z');

%% results

%   ds_z                
% Dataset struct with (two-tailed) z-scores for each feature corrected for multiple comparisons.
% For example, at alpha=0.05, these can be interpreted as:
%   - For a one-tailed test:
%       z < -1.6449   statistic is below expected mean
%      |z|<  1.6449   statistic is not significant
%       z >  1.6449   statistic is above expected mean
%   - For a two-tailed test:
%       z < -1.9600  statistic is below expected mean
%      |z|<  1.9600  statistic is not significant
%       z >  1.9600  statistic is above expected mean
% where |z| denotes the absolute value of z.
% Use normcdf to convert the z-scores to p-values.   ?  p = normcdf(ds_z);
% map back to fieldtrip
all_ft=cosmo_map2meeg(ds_z);    
save([data_path '/Stats/TFCE_FT_' contrast '_lda_ch' num2str(spacesphere)...
    '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere) '.mat'], 'all_ft');

% plot all 
figure()
cfg             = [];
cfg.baseline = 'no';
cfg.layout      = 'neuromag306cmb.lay';
cfg.interactive = 'yes';
cfg.showlabels = 'no';
cfg.shadin = 'interp';
cfg.style = 'straight';
cfg.marker = 'off';
cfg.comment = 'xlim';
cfg.commentpos = 'title';
cfg.colorbar = 'yes';
%cfg.zlim = [1.9 max(max(max(all_ft.powspctrm)))];
ft_multiplotTFR(cfg, all_ft);
set(gcf,'color','w');

%% advance plot: mask accuracy by significance 

Average = tmp2;
Stat = all_ft;

tmp = Average;
indexsign = Stat.powspctrm(:,:,:)<1.9;
tmp.powspctrm(indexsign)=0;

% plot average 
figure()
cfg             = [];
cfg.baseline = 'no';
cfg.layout      = 'neuromag306com.lay';
cfg.interactive = 'yes';
cfg.showlabels = 'no';
cfg.shadin = 'interp';
cfg.style = 'straight';
cfg.marker = 'off';
cfg.comment = 'xlim';
cfg.commentpos = 'title';
cfg.colorbar = 'yes';
cfg.zlim = [0.48 max(max(max(Average.powspctrm)))];
ft_multiplotTFR(cfg, Average);

% plot sign 
figure()
cfg             = [];
cfg.baseline = 'no';
cfg.layout      = 'neuromag306planar.lay';
cfg.interactive = 'yes';
cfg.showlabels = 'no';
cfg.shadin = 'interp';
cfg.style = 'straight';
cfg.marker = 'off';
cfg.comment = 'xlim';
cfg.commentpos = 'title';
cfg.colorbar = 'yes';
cfg.zlim = [1.8 max(max(max(Stat.powspctrm)))];
ft_multiplotTFR(cfg, Stat);

% plot average masked by sig
figure()
cfg             = [];
cfg.baseline = 'no';
cfg.layout      = 'neuromag306planar.lay';
cfg.interactive = 'yes';
cfg.showlabels = 'no';
cfg.shadin = 'interp';
cfg.style = 'straight';
cfg.marker = 'off';
cfg.comment = 'xlim';
cfg.commentpos = 'title';
cfg.colorbar = 'yes';
cfg.zlim = [0.48 max(max(max(tmp.powspctrm)))];
ft_multiplotTFR(cfg, tmp);