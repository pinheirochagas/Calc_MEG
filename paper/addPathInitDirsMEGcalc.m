%function [datapath,resultpath,figurespath] = addPathInitDirsMEGcalc

%% Directories
% Get computer
comp = computer;

% MAC + Hard Drive
if strcmp(comp, 'MACI64') == 1
    % Paths
    addpath(genpath('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/'))
    addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/fieldtrips/fieldtrip_testedversion/'   % fieldtrip version tested with this pipeline
    ft_defaults
    % Folders
    datapath = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/data/mat/';
    resultpath = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/data/erf/';
    figurespath = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/erf/figures/';
    statspath = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/erf/stats/'; 
% Linux
elseif strcmp(comp, 'linux') == 1
    % Paths
    addpath(genpath('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/'))                            % local processing scripts
    addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/fieldtrips/fieldtrip_testedversion/'   % fieldtrip version tested with this pipeline
    ft_defaults
    %Linux
    datapath = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/';
    resultpath = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/erf/';
    figurespath = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/results/erf/figures/';   
else
    error('You can only specify mac or linux')
end



%% Data and results
% MAC
%datapath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/mat/';
%resultpath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/erf/';





%end
