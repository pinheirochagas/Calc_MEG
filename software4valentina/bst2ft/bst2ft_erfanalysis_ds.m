%% ========================== bst2ft_erfanalysis ========================== %%
%
% - Data export from Brainstorm to Fieldtrip.
% - Visualization of ERFs from data preprocessed with ns_preproc.
% - Within-subjects statistical analysis.
% - Grand-average and across-subjects statistical analysis.
% Uses Fieldtrip 
% Parameters 'par' are specific for each subject and experiment.
%
% Marco Buiatti, INSERM U992 Cognitive Neuroimaging Unit (France), 2013.
%
% adapt for SEMDIM by Valentina Borghesani 20/05/2015

%% set path %%

% addpath '/neurospin/local/mne/share/matlab/'                                                          % MNE (needed to read and import fif data in fieldtrip 
addpath 'C:\Users\valentina.borghesani\Desktop\software4valentina\pipeline_tmp\'                        %  pipeline scripts
addpath 'C:\Users\valentina.borghesani\Desktop\software4valentina\bst2ft\'                              % local processing scripts
addpath 'C:\Users\valentina.borghesani\Desktop\software4valentina\fieldtrip_testedversion\fieldtrip\'   % fieldtrip version tested with this pipeline                                                                                   
% sets fieldtrip defaults and configures the minimal required path settings 
ft_defaults  

%% ========================== IMPORT ========================== %%
 
%subs = {'S01','S03','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'}
subs = {'S10'}
for i = 1
    % Subject name/directory
    subj=subs{i}
    mkdir(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj])
    % Import Brainstorm data to Fieldtrip format
    data=bst2ft_all_ds(subj);
    % save Fieldtrip dataset(s) - separated to save memory
    data_animals=data{1};
    data_tools=data{2};
    data_big=data{3};
    data_small=data{4};
    data_audio=data{5};
    data_noaudio=data{6}; 
    data_click1=data{7};
    data_click2=data{8};
    clear data
    save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\data'],'data_*');
    % % in case you need to merge conditions together
    % dev1=ns_appendftdata(data{3},data{5});      % number deviant +-1
    clearvars -except i subs
end
 
clearvars
clc

subs = {'S04'}
for i = 1
    % Subject name/directory
    subj=subs{i}
    mkdir(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj])
    % Import Brainstorm data to Fieldtrip format
    data=bst2ft_all_4(subj);
    % save Fieldtrip dataset(s) - separated to save memory
    data_animals=data{1};
    data_tools=data{2};
    data_big=data{3};
    data_small=data{4};
    data_audio=data{5};
    data_noaudio=data{6}; 
    clear data
    save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\data'],'data_*');
    % % in case you need to merge conditions together
    % dev1=ns_appendftdata(data{3},data{5});      % number deviant +-1
    clearvars -except i subs
end


clearvars
clc

%% ========================== Grand Average ========================== %%

% all subjects that are ready for CLIKS
subj=[1:3 5:8 13:19];

% Click1
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S0' num2str(subj(s)) '\data'],'data_click1')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S' num2str(subj(s)) '\data'],'data_click1')
    end;
    dataavg=data_click1;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_click1  
end;
gav_click1=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_click1.avg=squeeze(mean(gav_click1.individual,1));

% Click2
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S0' num2str(subj(s)) '\data'],'data_click2')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S' num2str(subj(s)) '\data'],'data_click2')
    end;
    dataavg=data_click2;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_click2 
end;
gav_click2=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_click2.avg=squeeze(mean(gav_click2.individual,1));

% save grand average clicks
cd C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\
save gave_click gav*;

clear all
clc


% all subjects that are ready
subj=[1:8 13:19];

% Audio
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S0' num2str(subj(s)) '\data'],'data_audio')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S' num2str(subj(s)) '\data'],'data_audio')
    end;
    dataavg=data_audio;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_audio  
end;
gav_audio=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_audio.avg=squeeze(mean(gav_audio.individual,1));

% No Audio
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S0' num2str(subj(s)) '\data'],'data_noaudio')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S' num2str(subj(s)) '\data'],'data_noaudio')
    end;
    dataavg=data_noaudio;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_noaudio  
end;
gav_noaudio=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_noaudio.avg=squeeze(mean(gav_noaudio.individual,1));

% Big
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S0' num2str(subj(s)) '\data'],'data_big')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S' num2str(subj(s)) '\data'],'data_big')
    end;
    dataavg=data_big;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_big  
end;
gav_big=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_big.avg=squeeze(mean(gav_big.individual,1));

% Small
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S0' num2str(subj(s)) '\data'],'data_small')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S' num2str(subj(s)) '\data'],'data_small')
    end;
    dataavg=data_small;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_small  
end;
gav_small=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_small.avg=squeeze(mean(gav_small.individual,1));

% Animals
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S0' num2str(subj(s)) '\data'],'data_animals')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S' num2str(subj(s)) '\data'],'data_animals')
    end;
    dataavg=data_animals;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_animals  
