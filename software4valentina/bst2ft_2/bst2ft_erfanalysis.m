%% bst2ft_erfanalysis %%
%
% - Data export from Brainstorm to Fieldtrip.
% - Visualization of ERFs from data preprocessed with ns_preproc.
% - Within-subjects statistical analysis.
% - Grand-average and across-subjects statistical analysis.
% Uses Fieldtrip. 
% Parameters 'par' are specific for each subject and experiment.
%
% Marco Buiatti, INSERM U992 Cognitive Neuroimaging Unit (France), 2013.

%% set path %%
% addpath '/neurospin/local/mne/share/matlab/'                                             % MNE (needed to read and import fif data in fieldtrip 
% addpath 'C:\Users\marco.buiatti\Documents\software\fieldtrip_testedversion\fieldtrip\'       % fieldtrip version tested with this pipeline
addpath 'C:\Users\marco.buiatti\Documents\software\pipeline_tmp\'                                 % Neurospin pipeline scripts
addpath 'C:\Users\marco.buiatti\Documents\software\brainstorm\bst_scripts\bst2ft\'  % local processing scripts
addpath 'C:\Users\marco.buiatti\Documents\software\fieldtrip-20150618\'       % fieldtrip version tested with this pipeline (06/2015)
ft_defaults                                           % sets fieldtrip defaults and configures the minimal required path settings 

%subj='s10';
subj='s02';

% Import Brainstorm data to Fieldtrip format
data=bst2ft_all(subj);

% save Fieldtrip dataset
save(['/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/bst2ft/' subj],'data');

% merge conditions together
dev1=ns_appendftdata(data{3},data{5});      % number deviant +-1
dev2=ns_appendftdata(data{2},data{6});      % number deviant +-2
dev3=ns_appendftdata(data{1},data{7});      % number deviant +-3
devcol=ns_appendftdata(data{8},data{9});    % color deviant

%% =========================================================================
%% ERF PLOTS
%% =========================================================================
%% Load relevant averages %%

%% Plot ERF time courses for each sensor arranged according to their location specified in the layout.%%
% 'all' for all sensors, 'mag' for magnetometers, 'grad' for gradiometers, 'grad1'('grad2') for gradiometers 1(2).
% 1st dataset is plotted in blue, 2nd in red, 3rd in green
ns_erf('mag',data{4},data{7});
ns_erf('grad',data{4},data{7});

%% Plot topographies for each sensor type at specified latencies - to improve by taking avg instead of trial field
tlim=0.05:0.05:0.25;                   % tlim = [tmin:tstep:tmax] in seconds
% zmax=3*10^(-12);                     % amplitude limits. If not specified, max(abs(av1,av2)) is used. 
tshw=0.025; 
ns_multitopoplotER(data{4},tlim,tshw,[]);  % first column: mag, second column: grad1, third column: grad2
ns_multitopoplotER(data{7},tlim,tshw,[]);  % first column: mag, second column: grad1, third column: grad2
%% each row shows topography of first dataset, second dataset and 1st minus 2nd at each time interval;
% first figure: mag, second figure: grad1, third figure: grad2
ns_multitopoplotERdiff(data{4},data{7},tlim,tshw,[]); 

%% =========================================================================
%% ERF STATISTICAL ANALYSIS
%% =========================================================================

%% Two conditions, between-trials analysis (see http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock)

% temporal latency over which statistical analysis is computed (in seconds)
lat = [0 0.5];

% compute statistical analysis separately for each type of sensor
%
% color deviant effect:
statdevcoldev0=ns_btstat(devcol,data{4},lat);

% color category effect:
statdevcolwa=ns_btstat(data{9},data{8},lat);

% number deviant effect:
statregrnum=ns_statindepregr_all(data{4},dev1,dev2,dev3,lat);

% display basic information on significant clusters for each sensor type
probthr=0.15;
ns_statinfo_all(statdevcoldev0,probthr);
ns_statinfo_all(statdevcolwa,probthr);
ns_statinfo_all(statregrnum,probthr);

% save stats in Fieldtrip dataset
save(['/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/bst2ft/' subj],'stat*','-append');

% explore the clusters

% clusters from comparison of two conditions:
bn_plotsinglecluster(statdevcoldev0,devcol,data{4},3,-1,0.01);

% clusters from regression:
bn_plotsinglecluster_depregr(statregrnum,data{4},dev1,dev2,dev3,1,1,0.01);

%% GROUP ERF STATISTICAL ANALYSIS %%
% Grand-averaged data generated with gavg.m 
load('D:\projects\BilatNum_Marco_2010\data\bst2ft\gave.mat');

%% Two conditions, within-subjects analysis (see http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock)

% temporal latency over which statistical analysis is computed (in seconds)
lat = [0 0.5];

% compute statistical analysis separately for each type of sensor
%
% color deviant effect:
statdevcoldev0=ns_wsstat(gav_devcol,gav{4},lat);

% color category effect:
statdevcolwa=ns_wsstat(gav{9},gav{8},lat);

% number deviant effect:
statregrnum=ns_statdepregr_all(gav{4},gav_dev1,gav_dev2,gav_dev3,lat);

% display basic information on significant clusters for each sensor type
probthr=0.15;
ns_statinfo_all(statdevcoldev0,probthr);
ns_statinfo_all(statdevcolwa,probthr);
ns_statinfo_all(statregrnum,probthr);

% save stats in Fieldtrip dataset
% save(['/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/bst2ft/' subj],'stat*','-append');

% explore the clusters

% clusters from comparison of two conditions:
bn_plotsinglecluster(statdevcoldev0,gav_devcol,gav{4},1,-2,0.01);

% clusters from regression:
bn_plotsinglecluster_depregr(statregrnum,gav{4},gav_dev1,gav_dev2,gav_dev3,1,-1,0.01);


%% OLD part of the script %%

% explore the clusters:
% plot t-statistics topography from the first to the last time bin of
% every cluster having p<cfg.alpha, cluster is highlighted
cfg=[]; 
cfg.alpha=0.05;
cfg.layout = 'neuromag306mag.lay';
cfg.parameter = 'stat';
ft_clusterplot(cfg, stat{1});

% explore the dynamics of the ERFs including clusters where they exist:
% Plots a series of topoplots with found clusters highlighted. Topography may be time-smoothed (see help ns_plotstat).
tshw=0.025; % time-smoothing half-width, in seconds, determines the half
% temporal window over which topographies are averaged around the latencies
% determined by timepoints below (choose 0 for no smoothing)
timepoints=[0.05:0.05:0.25]; % time points at which topographies are plotted 
% NOTE 1: timepoints +- tshw must be WITHIN lat)
% NOTE 2: for every temporal window, highlighted clusters include ALL
% channels belonging to the cluster at any time bin in the time interval.
% These might look different from the average topoplot over the same
% window.
ns_plotstat(stat,av1,av2,timepoints,tshw);
% plotting the same for a specific channel type:
cfg             = [];
cfg.layout      = 'neuromag306mag.lay';
cfg.parameter   = 'avg';
cfg.lat         = timepoints;
cfg.alpha       = 0.05; % threshold of cluster visualization
cfg.tshw        = tshw;
ns_clusterplot(cfg,stat,data{8},data{9},'mag')


