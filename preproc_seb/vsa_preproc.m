
clear all

% matlab-R2014a 

%% Paths to be added
% addpath(genpath('/neurospin/meg/meg_tmp/WMP_Ojeda_2013/fieldtrip/'))
% addpath(genpath('/neurospin/unicog/protocols/intracranial/fieldtrip/'))

addpath('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/preproc_seb')
addpath('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/')

% listdir = dir('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/')
% for i=1:length(listdir)
%     listsub{i} = listdir(i).name;
% end
% listsub = listsub(3:end);
% 
% % for allsub=13:length(listsub)
% % clearvars -except trialsexcAll allsub listsub

%% Subject informations
par = [];
par.Sub_Num         = 's22';
% par.Sub_Num         = listsub{allsub};
par.srate = 1000; % sampling frequency in Hz
par.pathraw         = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/'; % Raw data 
par.pathmat         = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/'; % path for matlab files
par.pathsss         = ['/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/' par.Sub_Num '/']  ; % SSS Data 
par.pathbh          = ['/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/results/VSA/',par.Sub_Num, '/']; % Behavioral data 

% Name files for each run
for i = 1:4
%       par.rawfiles(i).name  = [par.Sub_Num,'_P_run',num2str(i),'.fif'];
        par.sssfiles(i).name = ['vsa',num2str(i),'_sss.fif'];
        par.bhfiles(i).name = [num2str(i) '_results.csv'];
end

% Define parameters
par.epoch = [.5 2]; % Prestimulus time window in seconds [- and +]
par.EventValue = [1 2]; % Trigger code to be analyzed
% par.maxfilter.origin(1) = 0; % these are default (and good) parameters
% par.maxfilter.origin(2) = 0;
% par.maxfilter.origin(3) = 40;
% par.maxfilter.badlimit  = 4; % limit for bad channels (in sd I think...)
% par.maxfilter.runref = 1; % which run to align on.
% par.maxfilter.ds = 4; % downsampling ratio
par.filtering.lpf = 30; % low pass filter
par.filtering.hpf = []; % high pass filter
par.filtering.bsf = 50;
par.filtering.bsf_width = 1;
par.decomposition.method = 'fastica'; % pca, fastica, runica
par.decomposition.comp_num = 30; % number of componentes to be displayed
par.decomposition.epochblink = 0; % 1 if decompose on data timelocked to the artifact
par.decomposition.type_artifact = {'EOGv' 'EOGh' 'ECG'};

savename = [par.Sub_Num]; % Filename to save

% %% Run Maxfilter
% for i = 1:length(par.rawfiles)
%     input_file  = par.rawfiles(i).name;
%     output_file = par.sssfiles(i).name;
%     wmp_runMaxfilter(par, [par.pathraw input_file], [par.pathsss output_file]);
% end



%% epoch the data
for i = 1:1:length(par.sssfiles)
    [par, data_cont] = vsa_preproc_continuous(par, [par.pathsss par.sssfiles(i).name]); % correct bad EEG chan on continuous data and rereference on the average.    
    [epoch{i}, ECGEOG{i}, alltrigNew{i}] = vsa_definetrial(par, [par.pathsss par.sssfiles(i).name], [par.pathbh par.bhfiles(i).name], data_cont); % epoch the data
%     [epoch{i} ECGEOG{i}] = wmp_definetrial_v2(par, [par.pathsss par.sssfiles(i).name]); % epoch the data
end

% Check the number of excluded trials
for i=1:length(epoch)
    trialsexc(i) = 78-length(epoch{i}.trial);   
end
display([par.Sub_Num ': Number of excluded trials per run: ',num2str(trialsexc), ' - total: ' num2str(sum(trialsexc))])
% end


%%
% save([par.pathmat savename,'_AE.mat'], '-v7.3') 

% %% process triggers for each block
% % To correct the triggers potentially excluding spurious trials or events
% for i = 1:length(epoch)
%     [trialinfo(i)] = processTriggers( epoch{i}.triggers.trl,epoch{i}.triggers.alltrig);
% end


% Concatenate the runs MEG
data = []; 
cfg=[]; 
data = ft_appenddata(cfg, epoch{:}); % concatenate runs
trialTriggersAll = getTrialTriggers(epoch); % make sure to recover alltrigs from every trial 
% clear epoch

% Concatenate the runs behavior
trialinfo = integrate_behavior_dataVSA(alltrigNew);
merged = concatBehVSA(trialinfo); 

% Plugs the behavior data to the MEG data
data.trialinfo = merged;
data.triggers = trialTriggersAll; 

% Save 
clear epoch
save([par.pathmat par.Sub_Num,'_vsa_BR.mat'],'-v7.3')   % Save the structure in MAT file

