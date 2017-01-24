%% Directories
% Get computer
comp = computer;

% MAC + Hard Drive
if strcmp(comp, 'MACI64') == 1
    % Paths
    addpath(genpath('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/'))
    fieldtrip_dir = '/Volumes/NeuroSpin4T/meg_tmp/Calculation_Pedro_2014/fieldtrips/fieldtrip_testedversion/';   
    bst_db_dir = '/Volumes/NeuroSpin4T/meg_tmp/Calculation_Pedro_2014/brainstorm_db/'; % Brainstorm database folder
    data_dir = '/Volumes/NeuroSpin4T/meg_tmp/Calculation_Pedro_2014/data/mat/';
    result_dir = '/Volumes/NeuroSpin4T/meg_tmp/Calculation_Pedro_2014/results/erf/';
    erf_fig_dir = '/Volumes/NeuroSpin4T/meg_tmp/Calculation_Pedro_2014/results/erf/figures/';   
    erf_stat_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/erf/stats/'; 
% Linux
elseif strcmp(comp, 'GLNXA64') == 1
    % Paths
    addpath(genpath('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/'))                    
    % Folders
    fieldtrip_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/fieldtrips/fieldtrip_testedversion/';   
    bst_db_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/brainstorm_db/'; % Brainstorm database folder
    data_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/';
    result_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/results/erf/';
    erf_fig_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/results/erf/figures/';   
    erf_stat_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/results/erf/stats/'; 
else
    error('You can only be using your macbook or a linux workstation at neurospin')
end