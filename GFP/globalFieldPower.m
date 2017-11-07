function data_grandavg = globalFieldPower(sub_name_all, condition, chan_name)
%% Initialize dirs
InitDirsMEGcalc
GFP_result_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/GFP/';

% Load sensor classification
chan = load('SensorClassification.mat');
channels = chan.(chan_name);

data_all = {};
for subj = 1:length(sub_name_all);
    load([data_dir sub_name_all{subj} '_calc_lp30.mat'])
    data = filterData(data, condition);
    
    % Crop trials from -.2 4
    [~,data] = timelock(data, 's01', 'A'); % subject info is irrelevant here
    
    % Baseline correction
    cfg = [];
    cfg.baseline = [-0.2 -0.01];
    data_baseline = ft_timelockbaseline(cfg, data);
    
    % Average all trails
    cfg = [];
    cfg.channel = channels;
    data_tl = ft_timelockanalysis(cfg, data_baseline); % or data_baseline
    
    %% GFP
    data_tmp = data_tl.avg;

    % 1. Square data (bring all to positive)
    data_s = zeros(size(data_tmp));
    for ii = 1:size(data_tmp,1)
        data_s(ii,:) = data_tmp(ii,:).^2;
    end
    
    % 2. Average trials
    data_mean = mean(data_s,1);
    
    % 3. Square root trails (bring back to the original unit)
    data_gfp = sqrt(data_mean);
    
    % Group subjects
    data_tl.avg = data_gfp;
    data_tl = removefields(data_tl, 'var');
    data_all{subj} = data_tl;
end

cfg = [];
cfg.keepindividual = 'yes';
cfg.keeptrials = 'yes';
[data_grandavg] = ft_timelockgrandaverage(data_all{:});


%% Save
save([GFP_result_dir 'gfp_' chan_name '_' condition '_RMS_baseline.mat'], 'data_grandavg')

end