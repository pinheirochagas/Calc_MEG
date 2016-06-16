function [trl, alltrig, alltrigNew, hdr] = vsa_trialfun_neurospin(cfg, trigger_bh)

% TRIALFUN_NEUROSPIN  determines trials/segments in the data that are
% interesting for analysis, using the general event structure returned
% by read_event. This function is made for Neuromag data from Neurospin
% Floris de Lange,2008

% read the header and event information
hdr = read_header(cfg.dataset); 

% read trigger signal
if ischar(cfg.trialdef.channel)==1
    B = read_data(cfg.dataset, 'chanindx', strmatch(cfg.trialdef.channel,hdr.label,'exact'));
    disp('******** Loading triggers from data file ***********');
else
    B = cfg.trialdef.channel;
    disp('******** Using triggers from the TriggerCheck function *************');
end
B = abs(B); % because of negative triggers for the response in one of the buttons (to check)


% convert the trigger into an event with a value at a specific sample
% this detects the upward flank
for i=1:length(B)
    if i < length(B)
        x=[B(i) B(i+1)];
        B(i)=diff(x);
    end
    if B(i) < 0
       B(i) = 0;
    end
end
% figure
% plot(B)

% Correct events in the range of 32000 to be 32768 (left button press)
B(B>=32000 & B<33000) = 32768;

% check the triggers by counting the number of trials by condition
for i=unique(B)
    disp(['Number of trials for trigger ' num2str(i) ': ' num2str(length(find(B==i)))]);
end


% if two triggers are separated by less than 3 samples, there is a problem
X=zeros(2,length(B(B>0)));
X(1,:)=B(B>0);
X(2,:)=find(B>0);
for i=1:length(X(1,:))-1
    if (X(2,i+1) - X(2,i))<3 % number of samples
        disp(['Warning!!! Delay between triggers is < 3 ms! t = ' num2str(X(2,i))])
        B(1,X(2,i)) = X(1,i) + X(1,i+1);
        B(1,X(2,i+1)) = 0;
    end
end

% for i=1:length(unique(B))
%     disp(['Correction applied: Number of trials for trigger ' num2str(i) ': ' num2str(length(find(B==i)))]);
% end
triggers = [];
val = unique(B(B>0));
alltrig(:,1) = find(ismember(B, val));
alltrig(:,2) = B(ismember(B, val));

% Correct alltrig using the behavioral data
[alltrig, exctrials, alltrigNew] = correctAlltrigVSA(alltrig, trigger_bh);
display([num2str(exctrials), ' trials were excluded, because they did not match the behavior data'])

% if ~isfield(cfg.trialdef, 'eventvalue')
%     cfg.trialdef.eventvalue = val;
% end
% A=cell(length(cfg.trialdef.eventvalue),1);
% for i=1:length(cfg.trialdef.eventvalue)
%     A{i} = find(B == cfg.trialdef.eventvalue(i));
% end

if ~isfield(cfg.trialdef, 'eventvalue')
    cfg.trialdef.eventvalue = val;
end
A=cell(length(cfg.trialdef.eventvalue),1);
for i=1:length(cfg.trialdef.eventvalue)
    A{i} = alltrig(find(alltrig(:,2) == cfg.trialdef.eventvalue(i)),1)';
end

TrigSmp = [A{1:length(cfg.trialdef.eventvalue)}];


% determine the number of samples before and after the trigger
pretrig  = -cfg.trialdef.prestim  * hdr.Fs;
posttrig =  cfg.trialdef.poststim * hdr.Fs;

if isfield(cfg, 'photodelay')
    delay = cfg.photodelay * hdr.Fs;
else
    delay = 0;
end

% if isfield(cfg, 'sampleinfo')
%     sampledelay = cfg.sampleinfo(1); % corresponds to the delay we took out from the continuous file.
% else
%     sampledelay = 0;
% end

% put the information in a trl structure
trl_tmp = [];
for j = 1:length(TrigSmp)
    trlbegin = TrigSmp(j) + delay + pretrig;       
    trlend   = TrigSmp(j) + delay + posttrig;       
    offset   = pretrig;
    newtrl   = [trlbegin trlend offset B(j)];
    trl_tmp      = [trl_tmp; newtrl];
end


[time_order time_order_i] = sort(trl_tmp(:,1),'ascend');
trl = trl_tmp(time_order_i,:);