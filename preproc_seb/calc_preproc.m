%% Preprocessing pipeline Calc MEG

%% Paths to be added
% addpath(genpath('/neurospin/meg/meg_tmp/WMP_Ojeda_2013/fieldtrip/'))
% Get computer
comp = computer;
% MAC + Hard Drive
if strcmp(comp, 'MACI64') == 1
    root_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/';
% Linux
elseif strcmp(comp, 'GLNXA64') == 1
    root_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/';
else
    error('You can only be using your macbook or a linux workstation at neurospin')
end

addpath([root_dir 'scripts/preproc_seb'])
addpath([root_dir 'data/mat/'])


%% Subject informations
par = [];
par.Sub_Num         = 's13';
par.srate = 1000; % sampling frequency in Hz
par.pathraw         = [root_dir 'data/raw/']; % Raw data 
par.pathmat         = [root_dir 'data/mat/']; % path for matlab files
par.pathsss         = [root_dir 'data/sss/' par.Sub_Num '/']  ; % SSS Data 
par.pathbh          = [root_dir 'data/behavior/results/Calc/',par.Sub_Num, '/']; % Behavioral data 

% Name files for each run
for i = 1:10
%       par.rawfiles(i).name  = [par.Sub_Num,'_P_run',num2str(i),'.fif'];
        par.sssfiles(i).name = ['calc',num2str(i),'_sss.fif'];
        par.bhfiles(i).name = [num2str(i) '_results.csv'];
end

% Define parameters
par.epoch = [.5 4.5]; % Prestimulus time window in seconds [- and +]
par.EventValue = [4 5 6 7]; % Trigger code to be analyzed
% par.maxfilter.origin(1) = 0; % these are default (and good) parameters
% par.maxfilter.origin(2) = 0;
% par.maxfilter.origin(3) = 40;
% par.maxfilter.badlimit  = 4; % limit for bad channels (in sd I think...)
% par.maxfilter.runref = 1; % which run to align on.
% par.maxfilter.ds = 4; % downsampling ratio
par.filtering.lpf = 30; % low pass filter
par.filtering.hpf = []; % high pass filter
par.filtering.bsf = 50;
par.filtering.bsf_width = 1;
par.decomposition.method = 'fastica'; % pca, fastica, runica
par.decomposition.comp_num = 30; % number of componentes to be displayed
par.decomposition.epochblink = 0; % 1 if decompose on data timelocked to the artifact
par.decomposition.type_artifact = {'EOGv' 'EOGh' 'ECG'};

savename = [par.Sub_Num]; % Filename to save

% %% Run Maxfilter
% for i = 1:length(par.rawfiles)
%     input_file  = par.rawfiles(i).name;
%     output_file = par.sssfiles(i).name;
%     wmp_runMaxfilter(par, [par.pathraw input_file], [par.pathsss output_file]);
% end

%% Epoch the data
for i = 1:1:length(par.sssfiles)
    [par, data_cont] = calc_preproc_continuous(par, [par.pathsss par.sssfiles(i).name]); % correct bad EEG chan on continuous data and rereference on the average.    
    [epoch{i}, ECGEOG{i}, alltrigNew{i}] = calc_definetrial(par, [par.pathsss par.sssfiles(i).name], [par.pathbh par.bhfiles(i).name], data_cont); % epoch the data
%     [epoch{i} ECGEOG{i}] = wmp_definetrial_v2(par, [par.pathsss par.sssfiles(i).name]); % epoch the data
end

% Check the number of excluded trials
for i=1:length(epoch)
    trialsexc(i) = 43-length(epoch{i}.trial);   
end
display([par.Sub_Num ': Number of excluded trials per run: ',num2str(trialsexc), ' - total: ' num2str(sum(trialsexc))])


%% Concatenate the runs MEG
data = []; 
cfg=[]; 
data = ft_appenddata(cfg, epoch{:}); % concatenate runs
trialTriggersAll = getTrialTriggers(epoch); % make sure to recover alltrigs from every trial 
% clear epoch

% Concatenate the runs behavior
trialinfo = integrate_behavior_data(alltrigNew);
merged = concatBeh(trialinfo);

% Plugs the behavior data to the MEG data
data.trialinfo = merged;
data.triggers = trialTriggersAll; 

% Save 
clear epoch
save([par.pathmat par.Sub_Num,'_calc_BR.mat'],'-v7.3')   % Save the structure in MAT file

%% reject bad trials
[par, data] = calc_rejecttrials(par, data, 'summary');
% reject trials from ECGEOG
data.ECGEOG = cat(2, ECGEOG{:});
tmp = ones(length(data.ECGEOG), 1);
tmp(par.artifact.rejtrials)=0;
data.ECGEOG = data.ECGEOG(tmp==1);

%% Downsample to 250 Hz
dataECGEOG = data;
dataECGEOG.trial = data.ECGEOG;
dataECGEOG.label = {'EOG061' 'EOG062' 'ECG063'}'; 

data = calc_downsample(data,resamplefs);
dataECGEOG = calc_downsample(dataECGEOG,resamplefs);

data.ECGEOG = dataECGEOG.trial;

save([par.pathmat par.Sub_Num,'_calc_BICA_downsample.mat'], 'data', 'par')   % Save the structure in MAT file
disp(['Saving Subject ' par.Sub_Num ': Done.']);

%% Run ICA
[par.artifact.rejcomp_run data] = wmp_decomposition(par, data); % decompose data and reject component.
save([par.pathmat par.Sub_Num,'_calc_AICA.mat'], 'data', 'par')   % Save the structure in MAT file


%% Low-pass Filter 
trialinfo = data.trialinfo;
triggers = data.triggers;
ECGEOG = data.ECGEOG; 
cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = 40;
data = ft_preprocessing(cfg, data);
data.trialinfo = trialinfo;
data.triggers = triggers;
data.ECGEOG = ECGEOG;

% Save data
data.par = par;
save([par.pathmat par.Sub_Num,'_calc.mat'], 'data')   % Save the structure in MAT file
disp(['Preprocessing Subject ' par.Sub_Num ': Done.']);
