function data_grandavg = globalFieldPower(sub_name_all, chan_name)
%% Initialize dirs
InitDirsMEGcalc
GFP_result_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/GFP/';

% Load sensor classification
chan = load('SensorClassification.mat');
channels = chan.(chan_name);

data_all = struct;
for subj = 1:length(sub_name_all);
    load([data_dir sub_name_all{subj} '_calc_lp30.mat'])
    data = filterData(data, 'calc');
    
    if strcmp(chan_name, 'All2')
        % Zscore trials in each sensor for comparability between MAG and GRAD
        for i = 1:length(data.trial)
            for ii = 1:size(data.trial{i},1)
                data.trial{i}(ii,:) = zscore(data.trial{i}(ii,:));
            end
        end
    else
    end
    
    % Baseline correction
    cfg = [];
    cfg.baseline = [-0.5 -0.01];
    data_baseline = ft_timelockbaseline(cfg, data);
        
%     if strcmp(chan_name, 'All2')
%         % Zscore trials in each sensor for comparability between MAG and GRAD 
%         for i = 1:size(data_baseline.trial,1)
%             for ii = 1:size(data_baseline.trial,2)
%                 data_baseline.trial(i,ii,:) = zscore(data_baseline.trial(i,ii,:));
%             end
%         end
%     else
%     end
    
    % Avg
    cfg = [];
    cfg.channel = channels;
    data_timelock = ft_timelockanalysis(cfg, data_baseline);
    
    % Global field power
    cfg = [];
    cfg.channel = channels;
    cfg.methods = 'amplitude';
    data_all.(sub_name_all{subj}) = ft_globalmeanfield(cfg, data_timelock);
end

cfg = [];
cfg.keepindividual = 'no';

[data_grandavg] = ft_timelockgrandaverage(cfg, data_all.(sub_name_all{1}), data_all.(sub_name_all{2}), data_all.(sub_name_all{3}), data_all.(sub_name_all{4}), data_all.(sub_name_all{5}), ...
    data_all.(sub_name_all{6}), data_all.(sub_name_all{7}), data_all.(sub_name_all{8}), data_all.(sub_name_all{9}), data_all.(sub_name_all{10}), ...
    data_all.(sub_name_all{11}), data_all.(sub_name_all{12}), data_all.(sub_name_all{13}), data_all.(sub_name_all{14}), data_all.(sub_name_all{15}), ...
    data_all.(sub_name_all{16}), data_all.(sub_name_all{17}), data_all.(sub_name_all{18}), data_all.(sub_name_all{19}), data_all.(sub_name_all{20}));

%% Save
save([GFP_result_dir 'gfp_' chan_name '.mat'], 'data_grandavg')
end

