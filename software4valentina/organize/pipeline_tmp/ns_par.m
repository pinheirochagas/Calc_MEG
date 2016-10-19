function par = ns_par(n)
% function par = ns_par(n) where n is the subject number
% Specifies subject information, trigger definition and trial function. 
% 
% Parameters here refer to the experiment 'PipelineTest' as an example. 

%% set path %%
addpath '/neurospin/local/mne/i686/share/matlab/'     % MNE (needed to read and import fif data in fieldtrip) 
addpath '/neurospin/meg/meg_tmp/tools_tmp/pipeline_tmp/'  % Neurospin pipeline scripts
addpath '/neurospin/meg/meg_tmp/PipelineTest/scripts/'    % local processing scripts
addpath '/neurospin/meg/meg_tmp/tools_tmp/fieldtrip_testedversion/fieldtrip/' % most recent fieldtrip version tested with this pipeline
ft_defaults                                           % sets fieldtrip defaults and configures the minimal required path settings 

%% EXPERIMENT-SPECIFIC INFORMATION %%   
%% path to relevant directories (to be generated in advance) %%
par.rawdir      = '/neurospin/meg/meg_tmp/PipelineTest/data/raw/';                  % Raw data path
par.hpdir       = '/neurospin/meg/meg_tmp/PipelineTest/hp/';                        % Head position text file directory
par.sssdir      = '/neurospin/meg/meg_tmp/PipelineTest/data/sss/';                  % SSS Data directory
par.mfdir       = '/neurospin/meg/meg_tmp/PipelineTest/data/sss/mf_scripts/';       % Maxfilter scripts directory
par.ftdir       = '/neurospin/meg/meg_tmp/PipelineTest/data/ft/';                   % fieldtrip data directory
par.avdir       = '/neurospin/meg/meg_tmp/PipelineTest/data/ft/ave/'; % fieldtrip average data
par.statdir     = '/neurospin/meg/meg_tmp/PipelineTest/data/ft/stats/'; % fieldtrip cluster stats

%% General parameters %%
% load sensor labels
% par.chlabels=load('/neurospin/meg/meg_tmp/tools_tmp/pipeline/SensorClassification.mat'); 

% Epoch definition: Prestimulus and poststimulus time extremes in seconds
% relative to stimulus onset time (= 0).
% Example: epoch beginning 0.2 s BEFORE onset, ending 0.7 s AFTER onset:
% par.prestim         = -0.2;             
% par.poststim        = 0.7;
par.prestim         = -0.4;             
par.poststim        = 0.4;

% Baseline definition: time extremes from 0 in seconds (same convention as
% epoch definition above)
par.begt            = -0.4;             
par.endt            = -0.24;            

% low-pass frequency (set to [] to skip filtering)
par.lpf             = 40;              

% stimulus delay in seconds.
% (to compute it, see http://www.unicog.org/pm/pmwiki.php/MEG/Stimulus-triggerDelay)
% will be used in ns_trialfun, called by ft_definetrial.
par.delay           = 0.34;            

%% Trigger definition %%
% Define the triggers (value and label) that identify your epochs of interest by writing your own ns_trig function.
par.eventvalue      = ns_trig;
% Indicate the function that identifies the triggers in your data.
% In ns_trialfun, trigger times and values are computed from the difference between
% consecutive stimulus channel values 
% You can write your own trial definition function if you want.
par.trialfun        = 'ns_trialfun';        

%% SUBJECT-SPECIFIC INFORMATION %%
switch n
    case 1
        par.subj        = 's01';                                % Subject name
        par.runlabel    = {'run1_raw','run2_raw','run3_raw'};   % label of each run
        par.badch{1}    = '0543';                               % bad channels for each run
        par.badch{2}    = '0543';
        par.badch{3}    = '0543';
    % ...here you can add as many subjects as you want %  
    case 13
        par.subj        = 's13';                                % Subject name
        par.runlabel    = {'run1_raw','run2_raw','run3_raw'};   % label of each run
        par.badch{1}    = '0543';                               % bad channels for each run
        par.badch{2}    = '0543';
        par.badch{3}    = '0543 0112'; 
    case 14
        par.subj        = 's14';                                % Subject name
        par.runlabel    = {'run1_raw','run2_raw','run3_raw'};   % label of each run
        par.badch{1}    = '0543 2313';                          % bad channels for each run
        par.badch{2}    = '0543 0422';
        par.badch{3}    = '0543';        
    otherwise
        disp('Error: Incorrect subject number');
end

par.run         = 1:length(par.runlabel);                                  % Number of runs
par.chansel     = 'MEG'; % MEG,eeg,mag,grad or allchan

%% path to ECG/EOG PCA projection (to be computed after maxfilter)
par.pcapath     = [par.sssdir par.subj 'pca/'];
par.samplefile  = [par.sssdir par.subj par.runlabel{1} '_sss.fif'];