%% reject bad trials
[par, data] = vsa_rejecttrials(par, data, 'summary');
% reject trials from ECGEOG
data.ECGEOG = cat(2, ECGEOG{:});
tmp = ones(length(data.ECGEOG), 1);
tmp(par.artifact.rejtrials)=0;
data.ECGEOG = data.ECGEOG(tmp==1);

%% Downsample to 250 Hz
dataECGEOG = data;
dataECGEOG.trial = data.ECGEOG;
dataECGEOG.label = {'EOG061' 'EOG062' 'ECG063'}'; 

data = calc_downsample(data);
dataECGEOG = calc_downsample(dataECGEOG);

data.ECGEOG = dataECGEOG.trial;

save([par.pathmat par.Sub_Num,'_vsa_BICA_downsample.mat'], 'data', 'par')   % Save the structure in MAT file

%% Run ICA
[par.artifact.rejcomp_run data] = wmp_decomposition(par, data); % decompose data and reject component.
save([par.pathmat par.Sub_Num,'_vsa_AICA.mat'], 'data', 'par')   % Save the structure in MAT file


% concatenate and reject bad trials from additional data
% data.triggers.trl = cat(1,epoch{1}.triggers.trl, epoch{2}.triggers.trl);
% data.triggers.alltrig = cat(1,epoch{1}.triggers.alltrig, epoch{2}.triggers.alltrig);

% %% remove trials with incomplete trigger information
% invalidTrials = isnan(data.trialinfo.condition.target);
% data.trial(invalidTrials) = [];
% data.time(invalidTrials) = [];
% data.ECGEOG(invalidTrials) = [];
% data.sampleinfo(invalidTrials) = [];
% data.trialinfo.condition.target(invalidTrials) = [];
% data.trialinfo.condition.distractor(invalidTrials) = [];
% data.trialinfo.condition.delay(invalidTrials) = [];
% data.trialinfo.behavior.visibility(invalidTrials) = [];
% data.trialinfo.behavior.position(invalidTrials) = [];
% save([par.pathmat savename,'_BF.mat'])   % Save the structure in MAT file


%% Low-pass Filter 
trialinfo = data.trialinfo;
triggers = data.trialinfo;
ECGEOG = data.ECGEOG; 
cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = 40;
data = ft_preprocessing(cfg, data);
data.trialinfo = trialinfo;
data.triggers = triggers;
data.ECGEOG = ECGEOG;

% Save data
data.par = par;
save([par.pathmat par.Sub_Num,'_vsa.mat'], 'data')   % Save the structure in MAT file
disp(['Processing Subject ' par.Sub_Num ': Done.']);
%%



%% POST Preprocessing in both CALC and VSA
% 1. correct the downsampling for the sampleinfo
% data.sampleinfo = data.sampleinfo/4

% 2. add correct vs. incorrect responses




















