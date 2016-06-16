function data=bst2ft_old(cond)
% general parameters
% taken from a fieldtrip pipeline dataset
% load('D:\Documents and Settings\mbuiatti\Mes documents\FromOmega\software\brainstorm\bst_scripts\bst2ft_default');
load('/neurospin/meg/meg_tmp/BilatNum_Marco_2010/analysis/brainstorm/bst_scripts/bst2ft_default');
data.label=label;
data.dimord=dimord;
data.grad=grad;

% TO INSERT:
% to check if it's bad:
% Events =   label: 'BAD'

% data and time
% subj_dir=['D:\Documents and Settings\mbuiatti\Mes documents\FromOmega\projects\bilatnum\test_s10\single_trials\'];
subj_dir=['/neurospin/meg/meg_tmp/BilatNum_Marco_2010/analysis/brainstorm/bst_data/data/s10/'];
cond=num2str(cond);
dircont=dir([subj_dir cond]);
% load BadTrials
load([subj_dir cond '/brainstormstudy']);
i=1;
% load only trials that are not bad. Skips first four rows (.,..,brainstormstudy.mat,channel_vectorview306.mat).
for tr=5:length(dircont)
    if ~any(strcmp(dircont(tr).name,BadTrials))
        load([subj_dir cond '/' dircont(tr).name]);
        trial(:,:,i)=F(1:306,:);
        i=i+1;
    else
        disp(['trial ' dircont(tr).name ' has been rejected']);
    end;
end;
data.time=Time;
data.trial=permute(trial,[3 1 2]);
data.avg=mean(trial,3);
% data.var=var(trial,0,3);

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





