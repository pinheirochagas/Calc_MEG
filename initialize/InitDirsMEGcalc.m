%% Directories
% Get computer
comp = computer;

% MAC + Hard Drive
if strcmp(comp, 'MACI64') == 1
    data_root_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/';
% Linux
elseif strcmp(comp, 'GLNXA64') == 1
    data_root_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/';
    
else
    error('You can only be using your macbook or a linux workstation at neurospin')
end

% Directories
bst_db_dir = [data_root_dir 'brainstorm_db/']; % Brainstorm database folder
bst_db_data_dir = [data_root_dir 'brainstorm_db/calc/data/']; % Brainstorm database folder
data_dir = [data_root_dir 'data/mat/'];
data_sss_dir = [data_root_dir 'data/sss/'];
erf_result_dir = [data_root_dir 'results/erf/'];
erf_fig_dir = [data_root_dir 'results/erf/figures/'];
erf_stat_dir = [data_root_dir 'results/erf/stats/'];
tfa_data_dir = [data_root_dir 'data/TFA/'];