%% sc_preproc_er %%
% Neuromag preprocessing of empty room raw MEG recordings (.fif) associated with a recorded subject. Uses MaxFilter. 
% Parameters 'par' are specific for each subject and experiment.
%
% Author: Marco Buiatti, INSERM Cognitive Neuroimaging Unit, Neurospin (France), 2014.

%% set path %%
addpath '/neurospin/local/mne/share'                                                        % MNE (needed to read and import fif data in fieldtrip) 
addpath '/neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline_tmp/'                                             % Neurospin pipeline scripts
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/neuromag_preproc/'    % local processing scripts

%% STEP 1: subject information %%
% Number of the subject to be analyze
n = 22; 
par = sc_par_er(n);
par

% =========================================================================
%% STEP 2: head movement correction, maxfilter %%
% =========================================================================
%
% Applies Neuromag software Maxfilter and Maxmove to the data.
%
% Based on the rotation/translation plot, choose a run as the ref for head position %
ns_maxfilter_er(par);
