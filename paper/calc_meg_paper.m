%% Pipeline for the Calc_MEG paper

%% Set paths and directories
AddPathsMEGcalc
InitDirsMEGcalc
%% Get CoSMoMVPA
cd(cosmo_mvpa_dir)
cosmo_set_path()

%%  List subjects
sub_name_all = {'s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15','s16','s17','s18','s19','s21','s22'};

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

%% Time-locked to C and to response lp data
for subj = 1:length(sub_name_all)
    load([data_dir sub_name_all{subj}, '_calc_lp30.mat'])
    lost_trials(subj,:) = timelock(data, sub_name_all{subj}, 'response');
    timelock(data, sub_name_all{subj}, 'result')
end

%% Time-locked to C and to response AICA data
for subj = 1:length(sub_name_all)
    load([data_dir sub_name_all{subj}, '_calc_AICA_acc.mat'])
%     lost_trials(subj,:) = timelock(data, sub_name_all{subj}, 'result');
    timelock(data, sub_name_all{subj}, 'result')
end

%% Global field power
GFP_result_dir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/GFP/';
% gfp_mag = globalFieldPower(sub_name_all, 'Mag2');
% gfp_grad1 = globalFieldPower(sub_name_all, 'Grad2_1');
% gfp_grad2 = globalFieldPower(sub_name_all, 'Grad2_2');
% gfp_all = globalFieldPower(sub_name_all, 'All2');
gfp_all = load([GFP_result_dir 'gfp_All2.mat'], 'data_grandavg');
gfp_all = gfp_all.data_grandavg;