end;
gav_animals=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_animals.avg=squeeze(mean(gav_animals.individual,1));

% Tools
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S0' num2str(subj(s)) '\data'],'data_tools')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\S' num2str(subj(s)) '\data'],'data_tools')
    end;
    dataavg=data_tools;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_tools  
end;
gav_tools=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_tools.avg=squeeze(mean(gav_tools.individual,1));

% save grand average 
cd C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\
save gave gav*;

clear all
clc

%% ========================== SINGLE SUBJECTS ========================== %%
 
% ========================== ERF STATISTICAL ANALYSIS
% Two conditions, between-trials analysis (see http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock)

subs = {'S01','S02','S03','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'}
for i = 1:15
    subj=subs{i}
   % Temporal latency over which statistical analysis is computed (in seconds)
    lat = [0 0.5]   
% 1) Compute statistical analysis separately for each type of sensor
    % Animals vs Tools
        clear data*
        load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\data'],'data_animals','data_tools')
        statanimalstools=ns_btstat(data_animals,data_tools,lat);
    % Big vs Small
        clear data*
        load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\data'],'data_big','data_small')
        statbigsmall=ns_btstat(data_big,data_small,lat);
    % Audio vs NoAudio
        clear data*
        load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\data'],'data_audio','data_noaudio')
        stataudionoaudio=ns_btstat(data_audio,data_noaudio,lat);
    % Click1 vs Click2
        clear data*
        load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\data'],'data_click1','data_click2')
        statrightleft=ns_btstat(data_click1,data_click2,lat);
% 2) Save stats in Fieldtrip dataset
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\stats'],'stat*');
    clearvars -except i subs
end

clearvars
clc

subs = {'S04'}
for i = 1:1
    subj=subs{i}
   % Temporal latency over which statistical analysis is computed (in seconds)
    lat = [0 0.5]   
% 1) Compute statistical analysis separately for each type of sensor
    % Animals vs Tools
        clear data*
        load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\data'],'data_animals','data_tools')
        statanimalstools=ns_btstat(data_animals,data_tools,lat);
    % Big vs Small
        clear data*
        load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\data'],'data_big','data_small')
        statbigsmall=ns_btstat(data_big,data_small,lat);
    % Audio vs NoAudio
        clear data*
        load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\data'],'data_audio','data_noaudio')
        stataudionoaudio=ns_btstat(data_audio,data_noaudio,lat);
% 2) Save stats in Fieldtrip dataset
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\' subj '\stats'],'stat*');
    clearvars -except i subs
end

clearvars
clc

% % display basic information on significant clusters for each sensor type
probthr=0.2;
ns_statinfo_all(statrightleft,probthr);
ns_statinfo_all(stataudionoaudio,probthr);
ns_statinfo_all(statanimalstools,probthr);
ns_statinfo_all(statbigsmall,probthr);

% 3) Explore the clusters
    % clusters from comparison of two conditions:
    % arguments = stasts, condition A, condition B, sensor type, cluster number (- if negative), time bin
    % fig 1 = for each time bin, sum of the t stati
    % fig 2 = topographies of the two conditions and of their difference
    % fig 3 = time curse of the two conditions  
%     bn_plotsinglecluster(statanimalstools,data_animals,data_tools,2,1,0.01);
%     bn_plotsinglecluster(statbigsmall,data_big,data_small,2,-1,0.01);
%     bn_plotsinglecluster(stataudionoaudio,data_audio,data_noaudio,2,1,0.01);
    
    bn_plotsinglecluster(statrightleft,data_click1,data_click2,2,1,0.01);
    bn_plotsinglecluster(statrightleft,data_click1,data_click2,3,-1,0.01);



%% ========================== GROUP ANALYSES: general =========================== %%

% Grand-averaged data generated with gavg.m 
load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\gave.mat');
load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\gave_click.mat');

% ========================== ERF STATISTICAL ANALYSIS
% Two conditions, within-subjects analysis (see http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock)

% Temporal latency over which statistical analysis is computed (in seconds)
lat = [0 0.5];

% 1) Compute statistical analysis separately for each type of sensor

    % click effect:
    statclick=ns_wsstat(gav_click1,gav_click2,lat);
    % audio effect:
    stataudio=ns_wsstat(gav_audio,gav_noaudio,lat);
    % size effect:
    statsize=ns_wsstat(gav_big,gav_small,lat);
    % category effect:
    statcategory=ns_wsstat(gav_animals,gav_tools,lat);

% save stats in Fieldtrip dataset
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds/group_stats.mat'],'stat*');

% display basic information on significant clusters for each sensor type
probthr=0.2;
ns_statinfo_all(statclick,probthr);
ns_statinfo_all(stataudio,probthr);
ns_statinfo_all(statsize,probthr);
ns_statinfo_all(statcategory,probthr);

% explore the clusters
bn_plotsinglecluster(statclick,gav_click1,gav_click2,1,1,0.01);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,1,-1,0);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,2,1,0.01);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,2,-1,0.01);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,3,1,0.01);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,3,-1,0.01);

