%% Pipeline for the Calc_MEG paper

%% Set paths and directories
AddPathsMEGcalc
InitDirsMEGcalc

%%  List subjects
sub_name = {'s01','s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15', ...
        's16','s17','s18','s19','s21','s22'};
    
sub_name = {'s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15', ...
        's16','s17','s18','s19','s21','s22'};    
%% Behavior analysis
behAnalysisCalcMEG(subs)
    
%% ERF
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

%% Cosmo time-frequency-space searchlight 
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


operand1 = load([searchlight_result_dir 'searchlight_ft_allsub_operand1_lda_ch10_tbin1_frbin1_low_freq.mat'])
operand2 = load([searchlight_result_dir 'searchlight_ft_allsub_operand2_lda_ch10_tbin1_frbin1_low_freq.mat'])
corrResult = load([searchlight_result_dir 'searchlight_ft_allsub_corrResult_lda_ch10_tbin1_frbin1_low_freq.mat']) 
operator = load([searchlight_result_dir 'searchlight_ft_allsub_operator_lda_ch10_tbin1_frbin1_low_freq.mat']) 


operand1high = load([searchlight_result_dir 'searchlight_ft_allsub_operand1_lda_ch10_tbin1_frbin1_high_freq.mat'])



%% Explore TF analysis
% plot parameters

load([tfa_data_dir,'s08_TFA_low.mat'])
load([tfa_data_dir,'s08_TFA_high.mat'])

load SensorClassification;

cfg = [];
cfg.showlabels   = 'no';	
cfg.layout       = 'neuromag306all.lay'; %neuromag306all.lay neuromag306mag
% cfg.channel = Grad;
cfg.baseline = [-0.2 -0.02];
cfg.baselinetype = 'db';

TFRlow = TFR
TFRhigh = TFR


for i = length(sub_name);
    load([tfa_data_dir, sub_name{i}, '_TFA_low.mat'])
    ft_multiplotTFR(cfg, TFR);
    load([tfa_data_dir, sub_name{i}, '_TFA_high.mat'])
    ft_multiplotTFR(cfg, TFRhigh);
    
%% Test baseline correct cfg = [];
cfg = [];
cfg.baseline = [-0.2 -0.02];
cfg.baselinetype = 'db';
TFRbaseline = ft_freqbaseline(cfg, TFR);


figure(4)
ft_multiplotTFR(cfg, TFRbaseline);

%% 



% average frequencies of interest
cfg = [];
cfg.frequency = [1 15];
cfg.avgoverfreq = 'yes';
tmpA = ft_selectdata(cfg,operand1.searchlight_ft_allsub);
tmpA.avg = squeeze(tmpA.powspctrm);
tmpA.dimord = 'chan_time';
tmpA = rmfield(tmpA,{'powspctrm','freq'});
%plot
figure(2);


cfg = [];
% cfg.xlim=[0:0.05:1];
% cfg.zlim = [0.48 0.53];
cfg.layout       = 'neuromag306cmb.lay';
%cfg.comment = 'xlim';
%cfg.style = 'straight';
%cfg.commentpos = 'title';
data3 = ft_timelockanalysis(cfg, data2)

ft_topoplotER(cfg, data);
colormap(redblue)


%plot

figure(1);
cfg = [];
% cfg.xlim=[0.1:0.08:0.6];
cfg.zlim = [0.25 .30];
cfg.layout       = 'neuromag306cmb.lay';
cfg.comment = 'no';
cfg.style = 'straight';

h = subplot(1,5,4)
ft_topoplotER(cfg, tmpA);
colormap(cbrewer2('Reds'))


ft_multiplotTFR(cfg, corrResult.searchlight_ft_allsub);


p = get(h, 'pos');

p(1) = p(1) - .25; 

set(h, 'pos', p);

figureDim = [0 0 1 .45];

figure('units','normalized','outerposition',figureDim)


%% Cosmo simple decoding
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

%% RSA cosmo
for subj = 1:length(sub_name)
    % Load data and convert to cosmo
    load([data_dir sub_name{subj} '_calc_AICA.mat'])     
    % Convert to cosmo MVPA
    data_cosmo = calcConvertCOSMO(data);
    % Organize trialinfo and leave only the stim field
    [stim, stimfull] = comoOrganizeTrialInfo(data_cosmo.sa);
    % Select only the calculation trials
    data_cosmo.samples = data_cosmo.samples(data_cosmo.sa.operator ~= 0,:);
    stim = stim(data_cosmo.sa.operator ~= 0); 
    data_cosmo.sa = [];
    data_cosmo.sa.stim = stim';    
    % Run RSA
    cosmoRSA(sub_name{subj}, data_cosmo)
end


for p = 1:length(sub_name)
    load([rsa_result_dir 'RSA_cosmo_' sub_name{p} '.mat'])
    RSA_all{p}=RSA.op1;
end
    
    
end