%% END! 
% 
% %% Average , save original and average
% cfg             = [];
% data.Avg     = ft_timelockanalysis(cfg, data);
% data.par = par;
% 
% % average EOG data
% for i=1:length(data.ECGEOG)
% eog1(i,:)=data.ECGEOG{i}(1,:);
% eog2(i,:)=data.ECGEOG{i}(2,:);
% end
% data.eog2Avg = mean(eog2);
% data.eog1Avg = mean(eog1);
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %% display
% % load([par.pathmat savename,'.mat']);
% 
% load SensorClassification
% % for chanselec = 3:
% %     switch chanselec
% %         case 1
% %             sensor = Grad2_1;
% %             sensorlabel = 'grad1';
% %             layout = 'neuromag306all.lay';
% %         case 2
% %             sensor = Grad2_2;
% %             sensorlabel = 'grad2';
% %             layout = 'neuromag306all.lay';
% %         case 3
%             sensor = Mag2;
%             sensorlabel = 'mag';
%             layout = 'neuromag306all.lay';
% %         case 4
% %             sensor = EEG;
% %             sensorlabel = 'eeg';
% %             layout='eeg_64_NM20884N.lay';
% %     end
%     figure
%     cfg = [];
%     cfg.showlabels = 'yes';
%     cfg.interactive = 'no';
%     cfg.xlim = [-0.5 2.5];
%     cfg.fontsize = 12;
%    cfg.channel = sensor;
%     cfg.layout = layout;
%     % cfg.layout='eeg_64_NM20884N.lay';
%     % cfg.baseline = [-0.2 0];
%     % cfg.trials = tmp1.Subject.response == 64;
% %         ft_multiplotER(cfg, data.Avg);
%     ft_multiplotER(cfg, grpdata.both.unseen{1},grpdata.both.seen{1}, grpdata.both.blank{1});
% %     ft_multiplotER(cfg, grpavg.both.unseen,grpavg.both.seen, grpavg.both.blank);
%     
%     %%
%     figure
%     for i = 1:5
%     gfp_seen = eeg_gfp(grpdata.wm.seen{i}.avg(1:306,:),0);
%     gfp_unseen = eeg_gfp(grpdata.wm.unseen{i}.avg(1:306,:),0);
%     subplot(2,3,i);
%     plot(grpavg.p.seen.time, gfp_seen, 'r'); hold;
%     plot(grpavg.p.seen.time, gfp_unseen, 'b');
%     end
%     
%     figure;
%     gfp_seen = eeg_gfp(grpavg.seen.avg(1:306,:),0);
%     gfp_unseen = eeg_gfp(grpavg.unseen.avg(1:306,:),0);
%      plot(grpavg.p.seen.time, gfp_seen, 'r'); hold;
%     plot(grpavg.p.seen.time, gfp_unseen, 'b');
% % end
% %%
% figure;
% plot(data.time{1},data.eog1Avg);
% figure;
% plot(data.time{1},data.eog2Avg);
% 
% figure
% channum = find(strcmp('EEG048', data.label));
% plot(data.time{1},data.Avg.avg(channum,:));
% 
% %% group average
% % first with all data
% path = '/neurospin/meg/meg_tmp/WMP_Ojeda_2013/data/cleansubjects/';
% subnips = {'ad120287','sa130042','sb120316','ro130031',};%'el130086'
% for i = 1:1%length(subnips)
%     load([path subnips{i} '.mat']);
% %     grpdata.all{i} = data.Avg;
%     selec = splitConditions(data);
% %     grpdata.p.all{i}= selec.p.all.Avg;
% %     grpdata.p.unseen{i} = selec.p.unseen.Avg;
% %     grpdata.p.seen{i} = selec.p.seen.Avg;
% %     grpdata.p.difference{i}= selec.p.difference;
% %     grpdata.p.blank{i} = selec.p.blank.Avg;
% %     
% %     grpdata.wm.all{i} = selec.wm.all.Avg;
% %     grpdata.wm.unseen{i} = selec.wm.unseen.Avg;   
% %     grpdata.wm.seen{i} = selec.wm.seen.Avg; 
% %     grpdata.wm.difference{i} = selec.wm.difference;
% %     grpdata.wm.blank{i} = selec.wm.blank.Avg;
% %     
% %     grpdata.both.seen{i} = selec.both.seen.Avg;
% %     grpdata.both.unseen{i} = selec.both.unseen.Avg;
% %     grpdata.both.difference{i} = selec.both.difference;
% %     grpdata.both.blank{i} = selec.both.blank.Avg;
% %     
%     
%     
% %     clear data selec
%     disp(num2str(i));
% end
% cfg = [];
% cfg.channel = '*';
% % cfg.keepindividual = 'yes';
% % grpavg.all = ft_timelockgrandaverage(cfg, grpdata.all{:});
% grpavg.p.all = ft_timelockgrandaverage(cfg, grpdata.p.all{:});
% grpavg.p.unseen = ft_timelockgrandaverage(cfg, grpdata.p.unseen{:});
% grpavg.p.seen = ft_timelockgrandaverage(cfg, grpdata.p.seen{:});
% grpavg.p.difference = ft_timelockgrandaverage(cfg, grpdata.p.difference{:});
% grpavg.p.blank = ft_timelockgrandaverage(cfg, grpdata.p.blank{:});
% 
% grpavg.wm.all = ft_timelockgrandaverage(cfg, grpdata.wm.all{:});
% grpavg.wm.unseen = ft_timelockgrandaverage(cfg, grpdata.wm.unseen{:});
% grpavg.wm.seen = ft_timelockgrandaverage(cfg, grpdata.wm.seen{:});
% grpavg.wm.difference = ft_timelockgrandaverage(cfg, grpdata.wm.difference{:});
% grpavg.wm.blank = ft_timelockgrandaverage(cfg, grpdata.wm.blank{:});
% 
% grpavg.both.unseen =  ft_timelockgrandaverage(cfg, grpdata.both.unseen{:});
% grpavg.both.seen =  ft_timelockgrandaverage(cfg, grpdata.both.seen{:});
% grpavg.both.difference = ft_timelockgrandaverage(cfg, grpdata.both.difference{:});
% grpavg.both.blank = ft_timelockgrandaverage(cfg,grpdata.both.blank{:});
% 
% 
% %% plot each subject
% path = '/neurospin/meg/meg_tmp/WMP_Ojeda_2013/data/cleansubjects/';
% subnips = {'ad120287','sa130042','sb120316','ro130031',};%'el130086'
% for i = 1:1%length(subnips)
%     load([path subnips{i} '.mat']);
%     selec = splitConditions(data);
%     coursetopos(selec,subnips{i})
%     clear data selec
%     disp(num2str(i));
% end
% 
% 
% %%  plot group average 
% coursetopos(grpavg,'group')
% 
% 
% %% other
% cfg = [];
% cfg.trials = 1;
% fakeepoch = ft_preprocessing(cfg, epoch{1});
% 
% cfg = [];
% 
% enlarged = ft_appenddata(cfg,fakeepoch,epoch{6})