bn_plotsinglecluster(stataudio,gav_audio,gav_noaudio,3,1,0.01);

bn_plotsinglecluster(statsize,gav_big,gav_small,2,1,0.01);  
bn_plotsinglecluster(statsize,gav_big,gav_small,2,2,0.01);  
bn_plotsinglecluster(statsize,gav_big,gav_small,3,1,0.01); 

bn_plotsinglecluster(statcategory,gav_animals,gav_tools,1,-1,0.01);




%% ========================== GROUP ANALYSES: times =========================== %%

% Temporal latency: 50 - 150
load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\gave.mat');
lat = [0.05 0.15];
stataudio=ns_wsstat(gav_audio,gav_noaudio,lat);
statsize=ns_wsstat(gav_big,gav_small,lat);
statcategory=ns_wsstat(gav_animals,gav_tools,lat);
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds/group_stats_tmp1.mat'],'stat*');
clear 

% Temporal latency: 150 - 250
load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\gave.mat');
lat = [0.15 0.25];
stataudio=ns_wsstat(gav_audio,gav_noaudio,lat);
statsize=ns_wsstat(gav_big,gav_small,lat);
statcategory=ns_wsstat(gav_animals,gav_tools,lat);
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds/group_stats_tmp2.mat'],'stat*');
clear 

% Temporal latency: 250 - 350
load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\gave.mat');
lat = [0.25 0.35];
stataudio=ns_wsstat(gav_audio,gav_noaudio,lat);
statsize=ns_wsstat(gav_big,gav_small,lat);
statcategory=ns_wsstat(gav_animals,gav_tools,lat);
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds/group_stats_tmp3.mat'],'stat*');
clear 

% Temporal latency: 350 - 450
load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\gave.mat');
lat = [0.35 0.45];
stataudio=ns_wsstat(gav_audio,gav_noaudio,lat);
statsize=ns_wsstat(gav_big,gav_small,lat);
statcategory=ns_wsstat(gav_animals,gav_tools,lat);
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds/group_stats_tmp4.mat'],'stat*');
clear 

% Temporal latency: 450 - 550
load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds\gave.mat');
lat = [0.45 0.55];
stataudio=ns_wsstat(gav_audio,gav_noaudio,lat);
statsize=ns_wsstat(gav_big,gav_small,lat);
statcategory=ns_wsstat(gav_animals,gav_tools,lat);
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_ds/group_stats_tmp5.mat'],'stat*');
clear 


% Display basic information on significant clusters for each sensor type
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs_ds/gave.mat');
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs_ds/group_stats_tmp5.mat');
probthr=0.2;
ns_statinfo_all(stataudio,probthr);
ns_statinfo_all(statsize,probthr);
ns_statinfo_all(statcategory,probthr);

% explore the clusters
bn_plotsinglecluster(statclick,gav_click1,gav_click2,1,1,0.01);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,1,-1,0.01);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,2,1,0.01);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,2,-1,0.01);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,3,1,0.01);
bn_plotsinglecluster(statclick,gav_click1,gav_click2,3,-1,0.01);

bn_plotsinglecluster(stataudio,gav_audio,gav_noaudio,3,1,0.01);

bn_plotsinglecluster(statsize,gav_big,gav_small,2,1,0.01);  
bn_plotsinglecluster(statsize,gav_big,gav_small,2,2,0.01);  
bn_plotsinglecluster(statsize,gav_big,gav_small,3,1,0.01); 

bn_plotsinglecluster(statcategory,gav_animals,gav_tools,1,-1,0.01);























%% =========================================================================
% ERF PLOTS
% Load relevant averages %%

% Plot ERF time courses for each sensor arranged according to their location specified in the layout.%%
% 'all' for all sensors, 'mag' for magnetometers, 'grad' for gradiometers, 'grad1'('grad2') for gradiometers 1(2).
% 1st dataset is plotted in blue, 2nd in red, 3rd in green
ns_erf('mag',gav_click1,gav_click2);
ns_erf('grad',gav_click1,gav_click2);

ns_erf('mag',gav_big,gav_small);
ns_erf('grad',gav_big,gav_small);



% Plot topographies for each sensor type at specified latencies - to improve by taking avg instead of trial field
tlim=0.05:0.05:0.25;                   % tlim = [tmin:tstep:tmax] in seconds
% zmax=3*10^(-12);                     % amplitude limits. If not specified, max(abs(av1,av2)) is used. 
tshw=0.025; 
ns_multitopoplotER(data{4},tlim,tshw,[]);  % first column: mag, second column: grad1, third column: grad2
ns_multitopoplotER(data{7},tlim,tshw,[]);  % first column: mag, second column: grad1, third column: grad2

% each row shows topography of first dataset, second dataset and 1st minus 2nd at each time interval;
% first figure: mag, second figure: grad1, third figure: grad2
ns_multitopoplotERdiff(data{4},data{7},tlim,tshw,[]); 







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