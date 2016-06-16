%% ns_erfanalysis %%
% Visualization of ERFs from data preprocessed with ns_preproc.
% Between-subjects statistical analysis.
% Grand-average and within-subjects statistical analysis.
% Uses Fieldtrip. 
% Parameters 'par' are specific for each subject and experiment.
%
% Marco Buiatti, INSERM U992 Cognitive Neuroimaging Unit (France), 2011.

%% set path %%
addpath '/neurospin/local/mne/i686/share/matlab/'     % MNE (needed to read and import fif data in fieldtrip 
addpath '/neurospin/meg/meg_tmp/tools_tmp/pipeline_tmp/'  % Neurospin pipeline scripts
addpath '/neurospin/meg/meg_tmp/PipelineTest/scripts/'    % local processing scripts
addpath '/neurospin/meg/meg_tmp/tools_tmp/fieldtrip_testedversion/fieldtrip/'  % fieldtrip version tested with this pipeline
ft_defaults                                           % sets fieldtrip defaults and configures the minimal required path settings 

%% subject information, trigger definition and trial function %%
% Subject number to analyze
n   = 13; 
par = ns_par(n);

%% =========================================================================
%% ERF PLOTS
%% =========================================================================
%% Load relevant averages %%
%% Example with two conditions %%
condition={'ALVC','ARVC'};
for c=1:length(condition)
    load([par.avdir par.subj condition{c} 'av'],'av');
    eval(['av' num2str(c) '=av;']);
    clear av;
end;

%% Plot ERF time courses for each sensor arranged according to their location specified in the layout.%%
% 'all' for all sensors, 'mag' for magnetometers, 'grad' for gradiometers, 'grad1'('grad2') for gradiometers 1(2).
% 1st dataset is plotted in blue, 2nd in red, 3rd in green
ns_erf('mag',av1,av2);
ns_erf('grad',av1,av2);

%% Plot topographies for each sensor type at specified latencies
tlim=0:0.05:0.3;                       % tlim = [tmin:tstep:tmax] in seconds
% zmax=3*10^(-12); 
tshw=0.025; 
ns_multitopoplotER(av1,tlim,tshw,[]);  % first column: mag, second column: grad1, third column: grad2
ns_multitopoplotER(av2,tlim,tshw,[]);  % first column: mag, second column: grad1, third column: grad2
%% each row shows topography of first dataset, second dataset and 1st minus 2nd at each time interval;
% first column: mag, second column: grad1, third column: grad2
ns_multitopoplotERdiff(av1,av2,tlim,tshw,[]); 

%% =========================================================================
%% ERF STATISTICAL ANALYSIS
%% =========================================================================

%% Two conditions, between-trials analysis (see http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock)
%% Example with two conditions %%
condition={'ALVC','ARVC'};

% temporal latency over which statistical analysis is computed (in seconds)
lat = [0 0.4];

% load data with and without trials for between-trials statistical analysis
for c=1:length(condition)
    load([par.avdir par.subj condition{c} 'av'],'av');
    load([par.avdir par.subj condition{c} 'tr'],'tr');
    eval(['av' num2str(c) '=av;']);
    eval(['tr' num2str(c) '=tr;']);
    clear av;
    clear tr;
end;

% compute statistical analysis separately for each type of sensor
stat=ns_btstat(tr1,tr2,lat);

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
timepoints=[0.05:0.05:0.35]; % time points at which topographies are plotted 
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
ns_clusterplot(cfg,stat,av1,av2,'mag')


% plot cluster statistics time course, topography at peak of cluster statistics and ERFs of single clusters
% computed with FT CRA. In this example: plotting magnetometers, second
% negative cluster, topography time smoothing of 0.01 s (see help ns_plotsinglecluster).  
ns_plotsinglecluster(stat,av1,av2,1,-2,0.01); 


%% save data %%
statlabel=[condition{1} 'vs' condition{2}];
statname=[par.avdir par.subj 'stat' statlabel];
disp(['Saving stats in ' statname ' ...']);
save(statname,'stat','-v7.3');
disp('Done.');

%% Two conditions, within-subjects analysis (see http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock)
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