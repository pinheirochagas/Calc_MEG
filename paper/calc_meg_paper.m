%% Pipeline for the Calc_MEG paper

%% Set paths and directories
AddPathsMEGcalc
InitDirsMEGcalc

%%  List subjects
sub_name = {'s01','s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15', ...
        's16','s17','s18','s19','s21','s22'};
    
%% Behavior analysis
behAnalysisCalcMEG(subs)
    
%% ERF
    % Load all data from all subjects (needs at least 30 gb free in disk space)
for subj = 1:length(sub_name)
    load([datapath sub_name{subj} '_calc.mat'])
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

searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operand1', 'high', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operand2', 'high', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'operator', 'high', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'corrResult', 'high', 10, 1, 1, 5);

searchlight_ft_allsub = cosmoSearchLight(sub_name, 'presResult', 'low', 10, 1, 1, 5);
searchlight_ft_allsub = cosmoSearchLight(sub_name, 'presResult', 'high', 10, 1, 1, 5);
 

%% Vizualize searchlight

load('/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/searchlight/searchlight_ft_allsub_operand2_lda_ch10_tbin1_frbin1_low_freq.mat')

cfg = [];
cfg.showlabels   = 'yes';	
cfg.layout       = 'neuromag306mag.lay';
figure 
ft_multiplotTFR(cfg, TFR);



%%
% average frequencies of interest
cfg = [];
cfg.frequency = [5 10];
cfg.latency = [1 1.2];
cfg.avgoverfreq = 'yes';
tmpA = ft_selectdata(cfg,searchlight_ft_allsub);
tmpA.avg = squeeze(tmpA.powspctrm);
tmpA.dimord = 'chan_time';
tmpA = rmfield(tmpA,{'powspctrm','freq'});


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


p = get(h, 'pos');

p(1) = p(1) - .25; 

set(h, 'pos', p);

figureDim = [0 0 1 .45];

figure('units','normalized','outerposition',figureDim)




