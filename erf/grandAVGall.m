function data_grandavg = grandAVGall(sub_name_all)
%% Output dir
InitDirsMEGcalc
data_erf = [data_root_dir 'data/erf/'];

%% 
data_all = struct;
cfg = [];
cfg.keeptrials = 'no';
for subj = 1:length(sub_name_all);
    load([data_dir sub_name_all{subj} '_calc_lp30.mat'])
    data = filterData(data, 'calc');
    
    % Baseline correction
    cfg = [];
    cfg.baseline = [-0.5 -0.01];
    data_baseline = ft_timelockbaseline(cfg, data);
    
    data_all.(sub_name_all{subj}) = ft_timelockanalysis(cfg, data_baseline);
end

cfg = [];
cfg.keepindividual = 'yes';
[data_grandavg] = ft_timelockgrandaverage(cfg, data_all.(sub_name_all{1}), data_all.(sub_name_all{2}), data_all.(sub_name_all{3}), data_all.(sub_name_all{4}), data_all.(sub_name_all{5}), ...
    data_all.(sub_name_all{6}), data_all.(sub_name_all{7}), data_all.(sub_name_all{8}), data_all.(sub_name_all{9}), data_all.(sub_name_all{10}), ...
    data_all.(sub_name_all{11}), data_all.(sub_name_all{12}), data_all.(sub_name_all{13}), data_all.(sub_name_all{14}), data_all.(sub_name_all{15}), ...
    data_all.(sub_name_all{16}), data_all.(sub_name_all{17}), data_all.(sub_name_all{18}), data_all.(sub_name_all{19}), data_all.(sub_name_all{20}));

save([data_erf 'data_grandavg.mat'], 'data_grandavg')
end