% plot cluster statistics time course, topography at peak of cluster statistics and ERFs of single clusters
% computed with FT CRA. In this example: plotting grad1, first
% negative cluster, topography time smoothing of 0.01 s (see help bn_plotsinglecluster).  
bn_plotsinglecluster(stat,data{8},data{9},2,-1,0.01);

%% Stats on regression over 4 conditions, between-trials analysis (see http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock)

% temporal latency over which statistical analysis is computed (in seconds)
lat = [0 0.5];

stat=ns_statindepregr_all(data{4},dev1,dev2,dev3,lat);

% plot
bn_plotsinglecluster_depregr(stat_regr,data{4},dev1,dev2,dev3,2,1,0.01);


%% Two conditions, within-subjects analysis (see http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock)
%% To update!
%% Example with two conditions %%
condition={'ALVC','ARVC'};

% temporal latency over which statistical analysis is computed (in seconds)
lat = [0 0.4];

% compute grand-average over subjects 1 and 14 on selected condition
[gav1,gtr1] = ns_gave(par,[1 14],'ALVC');
[gav2,gtr2] = ns_gave(par,[1 14],'ARVC');

% compute within-subjects statistical analysis separately for each type of sensor
gstat=ns_wsstat(gtr1,gtr2,gav1,gav2,[0 0.3],[0:0.05:0.3]);

% Plotting: all functions described above for between-trials analysis work
% exactly the same with grand-averaged data.