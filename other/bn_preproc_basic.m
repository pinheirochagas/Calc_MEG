%% ns_preproc %%
% Neuromag preprocessing of raw MEG recordings (.fif). Uses MaxFilter, Fieldtrip. 
% Parameters 'par' are specific for each subject and experiment.
%
% Author: Marco Buiatti, INSERM Cognitive Neuroimaging Unit, Neurospin (France), 2013.

%% set path %%
addpath '/neurospin/local/mne/share'                                                        % MNE (needed to read and import fif data in fieldtrip) 
addpath '/neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline_tmp/'                                             % Neurospin pipeline scripts
addpath '/neurospin/meg/meg_tmp/BilatNum_Marco_2010/analysis/brainstorm/bst_scripts/neuromag_preproc/'    % local processing scripts

%% STEP 1: subject information, trigger definition and trial function %%
% Number of subject to analyze
n   = 5; 
par = bn_par_basic(n);

% =========================================================================
%% STEP 2: head movement correction, maxfilter %%
% =========================================================================
%
% Applies Neuromag software Maxfilter and Maxmove to the data.
%
% Based on the rotation/translation plot, choose a run as the ref for head position %
par=ns_neuromagpreproc(par);