% Plot GFP
figureDim = [0 0 .6 .3];
figure('units','normalized','outerposition',figureDim)
LineCol = [.5 .5 .5];
LineWidthMark = 1;
hold on
ylim([0 .4])
%plot(gfp_mag.time, gfp_mag.avg, 'LineWidth', 3)
%plot(gfp_grad1.time, gfp_grad1.avg, 'LineWidth', 3)
%plot(gfp_grad2.time, gfp_grad2.avg, 'LineWidth', 3)
line([0 0], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([.8 .8], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([1.6 1.6], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([2.4 2.4], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([3.2 3.2], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
line([3.6 3.6], ylim, 'Color', LineCol, 'LineWidth', LineWidthMark);
plot(gfp_all.time, gfp_all.avg, 'LineWidth', 2.5, 'Color', 'k')
xlabel('Time (s)')
ylabel('GFP (z-score)')
set(gca, 'FontSize', 20)
xlim([-.2 4.2])
set(gca, 'XTick', 0:.4:4.2);
box on
save2pdf([GFP_result_dir 'gfp_lp30_zscore' '_' 'All2' '.pdf'], gcf, 600)

%% Behavior analysis
beh_calc = behAnalysisCalcMEG(sub_name_all, 'calc');
beh_comp = behAnalysisCalcMEG(sub_name_all, 'comp');
beh_add = behAnalysisCalcMEG(sub_name_all, 'add');
beh_sub = behAnalysisCalcMEG(sub_name_all, 'sub');

% Analyse deviant 
condition = 'calc';
beh_data = load([beh_res_dir_group 'behavior_data_processed_' condition '.mat']);
[group, ind] = behStats(beh_data.trialinfoAll);

for i=1:length(beh_data.trialinfoAll)
    subplot(5,4,i)
    boxplot(beh_data.trialinfoAll{i}(:,10), beh_data.trialinfoAll{i}(:,9))
end


%% ERF - to complete
%data_grandavg = grandAVGall(sub_name_all);
data_erf = [data_root_dir 'data/erf/'];
load([data_erf 'data_grandavg.mat'])

% Plot topographies
% Combine gradiometers
cfg = [];
data_tmp = ft_combineplanar(cfg, data_grandavg);
data_tmp.avg = squeeze(mean(data_tmp.trial(:,1:102,:),1));
data_tmp.label = data_tmp.label(1:102);

% Plot
cfg = [];
cfg.layout    = 'neuromag306cmb.lay'; % specify the layout file that should be used for plotting
cfg.xlim = [0:.2:4];
cfg.zlim = [0.0374    0.3] * 1.0e-11
cfg.comment = 'xlim';
cfg.commentpos = 'title'
cfg.marker = 'off'
% cfg.colorbar = 'SouthOutside'
ft_topoplotER(cfg, data_tmp)
% colormap(cbrewer2('Blues'))
colormap('viridis')

% save2pdf([erf_result_dir 'topo_GFP' '.pdf'], gcf, 600)
print(gcf, [erf_result_dir 'topo_GFP' '.eps'], '-depsc', '-painters')

% Save colorbar
colorbar
colormap(cbrewer2('Blues'))
caxis(cfg.zlim)
set(gca,'FontSize', 20)

save2pdf([erf_result_dir 'topo_GFP_colormap' '.pdf'], gcf, 600)

% Plot magnetometers
cfg = [];
cfg.layout    = 'neuromag306mag.lay'; % specify the layout file that should be used for plotting
cfg.xlim = [-0.4:0.2:4.4];
data_tmp = ft_combineplanar(cfgcmb, data_grandavg);
data_tmp.avg = squeeze(mean(data_tmp.trial(:,103:end,:),1));
data_tmp.label = data_tmp.label(103:end);

ft_topoplotER(cfg, data_tmp)

% Plot some topographies
cfg = []
cfg.layout    = 'neuromag306cmb.lay'; % specify the layout file that should be used for plotting
cfg.xlim = [4 4.5];

field_plots = fieldnames(avgERFallGavg.addsub.operand2);

for i = 1:length(field_plots)
    subplot(1,4,i)
    cfgcmb = [];
    data_tmp = ft_combineplanar(cfgcmb, avgERFallGavg.addsub.operand2.(field_plots{i}));
    data_tmp.avg = squeeze(mean(data_tmp.trial(:,1:102,:),1));
    data_tmp.label = data_tmp.label(1:102);
    ft_topoplotER(cfg, data_tmp)
end

cfg = []
cfg.layout    = 'neuromag306mag.lay'; % specify the layout file that should be used for plotting
cfg.xlim = [1.6 1.8];

data_tmp2 = avgERFallGavg.addsub.operand2.(field_plots{i});
ft_topoplotER(cfg, data)

tpm = ft_combineplanar(cfg, ERF_diff);



%% Sources



%% Time-frequency
for i = length(sub_name_all);
    load([data_dir, sub_name_all{i}, '_calc_AICA_TLresult.mat'])
    [TFR, trialinfo] = ftTFAlow(data);
    save([tfa_data_dir, sub_name_all{i}, '_TFA_low_TLresult.mat'],'TFR','trialinfo','-v7.3');
    [TFR, trialinfo] = ftTFAhigh(data);
    save([tfa_data_dir, sub_name_all{i}, '_TFA_high_TLresult.mat'],'TFR','trialinfo','-v7.3');
    clear('data', 'TFR', 'trialinfo')
end

% All frquencies
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
        trial_idx = trialinfo.operator ~=0 & trialinfo.operand2 == cres-1;
        TFR_tpm = TFR.powspctrm(trial_idx,:,:);
        mean_res(i,:,:,cres) = squeeze(mean(TFR_tpm,1));
    end
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


%% Decoding from MNE-Python
% Load data
conditions_A = {'op1_op1', 'addsub_addsub', 'op2_op2', 'cres_cres', 'cres_cres', 'choice_choice', 'respside_respside'};

conditions_C = {'resultlock_op1_resultlock_op1', 'resultlock_addsub_resultlock_addsub', 'resultlock_op2_resultlock_op2', 'resultlock_cres_resultlock_cres', ...
                'resultlock_pres_resultlock_pres', 'resultlock_choice_resultlock_choice', 'resultlock_respside_resultlock_respside'};
            
conditions_RT = {'resplock_op1_resplock_op1', 'resplock_addsub_resplock_addsub', 'resplock_op2_resplock_op2', 'resplock_cres_resplock_cres', ...
                'resplock_pres_resplock_pres', 'resplock_choice_resplock_choice', 'resplock_respside_resplock_respside'};

baselinecorr = 'nobaseline';
dec_method = 'class'; % class reg classGeneral
dec_scorer = 'accuracy'; % accuracy or kendall_score
gatordiag = 'gat';

for i = 1:length(conditions_A)
    res.(dec_method).a.(conditions_A{i}) = load([dec_res_dir_group conditions_A{i} '/' conditions_A{i} '_' dec_method '_' dec_scorer '_' 'results.mat']);
    res.(dec_method).c.(conditions_C{i}) = load([dec_res_dir_group conditions_C{i} '/' conditions_C{i} '_' dec_method '_' dec_scorer '_' 'results.mat']);
    res.(dec_method).rt.(conditions_RT{i}) = load([dec_res_dir_group conditions_RT{i} '/' conditions_RT{i} '_' dec_method '_' dec_scorer '_' 'results.mat']);
end

%% Plot
colors = parula(length(conditions_A));

% Predefine some y_lim
y_lims = zeros(length(conditions_A),2,1);
y_lims(4,:) = [0.20 .30];
y_lims(5,:) = [0.22 .32];
y_lims(6,:) = [0.47 .69];
y_lims(7,:) = [0.46 .93];

% Timelock to A
figureDim = [0 0 .6 1*(7/8)];
figure('units','normalized','outerposition',figureDim)
x_lim = [-.2 3.2];
for i=1:length(conditions_A)
    subplot(length(conditions_A),1,i)
    y_lims(i,:) = mvpaPlot(res.(dec_method).a.(conditions_A{i}), 'diag', colors(i,:), x_lim, y_lims(i,:), 'A');
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    set(gca,'FontSize',18) % stretch its width and height
    if i == length(conditions_A)
        set(gca,'XColor','k')
        set(gca, 'XTickLabel', [x_lim(1) 0:.4:x_lim(end)])
        xlabel('Time (s)')
    end
end
save2pdf([dec_res_dir_group 'decoding_' dec_method '_A.pdf'], gcf, 600)

% Timelock to C
figureDim = [0 0 .6/3.4 1*(7/8)];
figure('units','normalized','outerposition',figureDim)
x_lim = [-.2 .8];
for i=1:length(conditions_C)
    subplot(length(conditions_C),1,i)
    mvpaPlot(res.(dec_method).c.(conditions_C{i}), 'diag', colors(i,:), x_lim, y_lims(i,:), 'C');
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    set(gca,'FontSize',18) % stretch its width and height
    if i == length(conditions_A)
        set(gca,'XColor','k')
        set(gca, 'XTickLabel', [x_lim(1) 0:.4:x_lim(end)])
        xlabel('Time (s)')
    end
end
save2pdf([dec_res_dir_group 'decoding_' dec_method '_C.pdf'], gcf, 600)


% Timelock to RT
figureDim = [0 0 .6/3.4 1*(7/8)];
figure('units','normalized','outerposition',figureDim)
x_lim = [-.8 .1];
for i=1:length(conditions_RT)
    subplot(length(conditions_RT),1,i)
    y_lims(i,:) = mvpaPlot(res.(dec_method).rt.(conditions_RT{i}), 'diag', colors(i,:), x_lim, y_lims(i,:), 'RT');
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    set(gca,'FontSize',18) % stretch its width and height
    if i == length(conditions_A)
        set(gca,'XColor','k')
        set(gca, 'XTickLabel', [x_lim(1):.4:x_lim(end)])
        xlabel('Time (s)')
    end
end
save2pdf([dec_res_dir_group 'decoding_' dec_method '_RT.pdf'], gcf, 600)

%% Decoding regression MNE-Python
% Load data
conditions_A = {'op1_op1', 'op2_op2', 'pres_pres', 'cres_cres', 'absdeviant_absdeviant'};

conditions_C = {'resultlock_op1_resultlock_op1', 'resultlock_op2_resultlock_op2', 'resultlock_cres_resultlock_cres', ...
                'resultlock_pres_resultlock_pres', 'resultlock_absdeviant_resultlock_absdeviant'};
            
conditions_RT = {'resplock_op1_resplock_op1','resplock_op2_resplock_op2', 'resplock_cres_resplock_cres', ...
                'resplock_pres_resplock_pres', 'resplock_absdeviant_resplock_absdeviant'};

baselinecorr = 'nobaseline';
dec_method = 'reg'; % class reg classGeneral
dec_scorer = 'kendall_score'; % accuracy or kendall_score
gatordiag = 'gat';

for i = 1:length(conditions_A)
    res.(dec_method).a.(conditions_A{i}) = load([dec_res_dir_group conditions_A{i} '/' conditions_A{i} '_' dec_method '_' dec_scorer '_' 'results.mat']);
    res.(dec_method).c.(conditions_C{i}) = load([dec_res_dir_group conditions_C{i} '/' conditions_C{i} '_' dec_method '_' dec_scorer '_' 'results.mat']);
    res.(dec_method).rt.(conditions_RT{i}) = load([dec_res_dir_group conditions_RT{i} '/' conditions_RT{i} '_' dec_method '_' dec_scorer '_' 'results.mat']);
end

%% Plot
colors = parula(8);
colors = colors([1 3:6],:)

% Predefine some y_lim
y_lims = zeros(length(conditions_A),2,1);

% Timelock to A
figureDim = [0 0 .6 1*(5/8)];
figure('units','normalized','outerposition',figureDim)
x_lim = [-.2 3.2];
for i=1:length(conditions_A)
    subplot(length(conditions_A),1,i)
    y_lims(i,:) = mvpaPlot(res.(dec_method).a.(conditions_A{i}), 'diag', colors(i,:), x_lim, y_lims(i,:), 'A');
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    set(gca,'FontSize',18) % stretch its width and height
    if i == length(conditions_A)
        set(gca,'XColor','k')
        set(gca, 'XTickLabel', [x_lim(1) 0:.4:x_lim(end)])
        xlabel('Time (s)')
    end
end
save2pdf([dec_res_dir_group 'decoding_' dec_method '_A.pdf'], gcf, 600)

% Timelock to C
figureDim = [0 0 .6/3.4 1*(5/8)];
figure('units','normalized','outerposition',figureDim)
x_lim = [-.2 .8];
for i=1:length(conditions_C)
    subplot(length(conditions_C),1,i)
    mvpaPlot(res.(dec_method).c.(conditions_C{i}), 'diag', colors(i,:), x_lim, y_lims(i,:), 'C');
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    set(gca,'FontSize',18) % stretch its width and height
    if i == length(conditions_A)
        set(gca,'XColor','k')
        set(gca, 'XTickLabel', [x_lim(1) 0:.4:x_lim(end)])
        xlabel('Time (s)')
    end
end
save2pdf([dec_res_dir_group 'decoding_' dec_method '_C.pdf'], gcf, 600)


% Timelock to RT
figureDim = [0 0 .6/3.4 1*(5/8)];
figure('units','normalized','outerposition',figureDim)
x_lim = [-.8 .1];
for i=1:length(conditions_RT)
    subplot(length(conditions_RT),1,i)
    y_lims(i,:) = mvpaPlot(res.(dec_method).rt.(conditions_RT{i}), 'diag', colors(i,:), x_lim, y_lims(i,:), 'RT');
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    set(gca,'FontSize',18) % stretch its width and height
    if i == length(conditions_A)
        set(gca,'XColor','k')
        set(gca, 'XTickLabel', [x_lim(1):.4:x_lim(end)])
        xlabel('Time (s)')
    end
end
save2pdf([dec_res_dir_group 'decoding_' dec_method '_RT.pdf'], gcf, 600)


%% GAT
gat_fields_plot = {'op1_op1', 'addsub_addsub', 'op2_op2', 'resultlock_pres_resultlock_pres'};
time_lock = {'a', 'a', 'a', 'c'};

event_st = [0 .8 1.6 0];
data_all = [];

for i = 1:length(gat_fields_plot)
    data_plot = res.(dec_method).(time_lock{i}).(gat_fields_plot{i});

    chance = double(data_plot.chance);    
    
    data_sig = squeeze(data_plot.p_values_gat);
    data = squeeze(data_plot.group_scores);
    data(data_sig>0.05 | data<chance) = nan;

    % Crop data
    windown = 0.8;
    time_start = [(abs(res2.times(1))+event_st(i))*sfreq];
    time_crop = time_start:time_start+abs(res2.times(1))+windown*sfreq;
    data = data(time_crop,time_crop);
    data = (data-chance)/chance;

    %% Append data
    data_all = [data_all, data];
end

figureDim = [0 0 .6 .35];
figure('units','normalized','outerposition',figureDim)

imagesc(data_all)
set(gca,'YDir','normal')
colormap(viridis_white)

set(gca, 'XTick', 0:50:400);
set(gca, 'XTickLabel', 0:0.4:4);
set(gca, 'YTick', 0:50:100);
set(gca, 'YTickLabel', 0:0.4:1);
set(gca, 'FontSize', 20);
xlabel('Test times (s)')
ylabel('Train times (s)')
colorbar 

save2pdf([dec_res_dir_group 'decoding_gat_full.pdf'], gcf, 600)


%% Calculate RSA - single or multiple regression
operation = 'calc';
timesphere = 2;
single_or_mr = 'mr';

for subj = 1:length(sub_name_all)
    % Load data and convert to cosmo
    load([data_dir sub_name_all{subj} '_calc_lp30.mat']) % lp30
    % Select trials
    data = filterData(data, operation);
    % Crop data
    [~, data] = timelock(data, sub_name_all{subj}, 'A');
    % Downsample data
    data = calc_downsample(data, 125);
    % Scaler - z-score channels to put mag and grad in the same scale
%     data = calc_scaler(data);
    % Convert to cosmo MVPA
    data_cosmo = calcConvertCOSMO(data);
    % Organize trialinfo and leave only the stim field
    [stim, stimfull] = cosmoOrganizeTrialInfo(data_cosmo.sa);
    % Select only the calculation trials
    data_cosmo.sa = [];
    data_cosmo.sa.stim = stim';
    % Run RSA
    cosmoRSA(sub_name_all{subj}, data_cosmo, timesphere, operation, single_or_mr)
end

clear RSA_all
% Load all data MR
for p = 1:length(sub_name_all)
    load([rsa_result_dir 'RSA_all_DSM_mr_' operation '_tbin' num2str(timesphere) '_' sub_name_all{p} '.mat'])
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

% Load all data single regression
for p = 1:length(sub_name_all)
    load([rsa_result_dir 'RSA_all_DSM_' operation '_tbin' num2str(timesphere) '_' sub_name_all{p} '.mat'])
    fieldnames_RSA = fieldnames(RSA);
    for f = 1:length(fieldnames_RSA);
        RSA_all.(operation).(fieldnames_RSA{f}){p}=RSA.(fieldnames_RSA{f});
    end
end

% Calculate stats
for f = 1:length(fieldnames_RSA);
    RSAstats(RSA_all.(operation).(fieldnames_RSA{f}), [operation '_' fieldnames_RSA{f}])
end

%% Plot results - MR
fieldnames_RSA = {'op1_vis' 'op1_mag' 'operator' 'op2_vis' 'op2_mag' 'result_vis' 'result_mag'};
% fieldnames_RSA = {'op1_vis_noZero' 'op1_mag_noZero' 'operator_noZero' 'op2_vis_noZero' 'op2_mag_noZero' 'result_vis_noZero' 'result_mag_noZero'};
colors = viridis(length(fieldnames_RSA)); % Or substitute it with 8

% Predefine some y_lim
y_lims = zeros(length(conditions_A),2,1);

% Timelock to A
figureDim = [0 0 .6 1*7/8];
figure('units','normalized','outerposition',figureDim)
x_lim = [-.2 3.2];
for i=1:length(fieldnames_RSA)
    load([rsa_result_dir 'group_rsa_mr/RSA_stats_model_', [operation '_' fieldnames_RSA{i}], '_all_DSM_MR.mat'], 'RSAres');
    subplot(length(fieldnames_RSA),1,i)  
    y_lims(i,:) = mvpaPlot(RSAres, 'RSA', colors(i,:), x_lim, y_lims(i,:), 'A');
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    set(gca,'FontSize',18) % stretch its width and height
    if i == length(fieldnames_RSA)
        set(gca,'XColor','k')
        set(gca, 'XTickLabel', [x_lim(1) 0:.4:x_lim(end)])
        xlabel('Time (s)')
    end
end
save2pdf([rsa_result_dir 'plots/calc_RSA_mr.pdf'], gcf, 600)


%% Plot correspondent matrices
load([rsa_result_dir 'stim_matrices/calc_RDM_matrices.mat'], 'RDM', 'allop')

fieldnames_RSA_plot = {'op1_vis' 'op1_mag' 'operator' 'op2_vis' 'op2_mag' 'result_vis' 'result_mag'};
colors_RSA_plot = {'RdPu' 'Greys' 'Oranges' 'Greys' 'BuGn' 'Greys' 'Greys'};

figureDim = [0 0 1*7/8 .3];
figure('units','normalized','outerposition',figureDim)
for s = 1:length(fieldnames_RSA_plot)
    subplot(1,length(fieldnames_RSA_plot),s)
%     subplot(length(fieldnames_RSA_plot),1,s)
    imagesc(RDM.(fieldnames_RSA_plot{s}))
%     title(fieldnames_RDM{s}, 'interpreter', 'none')
    axis square
    set(gca,'XTick',1:1:32)
    set(gca,'XTickLabel','');
    set(gca,'XaxisLocation','top')
    %set(gca,'XTickLabelRotation',-90)
    set(gca,'YTick',1:1:32)
    set(gca,'YTickLabel','');
%     set(gca,'YTickLabel',[], 'XTickLabel', []);
    %colorbar('YTickLabel',[]);
    colormap(viridis)
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1.2 1]) % stretch its width and height
end
save2pdf([rsa_result_dir 'plots/RDM_matrices.pdf'], gcf, 600)

% Plot colorbar matrices
colorbar('Location','South')
colormap(viridis)
set(gca,'FontSize', 20)
save2pdf([rsa_result_dir 'plots/RDM_matrices_colorbar.pdf'], gcf, 600)


%% Plot colorbar matrices
colorbar('Location','South')
colormap(viridis)
set(gca,'FontSize', 20)
save2pdf([rsa_result_dir 'plots/RDM_matrices_colorbar.pdf'], gcf, 600)


%% Plot results - single regression
fieldnames_RSA = {'op1_mag' 'op2_mag' 'op1_vis' 'op2_vis' 'op1_magregop1_vis' 'op2_magregop2_vis' 'op1_visregop1_mag' 'op2_visregop2_mag'};
fieldnames_RSA = {'op1_vis' 'op1_mag' 'op1_magregop1_vis' 'op1_visregop1_mag'};
fieldnames_RSA = {'op2_vis' 'op2_mag' 'op2_magregop2_vis' 'op2_visregop2_mag'};
fieldnames_RSA = {'result_vis' 'result_mag' 'operator' 'result_mag_reg_operator'};

colors = viridis(length(fieldnames_RSA)); % Or substitute it with 8
% Predefine some y_lim
y_lims = zeros(length(fieldnames_RSA),2,1);
y_lims = repmat([-0.05 .18], length(fieldnames_RSA),1);

% Timelock to A
figureDim = [0 0 .5 1*4/8];
figure('units','normalized','outerposition',figureDim)
x_lim = [-.2 3.2];
for i=1:length(fieldnames_RSA)
    load([rsa_result_dir 'group_rsa/RSA_stats_model_', [operation '_' fieldnames_RSA{i}], '_all_DSM.mat'], 'RSAres');
    subplot(length(fieldnames_RSA),1,i)  
    y_lims(i,:) = mvpaPlot(RSAres, 'RSA', colors(i,:), x_lim, y_lims(i,:), 'A');
    sub_pos = get(gca,'position'); % get subplot axis position
    set(gca,'position',sub_pos.*[1 1 1 1.3]) % stretch its width and height
    set(gca,'FontSize',18) % stretch its width and height
    if i == length(fieldnames_RSA)
        set(gca,'XColor','k')
        set(gca, 'XTickLabel', [x_lim(1) 0:.4:x_lim(end)])
        xlabel('Time (s)')
    end
end
save2pdf([rsa_result_dir 'plots/calc_RSA_mr_op2.pdf'], gcf, 600)


%% Plot empty matrix
figureDim = [0 0 .5 .5];
figure('units','normalized','outerposition',figureDim)
imagesc(zeros(32))
axis square
set(gca,'XTick',1:1:32)
set(gca,'XTickLabel',allop);
set(gca,'XaxisLocation','top')
set(gca,'XTickLabelRotation',-90)
set(gca,'YTick',1:1:32)
set(gca,'YTickLabel',allop);
colormap(viridis_white)
set(gca,'FontSize', 10)
grid on

save2pdf([rsa_result_dir 'plots/RDM_matrices_blanc.pdf'], gcf, 600)

%% Correlate RDM matrices
% Vectorize and zscore matrices
fieldnames_RDM = fieldnames(RDM);
RDM_vector = [];
for i = 1:7
    matrix_tmp = RDM.(fieldnames_RDM{i})+0.0001;
    RDM_vector(:,i) = matrix_tmp(find(triu(matrix_tmp, 1)));
end

c = cosmo_corr(RDM_vector, 'Spearman');
imagesc(c);
colormap(viridis);
set(gca, 'XTickLabel', fieldnames_RDM(1:7), 'TickLabelInterpreter', 'none')
set(gca,'XaxisLocation','top')
set(gca, 'YTickLabel', fieldnames_RDM(1:7))



%% Cosmo decoding time-frequency-space searchlight LDA
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operand1', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operand2', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operator', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'corrResult', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'corrResultnoZero', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'presResult', 'low', 10, 1, 1, 5);


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





% Load all data from all subjects (needs at least 30 gb free in disk space)
% for subj = 1:length(sub_name)
%     load([data_dir sub_name{subj} '_calc.mat'])
%     data.trialinfoCustom = data.trialinfo;
%     data.trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
%     dataAll.(sub_name{subj}) = data;
%     clear data
% end
% 
% cfg = []
% [data_timelock] = ft_timelockanalysis(cfg, data)
% cfg.layout    = 'neuromag306mag.lay'; % specify the layout file that should be used for plotting
% cfg.xlim = [0 .02];
% 
% ft_topoplotER(cfg, data_timelock)

