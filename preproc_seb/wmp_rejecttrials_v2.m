function [par dataout] = wmp_rejecttrials(par, datain, method)

% first reject bad trials
cfg                 =[];
cfg.channel         = 'all';
cfg.method          = method;
cfg.magscale        = 10;
cfg.megscale = 5e6;
% cfg.eegscale = 0;

% cfg.magscale        = 15;
% cfg.megscale = 7.5e6;

datatmp             = ft_rejectvisual(cfg, datain);

% then find the index of rejected trials
triallength = length(datain.time{1});
datain_info = zeros(length(datain.trial),2);
datain_info(1,:) = [1 triallength];
for i=2:length(datain.trial)
    datain_info(i,:) = datain_info(i-1,:)+triallength;
end
dataout_info = datatmp.sampleinfo;
clear y
y=~ismember(datain_info(:,1), dataout_info(:,1));

% clear x y
% x = diff(datatmp.sampleinfo(:,1))./triallength;
% y = zeros(length(datain.trial),1);
% 
% j=1;
% for i = 1:length(y)
%     if x(j) == 1
%         y(i) = 0;
%         j=j+1;
%     elseif x(j)>1
%         y(i+1) = 1;
%         x(j) = x(j)-1;
%         j=j;
%     end
% end

% reject bad trials 
rejected=find(y>0);
rejected=sort(rejected);
par.artifact.rejtrials = rejected;
datain.time = datain.time(y==0);
datain.trial = datain.trial(y==0);
datain.trialinfo.run = datain.trialinfo.run(y==0);
datain.trialinfo.operand1 = datain.trialinfo.operand1(y==0);
datain.trialinfo.operator = datain.trialinfo.operator(y==0);
datain.trialinfo.operand2 = datain.trialinfo.operand2(y==0);
datain.trialinfo.presResult = datain.trialinfo.presResult(y==0);
datain.trialinfo.delay = datain.trialinfo.delay(y==0);
datain.trialinfo.corrResult = datain.trialinfo.corrResult(y==0);
datain.trialinfo.deviant = datain.trialinfo.deviant(y==0);
datain.trialinfo.absdeviant = datain.trialinfo.absdeviant(y==0);
datain.trialinfo.rt = datain.trialinfo.rt(y==0);
datain.trialinfo.respSide = datain.trialinfo.respSide(y==0);

% 
% datain.trialinfo.condition.target = datain.trialinfo.condition.target(y==0);
% datain.trialinfo.condition.distractor =datain.trialinfo.condition.distractor(y==0);
% datain.trialinfo.condition.delay = datain.trialinfo.condition.delay(y==0);
% datain.trialinfo.behavior.visibility = datain.trialinfo.behavior.visibility(y==0);
% datain.trialinfo.behavior.position = datain.trialinfo.behavior.position(y==0);

% find bad channels and 
bad_ch = getBadChannels(datain, datatmp);
par.artifact.badchan = bad_ch;
dataout = repairBadChannels(bad_ch, datain);
dataout.trialinfo = datain.trialinfo;

% % re-reference the EEG on the average
% disp('Re-referencing EEG on the average');
% eeg1 = strmatch('EEG001', dataout.label);
% dataout.trial{1}(eeg1:eeg1+59,:) = ft_preproc_rereference(dataout.trial{1}(eeg1:eeg1+59,:));




function bad_ch = getBadChannels(datain, dataout)

% Use the browser to reject channels
% cfg=[];
% cfg.latency = [1 60];
% tmp_data = ft_selectdata_new(cfg, data);
% clear data
% cfg = [];
% cfg.channel = {'EEG*'};
% cfg.method = 'trial';
all_ch = datain.label;
% tmp_data = ft_rejectvisual(cfg,tmp_data);

% Find which channels were removed
bad_ch = {};
for ch = 1:366 
    if sum(strcmp(all_ch{ch},dataout.label)) == 0
        bad_ch{end+1} = all_ch{ch}; %#ok<AGROW>
    end
end

function data = repairBadChannels(bad_ch, data)

% data.elec = data.hdr.elec;
% cfg=[]; lay = ft_prepare_layout(cfg, data);

% First, specify the neighbors using the layout
cfg = [];
cfg.method = 'distance';
cfg.neighbourdist = 6;

% add electrode positions information from the lay file because EGI is not directly supported by ft_repairchannel
% cfg.elec = data.elec; 
cfg.feedback = 'no';
neighbours = ft_prepare_neighbours(cfg, data);


% Now, repair the bad channels
cfg = [];
cfg.method = 'nearest'; % 'nearest', 'spline' or 'slap' 
cfg.badchannel = bad_ch;
cfg.neighbours = neighbours;
% cfg.elec = data.hdr.elec; 
data = ft_channelrepair(cfg, data);

