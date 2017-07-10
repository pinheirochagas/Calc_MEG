%% Pipeline for the Calc_MEG paper

%% Set paths and directories
AddPathsMEGcalc
InitDirsMEGcalc
%% Get CoSMoMVPA
cd(cosmo_mvpa_dir)
cosmo_set_path()

%%  List subjects
sub_name_all = {'s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15','s16','s17','s18','s19','s21','s22'};
sub_name_all = {'s22'};

sub_name = {'s03','s04','s05','s06','s07','s08','s09','s10','s11','s13','s14','s15','s16','s17','s18','s19','s22'};

%% Add accuracy to all subjects
addAccuracy(sub_name_all) % This also corrects the RT by the visual delay

%% Low pass and downsample the data
for subj = 1:length(sub_name_all)
    load([data_dir sub_name_all{subj} '_calc_AICA_acc.mat'])
    downsampleLowpass(data, par, 30, 250, 'calc')
end
for subj = 1:length(sub_name_all)
    load([data_dir sub_name_all{subj} '_vsa_AICA.mat'])
    downsampleLowpass(data, par, 30, 250, 'vsa')
end

%% Time-locked to C and to response
for subj = 1:length(sub_name_all)
    load([data_dir sub_name_all{subj}, '_calc_lp30.mat'])
    lost_trials(subj,:) = timelock(data, sub_name_all{subj}, 'response');
    timelock(data, sub_name_all{subj}, 'result')
end

%% Global field power
GFP_result_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/GFP/';

data_all = struct;
cfg = [];
cfg.keeptrials = 'no';
for subj = 1:length(sub_name_all);
    load([data_dir sub_name_all{subj} '_calc_lp30.mat'])
    data = filterData(data, 'calc');
    data_all.(sub_name_all{subj}) = ft_timelockanalysis(cfg, data);
end

cfg = [];
cfg.keepindividual = 'no';
[data_grandavg] = ft_timelockgrandaverage(cfg, data_all.(sub_name_all{1}), data_all.(sub_name_all{2}), data_all.(sub_name_all{3}), data_all.(sub_name_all{4}), data_all.(sub_name_all{5}), ...
    data_all.(sub_name_all{6}), data_all.(sub_name_all{7}), data_all.(sub_name_all{8}), data_all.(sub_name_all{9}), data_all.(sub_name_all{10}), ...
    data_all.(sub_name_all{11}), data_all.(sub_name_all{12}), data_all.(sub_name_all{13}), data_all.(sub_name_all{14}), data_all.(sub_name_all{15}), ...
    data_all.(sub_name_all{16}), data_all.(sub_name_all{17}), data_all.(sub_name_all{18}), data_all.(sub_name_all{19}), data_all.(sub_name_all{20}));

% Global field power
cfg = [];
cfg.methods = 'power';
[gmf] = ft_globalmeanfield(cfg, data_grandavg);

