function data=bst2ft(subj,cond)
% bst2ft() - Export Brainstorm data to Fieldtrip dataset.
%
% Usage:
% data=bst2ft(subj,cond);
% 
% Input:
% subj : [char] subject label 
% cond : [char] condition label
% Output:
% data : [struct] Fieldtrip dataset 
%
% Example:
% data=bst2ft('s03','dev0'); for subject 's03', condition label 'dev0'.
%
% Author: Marco Buiatti, 2013.

%% Sensor information for Elekta MEG data imported from a standard Fieldtrip dataset %%
load('C:\Users\valentina.borghesani\Desktop\software4valentina\bst2ft\bst2ft_default');
data.label=label;
data.dimord=dimord;
data.grad=grad;

%% Data import from Brainstorm to Fieldtrip %%
% Path definition
data_dir=['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\scripts\brainstorm\brainstorm_db\Semdim\data\'];

% get data bst structure
sStudy = bst_get('StudyWithCondition', [subj '/' cond]);

% get FileNames and Comments of all good trials, discarding the bad ones
isGoodTrial = ~[sStudy.Data.BadTrial];
FileNames = {sStudy.Data(isGoodTrial).FileName};
Comments = {sStudy.Data(isGoodTrial).Comment};

% get trials but averages (retrieved by the associated Comment)
i=1;
for tr=1:length(FileNames)
    if ~strcmp(Comments{tr}(1:3),'Avg')
    load([data_dir FileNames{tr}]);
        trial(:,:,i)=F(1:306,:);
        i=i+1;
    else
        disp(['trial ' FileNames{tr} ' not included because it is an average']);
    end;
end;
data.time=Time;
data.trial=permute(trial,[3 1 2]);
data.avg=mean(trial,3);
% data.var=var(trial,0,3);

% Example of typical Fieldtrip dataset structure:
%
% tr = 
%           avg: [306x1001 double]
%           var: [306x1001 double]
%          time: [1x1001 double]
%           dof: [306x1001 double]
%         label: {306x1 cell}
%         trial: [46x306x1001 double]
%        dimord: 'rpt_chan_time'
%          grad: [1x1 struct]
%     trialinfo: [46x1 double]
%           cfg: [1x1 struct]

% ndtr01 = 
%               F: [324x801 double]
%         Comment: '41 (#1)'
%     ChannelFlag: [324x1 double]
%            Time: [1x801 double]
%        DataType: 'recordings'
%          Device: 'Neuromag'
%            nAvg: 1
%          Events: [0x0 struct]
%         History: {3x3 cell}





