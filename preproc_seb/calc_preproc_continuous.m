function [par data_cont] = calc_preproc_continuous(par, dataset)

% first get continuous data
cfg = [];
cfg.trialfun = 'ft_trialfun_general';
cfg.headerformat        = 'neuromag_mne';
cfg.dataformat          = 'neuromag_mne';
cfg.dataset = dataset;
cfg.trialdef.triallength = Inf;
cfg.trialdef.ntrials = 1;

cfg = ft_definetrial(cfg);
data_cont = ft_preprocessing(cfg);

% 
% % keep eye movements and cardiac
% ECGEOG=data.trial;
% idxEOGECG = [find(strcmp('EOG061', data.label)), ...
%     find(strcmp('EOG062', data.label)), ...
%     find(strcmp('ECG063', data.label))];
% for tmp=1:length(ECGEOG)
%     ECGEOG{tmp}=ECGEOG{tmp}(idxEOGECG,:);
% end
% 
% % keep STI101
% STI=data.trial;
% idxSTI = find(strcmp('STI101', data.label));
% for tmp=1:length(STI)
%     STI{tmp}=STI{tmp}(idxSTI,:);
% end
% 
% cfg.channel = {'MEG*' 'E*'};
% % cfg.reref = 'yes'; % re-reference EEG on the average
% % cfg.refchannel = 'all';
% 
% % % remove beginning and end of recording because of subject's movements.
% % param = [];
% % begsample = cfg.event(1).sample-4000;
% % endsample = cfg.event(end).sample+5000;
% % begtime = data.time{1}(begsample);
% % endtime = data.time{1}(endsample);
% % param.latency = [begtime endtime];
% % data = ft_selectdata_new(param, data);
% 
% % correct bad channels in EEG data. MEG bad channels are supposed to be
% % corrected by maxfilter.
% load SensorClassification
% par.artifact.EEGbad_ch = getBadChannels(data);
% data = repairBadChannels(par.artifact.EEGbad_ch, data);
% data = ft_preprocessing(cfg, data);
% disp('Re-referencing EEG on the average');
% eeg1 = strmatch('EEG001', data.label);
% data.trial{1}(eeg1:eeg1+60,:) = ft_preproc_rereference(data.trial{1}(eeg1:eeg1+60,:));
% data.ECGEOG{1} = ECGEOG{1}(:,data.sampleinfo(1):data.sampleinfo(2));
% data.STI{1} = STI{1}(1,data.sampleinfo(1):data.sampleinfo(2));
% 
% function bad_ch = getBadChannels(data)
% 
% % Use the browser to reject channels
% cfg=[];
% cfg.latency = [1 60];
% tmp_data = ft_selectdata_new(cfg, data);
% clear data
% cfg = [];
% cfg.channel = {'EEG*'};
% cfg.method = 'trial';
% all_ch = tmp_data.label;
% tmp_data = ft_rejectvisual(cfg,tmp_data); 
% 
% % Find which channels were removed
% bad_ch = {};
% for ch = 307:366 % takes only EEG
%     if sum(strcmp(all_ch{ch},tmp_data.label)) == 0
%         bad_ch{end+1} = all_ch{ch}; %#ok<AGROW>
%     end
% end
% 
% function data = repairBadChannels(bad_ch, data)
% 
% % First, specify the neighbors using the layout
% cfg = [];
% cfg.method = 'distance';
% cfg.neighbourdist = 4;
% 
% % add electrode positions information from the lay file because EGI is not directly supported by ft_repairchannel
% % cfg.elec = ft_read_sens('easycap64ch-avg.lay'); 
% cfg.feedback = 'no';
% neighbours = ft_prepare_neighbours(cfg, data);
% 
% 
% % Now, repair the bad channels
% cfg = [];
% cfg.method = 'nearest'; % 'nearest', 'spline' or 'slap' 
% cfg.badchannel = bad_ch;
% cfg.neighbours = neighbours;
% % cfg.elec = ft_read_sens('easycap64ch-avg_seb.lay');
% data = ft_channelrepair(cfg, data);

end