LineCol = [0 0 0];
LineWidthMark = 1;
plot(gmf.time, gmf.avg, 'LineWidth', 3)
line([0 0], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([.8 .8], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([1.6 1.6], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([2.4 2.4], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([3.2 3.2], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([3.6 3.6], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
title('Global field power')
savePNG(gcf,200, [GFP_result_dir 'gfp_lp30.png'])



%% Behavior analysis
behAnalysisCalcMEG(sub_name)

%% ERF - to complete
% Load all data from all subjects (needs at least 30 gb free in disk space)
for subj = 1:length(sub_name)
    load([data_dir sub_name{subj} '_calc.mat'])
    data.trialinfoCustom = data.trialinfo;
    data.trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    dataAll.(sub_name{subj}) = data;
    clear data
end

%% Sources



%% Time-frequency
for i = length(sub_name);
    load([data_dir, sub_name{i}, '_calc_AICA.mat'])
    [TFR, trialinfo] = ftTFAlow(data);
    save([tfa_data_dir, sub_name{i}, '_TFA_low.mat'],'TFR','trialinfo','-v7.3');
    [TFR, trialinfo] = ftTFAhigh(data);
    save([tfa_data_dir, sub_name{i}, '_TFA_high.mat'],'TFR','trialinfo','-v7.3');
    clear('data', 'TFR', 'trialinfo')
end

for i = 1:length(sub_name_all);
    load([data_dir, sub_name_all{i}, '_calc_AICA_acc.mat'])
    data = filterData(data, 'calc');
    [TFR, trialinfo] = ftTFAallfreq(data, 'no');
    save([tfa_data_dir, sub_name_all{i}, '_TFA_allfreq_calc.mat'],'TFR','trialinfo','-v7.3');
end

%% Frequency spectrum from B to C
for i = 1:length(sub_name_all);
    load([data_dir, sub_name_all{i}, '_calc_AICA_acc.mat'])
    data = filterData(data, 'calc');
    % Crop the data from B to C and remove EEG/ECG
    data_tmp = data;
    data.trial = {};
    data.time = {};
    times_crop = ([1.6, 3.2]+0.5)*data.fsample;
    for t = 1:length(data_tmp.trial)
        for s = 1:size(data_tmp.trial{t},1)
            data.trial{t}(s,:) = data_tmp.trial{t}(s,times_crop(1):times_crop(2));
        end
        data.time{t} = 1.6:0.004:3.2;
    end
    data = removefields(data, 'ECGEOG');
    [TFR, trialinfo] = ftTFAcres(data);
    save([tfa_data_dir, sub_name_all{i}, '_TFA_cres_calc.mat'],'TFR','trialinfo');   
end


%% Quick univariate check
mean_res = [];
for i = 1:length(sub_name_all);
    load([tfa_data_dir, sub_name_all{i}, '_TFA_cres_calc.mat'],'TFR','trialinfo');
    for cres = 1:4
        trial_idx = trialinfo.operator ~=0 & trialinfo.corrResult == cres+2;
        TFR_tpm = TFR.powspctrm(trial_idx,:,:);
        mean_res(i,:,:,cres) = squeeze(mean(TFR_tpm,1));
    end
    
end

cfg=[];
ft_multiplotTFR(cfg, TFR);


[a,b] = closestMultipliers(204)
for i=1:size(TFR.powspctrm,2)
    subplot(a,b,i)
    hold on
    plot(mean(squeeze(TFR.powspctrm(:,i,:)),1))
    set(gca,'Visible','off')
end


mean_chan = squeeze(mean(TFR.powspctrm,2));
imagesc(mean_chan(:,7:8))


plot(mean(mean_chan,1))








end



%% Explore TF analysis
% plot parameters

data = struct;
for i = 1:length(sub_name_all);
    load([tfa_data_dir, sub_name_all{i}, '_TFA_allfreq_calc.mat'])
    data.(sub_name_all{i}) = TFR;
end

cfg = [];
cfg.keepindividual = 'yes';
[data_grandavg] = ft_freqgrandaverage(cfg, data.(sub_name_all{1}), data.(sub_name_all{2}), data.(sub_name_all{3}), data.(sub_name_all{4}), data.(sub_name_all{5}), ...
    data.(sub_name_all{6}), data.(sub_name_all{7}), data.(sub_name_all{8}), data.(sub_name_all{9}), data.(sub_name_all{10}), ...
    data.(sub_name_all{11}), data.(sub_name_all{12}), data.(sub_name_all{13}), data.(sub_name_all{14}), data.(sub_name_all{15}), ...
    data.(sub_name_all{16}), data.(sub_name_all{17}), data.(sub_name_all{18}), data.(sub_name_all{19}), data.(sub_name_all{20}));




load SensorClassification;

cfg = [];
cfg.showlabels   = 'no';
cfg.layout       = 'neuromag306all.lay'; %neuromag306all.lay neuromag306mag
%cfg.channel = Grad;
%cfg.baseline = [-0.5 -0.02];
%cfg.baselinetype = 'db';

ft_multiplotTFR(cfg, data_grandavg);



TFRlow = TFR
TFRhigh = TFR

%% Run ICA
ICA_result_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/ICA/';

%save([data_dir, sub_name_all{i}, '_ICA.mat'],'comp','-v7.3');

for i = 1:length(sub_name_all);
    load([data_dir, sub_name_all{i}, '_calc_AICA_acc.mat'])
    data = filterData(data, 'calc');
    [~,data] = timelock(data, sub_name_all{subj}, 'op2');
end

cfg = [];
cfg.method = 'runica';
cfg.runica.pca = 60;
comp = ft_componentanalysis(cfg, data);



data_reshape = cell2mat(arrayfun(@(x)permute(x{:},[1 3 2]),comp.trial,'UniformOutput',false));

colors_plot = parula(20);
LineCol = [0 0 0];
LineWidthMark = 1;

for i=1:20
    subplot(4,5,i)
    plot(comp.time{1},squeeze(mean(data_reshape(i,:,:),2)), 'Color', colors_plot(i,:), 'LineWidth', 3)
    line([0 0], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
    line([.8 .8], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
    box on
    title(['component ' num2str(i)])
end
savePNG(gcf,200, [ICA_result_dir sub_name_all{7} 'comp_0-20_avg.png'])




a = squeeze(data_reshape(1,:,:));


comp.topolabel == SensorClassification.Mag2

for i = 1:length(data.trial)
    data
end

grad1 = 1:3:306
grad2 = 2:3:306
mag = 3:3:306






SensorClassification = load('SensorClassification.mat')
SensorClassification.Mag2



cfg           = [];
cfg.component = [1:20];       % specify the component(s) that should be plotted
cfg.layout    = 'neuromag306mag.lay'; % specify the layout file that should be used for plotting
cfg.comment   = 'no';
ft_topoplotIC(cfg, comp)
savePNG(gcf,200, [ICA_result_dir sub_name_all{7} 'comp_0-20.png'])

cfg = [];
cfg.component = [1];       % specify the component(s) that should be plotted
cfg.layout    = 'neuromag306mag.lay'; % specify the layout file that should be used for plotting
cfg.viewmode = 'component';
ft_databrowser(cfg, comp)

cfg = [];
freq = ft_timelockanalysis(cfg, comp);


cfg          = [];
cfg.channel  = [2:5 15:18]; % components to be plotted
cfg.viewmode = 'component';
cfg.layout   = 'neuromag306cmb.lay'; % specify the layout file that should be used for plotting
ft_databrowser(cfg, comp)


%% Cosmo time-frequency-space searchlight LDA
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operand1', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operand2', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operator', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'corrResult', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'corrResultnoZero', 'low', 10, 1, 1, 5);

searchlight_ft_allsub = cosmoSearchLight(sub_name, 'corrResult', 'high', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operand1', 'high', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operand2', 'high', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operator', 'high', 10, 1, 1, 5);

searchlight_ft_allsub = cosmoSearchLight(sub_name, 'presResult', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'presResult', 'high', 10, 1, 1, 5);


%% Vizualize searchlight
sl.op1_low = load([searchlight_result_dir 'searchlight_ft_allsub_operand1_lda_ch10_tbin1_frbin1_low_freq.mat']);
sl.op2_low = load([searchlight_result_dir 'searchlight_ft_allsub_operand2_lda_ch10_tbin1_frbin1_low_freq.mat']);
sl.cres_low = load([searchlight_result_dir 'searchlight_ft_allsub_corrResult_lda_ch10_tbin1_frbin1_low_freq.mat']);
sl.op_low = load([searchlight_result_dir 'searchlight_ft_allsub_operator_lda_ch10_tbin1_frbin1_low_freq.mat']);

sl.op1_high = load([searchlight_result_dir 'searchlight_ft_allsub_operand1_lda_ch10_tbin1_frbin1_high_freq.mat']);
sl.op2_high = load([searchlight_result_dir 'searchlight_ft_allsub_operand2_lda_ch10_tbin1_frbin1_high_freq.mat']);
sl.cres_high = load([searchlight_result_dir 'searchlight_ft_allsub_corrResult_lda_ch10_tbin1_frbin1_high_freq.mat']);
sl.op_high = load([searchlight_result_dir 'searchlight_ft_allsub_operator_lda_ch10_tbin1_frbin1_high_freq.mat']);

names_sl = fieldnames(sl);

% Plot
cfg = [];
cfg.layout = 'neuromag306cmb.lay';

figureDim = [0 0 0.7 1];
for i=1:length(names_sl)
    figure('units','normalized','outerposition',figureDim)
    ft_multiplotTFR(cfg, sl.(names_sl{2}).searchlight_ft_allsub);
    colormap(flip(cbrewer2('RdBu')))
    savePNG(gcf,200, [searchlight_result_dir 'figures/' names_sl{i} '.png'])
end

%% Some individual plots
corrResult = load([searchlight_result_dir 'searchlight_ft_allsub_corrResult_lda_ch10_tbin1_frbin1_high_freq.mat'])

cfg = [];
cfg.layout       = 'neuromag306cmb.lay'; %neuromag306all.lay neuromag306mag

ft_multiplotTFR(cfg, operand2_lf.searchlight_ft_allsub);
save2pdf([searchlight_result_dir 'searchlight_op2_low_best.pdf'], gcf, 600)
caxis([.24 .30])


operand1_lf =  operand1_lf.searchlight_ft_allsub;

operand1_lf.meanall = squeeze(mean(operand1_lf.powspctrm,1));
operand1_lf.meanall(operand1_lf.meanall(:) < .25) = nan;
imagesc(operand1_lf.meanall)
caxis([.24 .3])

operand2_lf =  operand1_lf.searchlight_ft_allsub;
operand2_lf.powspctrm(operand1_lf.powspctrm(:) < .25) = nan;



ft_multiplotTFR(cfg, sl.(names_sl{1}).searchlight_ft_allsub);
colorbar
title('')
set(gca, 'FontSize', 30)
LineWidthMark = 2; LineCol = [1 1 1];
line([0 0], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([.8 .8], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([1.6 1.6], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([2.4 2.4], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([3.2 3.2], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
ylabel('Frequency (Hz)')
xlabel('Time (sec.)')
savePNG(gcf,200, [searchlight_result_dir 'figures/' names_sl{1} '_bestchan2.png'])


%% Cosmo simple decoding - to be completed
% Load all data from all subjects (needs at least 30 gb free in disk space)
for subj = 2:length(sub_name)
    load([data_dir sub_name{subj} '_calc_BR.mat'])
    % z-score each channel for later PCA
    
    % Convert to cosmo MVPA
    data_cosmo = calcConvertCOSMO(data);
    % Organize trialinfo
    [stim, stimfull] = comoOrganizeTrialInfo(data_cosmo.sa);
    data_cosmo.sa.stim = stim;
    data_cosmo.sa.stimfull = stimfull;
    sa = data_cosmo.sa;
    save([data_root_dir 'data/cosmo_mvpa/' sub_name{subj} '_calc_cosmo.mat'], 'data_cosmo', 'sa', '-v7.3');
end

%% Count number of events per subject
for subj = 1:length(sub_name)
    load([data_root_dir 'data/cosmo_mvpa/' sub_name{subj} '_calc_cosmo.mat'], 'sa');
    tab_stim = tabulate(sa.stim(sa.operator ~= 0));
    tab_stim_all(:,subj) = cell2mat(tab_stim(:,2));
end

%% Run PCA
for subj = 1:length(sub_name)
    load([data_root_dir 'data/cosmo_mvpa/' sub_name{subj} '_calc_cosmo.mat']);
    dt_cosmo_pca = PCAforcosmo(data_cosmo);
end


%% Calculate RSA - multiple regression
operation = 'sub';
timesphere = 2;
for subj = 1:length(sub_name)
    % Load data and convert to cosmo
    load([data_dir sub_name{subj} '_calc.mat'])
    % Select trials
    data = filterData(data, operation);
    % Convert to cosmo MVPA
    data_cosmo = calcConvertCOSMO(data);
    % Organize trialinfo and leave only the stim field
    [stim, stimfull] = cosmoOrganizeTrialInfo(data_cosmo.sa);
    % Select only the calculation trials
    data_cosmo.sa = [];
    data_cosmo.sa.stim = stim';
    % Run RSA
    cosmoRSA(sub_name{subj}, data_cosmo, timesphere, operation)
end

% Load all data
for p = 1:length(sub_name)
    load([rsa_result_dir 'RSA_all_DSM_mr_' operation '_tbin' num2str(timesphere) '_' sub_name{p} '.mat'])
    fieldnames_RSA = RSA.predictors;
    for f = 1:length(fieldnames_RSA);
        RSA_all.(operation).(fieldnames_RSA{f}){p}=RSA.result_reg_everything;
        RSA_all.(operation).(fieldnames_RSA{f}){p}.samples=RSA.result_reg_everything.samples(f,:);
        RSA_all.(operation).(fieldnames_RSA{f}){p}.sa.labels=RSA.result_reg_everything.sa.labels(f);
        RSA_all.(operation).(fieldnames_RSA{f}){p}.sa.metric=RSA.result_reg_everything.sa.metric(f);
    end
end

% Calculate stats
for f = 1:length(fieldnames_RSA);
    RSAstats(RSA_all.(operation).(fieldnames_RSA{f}), [operation '_' fieldnames_RSA{f}])
end


%% Plot results
load('cb2col.mat')

fieldnames_RSA_plot = {'op1_vis' 'op1_mag' 'operator' 'op2_vis' 'op2_mag' 'result_vis' 'result_mag'};
colors_RSA_plot = {'RdPu' 'Greys' 'Oranges' 'Greys' 'BuGn' 'Greys' 'Greys'};


fieldnames_RSA_plot = {'addsub_op1_vis', 'addsub_op1_mag', 'addsub_op2_vis', 'addsub_op2_mag', 'sub_result_vis', 'sub_result_mag'};
colors_RSA_plot = {'RdPu' 'Greys' 'Oranges' 'Greys' 'BuGn' 'Greys'};

figureDim = [0 0 .3 1];
figure('units','normalized','outerposition',figureDim)
count = [1 4 7];
for f = 1:length(fieldnames_RSA_plot);
    load([rsa_result_dir 'group_rsa_mr/RSA_stats_model_', [operation '_' fieldnames_RSA{f}], '_all_DSM_MR.mat'], 'RSAres');
    subplot(length(fieldnames_RSA_plot),1,f)
    %     if strcmp(fieldnames_RSA_plot{f}, 'operator') == 1
    %         RSAplot(RSAres,cb2col.(colors_RSA_plot{f}), 'y_lim', [-0.08 .35])
    %     else
    %         RSAplot(RSAres,cb2col.(colors_RSA_plot{f}), 'y_lim', [-0.08 .21])
    %     end
    RSAplot(RSAres,cb2col.(colors_RSA_plot{f}))
    %     title(fieldnames_RSA_plot{f}, 'interpreter', 'none')
    ylabel('rho')
    if f == length(fieldnames_RSA_plot)
        xlabel('Time (s)')
    else
        set(gca, 'XTickLabel', [])
    end
end
savePNG(gcf,200, [rsa_result_dir 'plots/calc_RSA_mr.png'])





%% RSA searchlight TF cosmo
fq_range = 'low';
for subj = 1:length(sub_name)
    % Load data and convert to cosmo
    load([tfa_data_dir, sub_name{subj} '_TFA_' fq_range '.mat']);
    TFR.trialinfo = trialinfo;
    % Select trials
    data = filterDataTF(TFR, 'calc');
    % Convert to cosmo MVPA
    data_cosmo = calcConvertCOSMOtf(data);
    % Organize trialinfo and leave only the stim field
    [stim] = cosmoOrganizeTrialInfo(data_cosmo.sa);
    % Select only the calculation trials
    data_cosmo.sa = [];
    data_cosmo.sa.stim = stim';
    % Run RSA
    cosmoRSAsearchLight(sub_name{subj}, data_cosmo, fq_range, 'all', 2, 1)
    %     cosmoRSAsearchLight(sub_name{subj}, data_cosmo, fq_range, 10, 2, 1)
end

% Load all data
for p = 1:length(sub_name)
    load([rsa_result_dir sub_name{p} '_RSA_searchlight_all_DSM_ch10_tbin2_frbin1_low_freq.mat']);
    fieldnames_RSA = RSA.predictors;
    for f = 1:length(fieldnames_RSA);
        RSA_all.(fieldnames_RSA{f}){p}=RSA.result_reg_everything;
        RSA_all.(fieldnames_RSA{f}){p}.samples=RSA.result_reg_everything.samples(f,:);
        RSA_all.(fieldnames_RSA{f}){p}.sa.labels=RSA.result_reg_everything.sa.labels(f);
        RSA_all.(fieldnames_RSA{f}){p}.sa.metric=RSA.result_reg_everything.sa.metric(f);
    end
end


%% Calculate stats - to be completed
for f = 2:length(fieldnames_RSA);
    RSAstats(RSA_all.(fieldnames_RSA{f}), fieldnames_RSA{f})
end



%% Avg data cosmo and convert to fieldtrip
for f = 1:length(fieldnames_RSA);
    ds_stacked_RSA = cosmo_stack(RSA_all.(fieldnames_RSA{f}));
    ds_stacked_RSA_ft.(fieldnames_RSA{f}) = cosmo_map2meeg(ds_stacked_RSA);
end

% Plot
cfg = [];
cfg.layout = 'neuromag306cmb.lay';
cfg.showoutline = 'yes';
cfg.box = 'yes';
cfg.showlabels = 'no';
cfg.colorbar = 'yes';

figureDim = [0 0 0.7 1];
for i=1:length(fieldnames_RSA)
    figure('units','normalized','outerposition',figureDim)
    data_tmp = ds_stacked_RSA_ft.(fieldnames_RSA{1});
    ft_multiplotTFR(cfg, data_tmp);
    colormap(flip(cbrewer2('RdBu')))
    caxis([-prctile(data_tmp.powspctrm(:),95) prctile(data_tmp.powspctrm(:),95)])
    savePNG(gcf,200, [searchlight_result_dir 'figures/RSA_all_DSM_mr' fieldnames_RSA{i} '.png'])
end


%% Manual plotting selecting channels
i = 6;
figureDim = [0 0 .6 .7];
data_tmp = ds_stacked_RSA_ft.(fieldnames_RSA{i});
ft_multiplotTFR(cfg, data_tmp);
colormap(flip(cbrewer2('RdBu')))
caxis([-.08 .08])
title(fieldnames_RSA{i}, 'interpreter', 'none')
set(gca, 'FontSize', 30)
set(gcf, 'units','normalized','outerposition',figureDim)
LineWidthMark = 2; LineCol = [.3 .3 .3];
line([0 0], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([.8 .8], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([1.6 1.6], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([2.4 2.4], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([3.2 3.2], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([3.6 3.6], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
ylabel('Frequency (Hz)')
xlabel('Time (s)')
savePNG(gcf,200, [searchlight_result_dir 'figures/RSA_all_DSM_mr_' fieldnames_RSA{i} '_best_channels.png'])

%% Topo
set(gcf, 'units','normalized','outerposition',figureDim)
colormap(flip(cbrewer2('RdBu')))
caxis([-.05 .05])
title(fieldnames_RSA{i}, 'interpreter', 'none')
% savePNG(gcf,200, [searchlight_result_dir 'figures/RSA_all_DSM_mr_' fieldnames_RSA{i} '_best_channels_topo_t1.png'])
% savePNG(gcf,200, [searchlight_result_dir 'figures/RSA_all_DSM_mr_' fieldnames_RSA{i} '_best_channels_topo_t2.png'])


%% END

%% Plot single subjects
for i=1:length(sub_name)
    hold on
    subplot(6,3,i)
    plot(data.time{1},RSA_all.result_mag{i}.samples)
    title(sub_name{i})
end

%% Avg data
for f = 1:length(fieldnames_RSA);
    ds_stacked_RSA.(fieldnames_RSA{f}) = cosmo_stack(RSA_all.(fieldnames_RSA{f}));
    ds_stacked_RSA_ft.(fieldnames_RSA{f}) = cosmo_map2meeg(ds_stacked_RSA.(fieldnames_RSA{f}));
end
% add time
plot(data.time{1},mean(ds_stacked_RSA.op2_mag.samples,1))

%% Plot single subjects
for i=1:length(ds_stacked_RSA_ft)
    subplot(6,3,i)
    plot(data.time{1},ds_stacked_RSA_ft.result_mag)
    title(sub_name{i})
end



%
%
%     % Organize trialinfo and leave only the stim field
%     [stim, stimfull] = cosmoOrganizeTrialInfo(data_cosmo.sa);
%     % Select only the calculation trials
%     data_cosmo.sa = [];
%     data_cosmo.sa.stim = stim';
%     % Run RSA
%
%
% %%
%
%
% for i = length(sub_name);
%     load([tfa_data_dir, sub_name{i}, '_TFA_low.mat'])
%     ft_multiplotTFR(cfg, TFR);
%     load([tfa_data_dir, sub_name{i}, '_TFA_high.mat'])
%     ft_multiplotTFR(cfg, TFRhigh);
%
% %% Test baseline correct cfg = [];
% cfg = [];
% cfg.baseline = [-0.2 -0.02];
% cfg.baselinetype = 'db';
% TFRbaseline = ft_freqbaseline(cfg, TFR);
%
%
% figure(4)
% ft_multiplotTFR(cfg, TFRbaseline);
%
% %%
%
%
%
% % average frequencies of interest
% cfg = [];
% cfg.frequency = [1 15];
% cfg.avgoverfreq = 'yes';
% tmpA = ft_selectdata(cfg,operand1.searchlight_ft_allsub);
% tmpA.avg = squeeze(tmpA.powspctrm);
% tmpA.dimord = 'chan_time';
% tmpA = rmfield(tmpA,{'powspctrm','freq'});
% %plot
% figure(2);
%
%
% cfg = [];
% % cfg.xlim=[0:0.05:1];
% % cfg.zlim = [0.48 0.53];
% cfg.layout       = 'neuromag306cmb.lay';
% %cfg.comment = 'xlim';
% %cfg.style = 'straight';
% %cfg.commentpos = 'title';
% data3 = ft_timelockanalysis(cfg, data2)
%
% ft_topoplotER(cfg, data);
% colormap(redblue)
%
%
% %plot
%
% figure(1);
% cfg = [];
% % cfg.xlim=[0.1:0.08:0.6];
% cfg.zlim = [0.25 .30];
% cfg.layout       = 'neuromag306cmb.lay';
% cfg.comment = 'no';
% cfg.style = 'straight';
%
% h = subplot(1,5,4)
% ft_topoplotER(cfg, tmpA);
% colormap(cbrewer2('Reds'))
%
%
% ft_multiplotTFR(cfg, corrResult.searchlight_ft_allsub);
%
%
% p = get(h, 'pos');
%
% p(1) = p(1) - .25;
%
% set(h, 'pos', p);
%
% figureDim = [0 0 1 .45];
%
% figure('units','normalized','outerposition',figureDim)
%
%
% %% Stats cosmo searchlight
% % Load all data
% conds = 'corrResult';
% spacesphere = 10;
% timesphere = 1;
% freqsphere = 1;
% fq_range = 'low';
%
%
%
% for p = 1:length(sub_name)
%     load([searchlight_result_dir 'searchlight_ft_', conds '_' sub_name{p} '_lda_ch' num2str(spacesphere) '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere), '_' fq_range '_freq.mat'], 'all_ft');
%     fieldnames_RSA = fieldnames(RSA);
%     for f = 1:length(fieldnames_RSA);
%         RSA_all_jac.(fieldnames_RSA{f}){p}=RSA.(fieldnames_RSA{f});
%     end
% end
%
% % Calculate stats
% for f = 1:length(fieldnames_RSA);
%     RSAstats(RSA_all_jac.(fieldnames_RSA{f}), fieldnames_RSA{f})
% end


%
% %% RSA cosmo - multiple regression
% for subj = 1:length(sub_name)
%     % Load data and convert to cosmo
%     load([data_dir sub_name{subj} '_calc_AICA.mat'])
%     % Convert to cosmo MVPA
%     data_cosmo = calcConvertCOSMO(data);
%     % Organize trialinfo and leave only the stim field
%     [stim, stimfull] = comoOrganizeTrialInfo(data_cosmo.sa);
%     % Select only the calculation trials
%     data_cosmo.samples = data_cosmo.samples(data_cosmo.sa.operator ~= 0,:);
%     stim = stim(data_cosmo.sa.operator ~= 0);
%     data_cosmo.sa = [];
%     data_cosmo.sa.stim = stim';
%     % Run RSA
%     cosmoRSA(sub_name{subj}, data_cosmo)
% end
%
% %% Calculate stats and plot
% % Load all data
% for p = 1:length(sub_name)
%     load([rsa_result_dir '/RSA_cosmo_jac' sub_name{p} '.mat'])
%     fieldnames_RSA = fieldnames(RSA);
%     for f = 1:length(fieldnames_RSA);
%         RSA_all_jac.(fieldnames_RSA{f}){p}=RSA.(fieldnames_RSA{f});
%     end
% end
%
% % Calculate stats
% for f = 1:length(fieldnames_RSA);
%     RSAstats(RSA_all_jac.(fieldnames_RSA{f}), fieldnames_RSA{f})
% end
%
% %% Load data
% load([rsa_result_dir 'RSA_cosmo_s02.mat']);
%
% %% Merge jaccard
% fieldnames_RSA = fieldnames(RSA);
% %%
%
% fieldnames_RSA_plot = {'op1_mag', 'op2_mag', 'result_mag', 'op1_vis', 'op2_vis', 'operator', 'op1_magregop1_vis', 'op2_magregop2_vis', 'result_magregoperator'};
% colors_plot = repmat([cdcol.turquoiseblue; cdcol.grassgreen; cdcol.orange],3,1);
%
% %% Plot results
% load('cdcol.mat')
%
% figureDim = [0 0 1 1];
% figure('units','normalized','outerposition',figureDim)
% for f = 1:length(fieldnames_RSA_plot);
%     load([rsa_result_dir '/group/RSA_stats_model_', fieldnames_RSA_plot{f}, '.mat'])
%     subplot(3,3,f)
%     if strcmp(fieldnames_RSA_plot{f}, 'operator') == 1
%         RSAplot(RSAres,colors_plot(f,:), 'y_lim', [-0.05 .35])
%     else
%         RSAplot(RSAres,colors_plot(f,:), 'y_lim', [-0.05 .21])
%     end
%     title(fieldnames_RSA_plot{f}, 'interpreter', 'none')
% end
% savePNG(gcf,200, [rsa_result_dir 'plots/calc_RSA1.png'])
%
%
% figureDim = [0 0 1 1];
% figure('units','normalized','outerposition',figureDim)
% subplot(3,3,1)
% load([rsa_result_dir '/group/RSA_stats_model_', 'operator', '.mat'])
% RSAplot(RSAres,cdcol.scarlet)
% savePNG(gcf,200, [rsa_result_dir 'plots/calc_RSA1.png'])
%

