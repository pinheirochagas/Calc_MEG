%% sc_preproc %%
% Neuromag preprocessing of raw MEG recordings (.fif). Uses MaxFilter. 
% Parameters 'par' are specific for each subject and experiment.
%
% Author: Marco Buiatti, INSERM Cognitive Neuroimaging Unit, Neurospin (France), 2014.

%% set path %%
addpath '/neurospin/local/mne/share'                                                        % MNE (needed to read and import fif data in fieldtrip) 
addpath '/neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline_tmp/'                                             % Neurospin pipeline scripts
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/neuromag_preproc/'    % local processing scripts

%% STEP 1: subject information %%
% Number of subject to analyze
n = 23; 
par = sc_par(n);
par

% =========================================================================
%% STEP 2: head movement correction, maxfilter %%
% =========================================================================
%
% Applies Neuromag software Maxfilter and Maxmove to the data.
%
% Based on the rotation/translation plot, choose a run as the ref for head position %
par=ns_neuromagpreproc_calc(par);

% Save figure head movement
fHand = figure(1);
set(fHand, 'Position', [0 0 1500 1000])
save2pdf([par.sssdir 'head_position.pdf'], gcf, 600)
close