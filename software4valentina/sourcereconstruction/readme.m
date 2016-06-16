% Braionstorm processes for computing regression statistics at the source level, 
% to add in a folder that you should call "process" inside folder ".brainstorm" 
% inside your personal folder (e.g., C:\Users\marco.buiatti\.brainstorm\process)
process_ft_sourcestatistics_depsamplesregrT
process_ft_timelockstatistics_depsamplesregrT

% Source statistics for two conditions, no normalization 
% for data that are already z-scored data)
process_ft_sourcestatistics_nonorm

%% set path
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/sourcereconstruction'
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/fieldtrip_20150914'
ft_defaults  

%% Script ds_z_sm_pd to do:
% from source reconstruction of average for each condition
% Downsample to 250 Hz  SKIP IF NOT NEEDED
% Compute z-score on absolute value
% Spatial Smooth 10 on signed values
% Project to default anatomy

% ==============> OPEN BRAINSTORM !

% click 1
subj=[1 2 3 5 6 7 8 13 14 15 16 17 18 19];
Condition = ['click1_short'];
intra=0;
for s =1:length(subj);    % loop across subjects
    if subj(s)<10;
        SubjectName = ['S0' num2str(subj(s))];
    else
        SubjectName = ['S' num2str(subj(s))];
    end;
   ds_z_sm_pd(SubjectName,Condition,intra);
end; 

% click 2
subj=[1 2 3 5 6 7 8 13 14 15 16 17 18 19];
Condition = ['click2_short'];
intra=0;
for s =1:length(subj);    % loop across subjects
    if subj(s)<10;
        SubjectName = ['S0' num2str(subj(s))];
    else
        SubjectName = ['S' num2str(subj(s))];
    end;
   ds_z_sm_pd(SubjectName,Condition,intra);
end; 


% else
subj=[1 2 3 4 5 6 7 8 13 14 15 16 17 18 19];
% Conds = {'animals','tools','audio','noaudio','big','small'}
Condition = ['small'];
intra=0;
for s =1:length(subj);    % loop across subjects
    if subj(s)<10;
        SubjectName = ['S0' num2str(subj(s))];
    else
        SubjectName = ['S' num2str(subj(s))];
    end;
   ds_z_sm_pd(SubjectName,Condition,intra);
end; 


%% STATS

% paired t-test:
    % put in process 2 all the imamges respecting subjects order
    % select run, then tests
    % select fieldtrip_sourcestatistic (no normalization)
    % choose time window [for clicks 0-100 ms]
    % choose paired t-test
    % chooose number of permutations [100/1000]
    % choose min number of neighbours [2/3]
