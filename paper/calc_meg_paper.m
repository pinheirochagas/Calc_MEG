%% Pipeline for the Calc_MEG paper

%% Set paths and directories
AddPathsMEGcalc
InitDirsMEGcalc

%% List subjects
subs = {'s01','s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15', ...
        's16','s17','s18','s19','s21','s22'};
    
%% Behavior analysis
behAnalysisCalcMEG(subs)
    
%% ERF
    % Load all data from all subjects (needs at least 30 gb free in disk space)
for sub = 1:length(subs)
    load([datapath subs{sub} '_calc.mat'])
    data.trialinfoCustom = data.trialinfo; 
    data.trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    dataAll.(subs{sub}) = data;
    clear data
end

%% Sources



%% Time-frequency
for i = length(subs);
    load([data_dir, subs{2}, '_calc_AICA.mat'])
    [TFR, trialinfo] = ftTFAlow(data);
    save([tfa_data_dir, subs{1}, '_TFA_low.mat'],'TFR','trialinfo','-v7.3');
    [TFR, trialinfo] = ftTFAhigh(data);
    save([tfa_data_dir, subs{1}, '_TFA_high.mat'],'TFR','trialinfo','-v7.3');
end

%% Univariate analyses
savePNG(gcf,200, ['/neurospin/meg/meg_tmp/Calculation_Pedro_2014/results/sources/' 'test1.png'])




