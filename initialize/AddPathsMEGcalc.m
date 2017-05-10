%% Directories
% Get computer
comp = computer;

% MAC + Hard Drive
if strcmp(comp, 'MACI64') == 1
    % Paths
    scripts_dir = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/';
    addpath(genpath(scripts_dir))
    fieldtrip_dir = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/fieldtrips/fieldtrip_testedversion/';   
%     addpath(fieldtrip_dir)
%     ft_defaults;
%     addpath(genpath(fieldtrip_dir));
    % Linux
elseif strcmp(comp, 'GLNXA64') == 1
    % Paths
    scripts_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/';
    addpath(genpath(scripts_dir))
    fieldtrip_dir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/fieldtrips/fieldtrip_testedversion/';
    addpath(fieldtrip_dir)
    ft_defaults;
%     addpath(genpath(fieldtrip_dir));    
else
    error('You can only be using your macbook or a linux workstation at neurospin')
end