function data_grandavg = globalFieldPower_separate_channels(sub_name_all, chan_name)
%% Initialize dirs
InitDirsMEGcalc
GFP_result_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/GFP/';

% Load sensor classification
chan = load('SensorClassification.mat');
channels = chan.(chan_name);

data_all = {};
for subj = 1:length(sub_name_all);
    load([data_dir sub_name_all{subj} '_calc_lp30.mat'])
    data = filterData(data, 'calc');
            
%     % Baseline correction
%     cfg = [];
%     cfg.baseline = [-0.5 -0.01];
%     data_baseline = ft_timelockbaseline(cfg, data);
    
    % Average all trails
    cfg = [];
    cfg.channel = chan.Grad2_1;
    data_G1 = ft_timelockanalysis(cfg, data); % or data_baseline
    cfg.channel = chan.Grad2_2;
    data_G2 = ft_timelockanalysis(cfg, data); % or data_baseline
    cfg.channel = chan.Mag2;
    data_M = ft_timelockanalysis(cfg, data); % or data_baseline
    
    cfg = [];
    data_G1 = ft_globalmeanfield(cfg, data_G1);
    data_G2 = ft_globalmeanfield(cfg, data_G2);
    data_M = ft_globalmeanfield(cfg, data_M);
    
    cfg = [];
    cfg.baseline = [-0.5 -0.01];
    a = ft_timelockbaseline(cfg, data_G1)

    data_G1_z = zscore(data_G1.avg);
    data_G1_z = zscore(data_G1.avg);
    data_G1_z = zscore(data_G1.avg);

    
    
    %% GFP
    % 1. Scale GRAD and MAG
    data_z = zeros(size(data_tl.avg));
    for ii = 1:size(data_tl.avg,1)
        data_z(ii,:) = zscore(data_tl.avg(ii,:));
    end
 
    % 2. Square zscores (bring all to positive)
    data_s = zeros(size(data_z));
    for ii = 1:size(data_z,1)
        data_s(ii,:) = data_z(ii,:).^2;
    end
    
    % 3. Sum the trials
    data_sum = sum(data_s,1);
    
    % 4. Square root of all trails (put in the same scale)
    data_gfp = sqrt(data_sum);
    
    % Group subjects
    data_tl.avg = data_gfp;
    data_tl = removefields(data_tl, 'var');
    data_all{subj} = data_tl;
end

cfg = [];
cfg.keepindividual = 'no';
[data_grandavg] = ft_timelockgrandaverage(data_all{:});

% cfg = [];
% cfg.baseline = [-0.5 -0.01];
% data_baseline_all = ft_timelockbaseline(cfg, data_grandavg);



%% Save
save([GFP_result_dir 'gfp_' chan_name '_baseline_nocorrect.mat'], 'data_grandavg')

end

