subject = 's01';



%% Import data from fieldtrip to brainstorm for source localization
% Adapted from: 
%Purpose: This script creates a subject in brainstorm and computes source
%localizations.
%Project: UnconWM
%Author: Darinka Truebutschek
%Date: 23 May 2016



%% Initialize directories
addPathInitDirsMEGcalc

%% Star brainstorm without a GUI
brainstorm nogui;

%Define the directory where brainstorm's database is stored
bst_set('BrainstormDbDir', bst_db_dir);

%Get study
[sStudy, iStudy] = bst_get('Study');



%% Import MEG recordigns
%Load subject's data
load([data_dir subject '_7SD_sss_rot.mat'], 'data'); %unfiltered data with correct timing
% And here I should add accuracy 

%Choose which condition to import
params = [];
tasklab = {'all', 'noRot', 'rot'};
vislab = {'all', 'v1', 'seen'};
poslab = {'all', 'present', 'absent'};
acc = {'all', 'correct', 'incorrect'};

pathToSubject = '/neurospin/meg/meg_tmp/MenRot_Truebutschek_2016/bst/MenRot/data'; %path to condition files

%% For each condition, save trial data following brainstorm's structure
for taski = 1 : length(tasklab)
    for visi = 1 : length(vislab)
        for posi = 1 : length(poslab)
            for acci = 1 : length(acc)
                params.tasklab = tasklab{taski};
                params.vislab = vislab{visi};
                params.poslab = poslab{posi};
                params.acc = acc{acci};

                ConditionName = [params.tasklab '_' params.vislab '_' params.poslab '_' params.acc];
                pathToCondition = [pathToSubject '/' subject '/' ConditionName];
                    
                selectTrl = find(calc_makeConditions(params, data));
                disp(length(selectTrl));
                    
                if ~isempty(selectTrl)
                    mkdir(pathToCondition); %create a folder in which the trial data will be saved
                    for triali = 1 : length(selectTrl)
                        NumTrl = num2str(triali);
                        if length(NumTrl) == 1
                            NumTrl = ['00' NumTrl];
                        else
                            NumTrl = ['0' NumTrl];
                        end
                            
                        %Set up brainstrom structure for single trials
                         F = data.trial{selectTrl(triali)};
                         Comment = [ConditionName ' (#' num2str(triali) ')'];
                         ChannelFlag = ones(306, 1); %needs to be adapted in case of EEG
                         Time = data.time{1}; %this works only if all trials have the same timing
                         DataType = 'recordings';
                         Device = 'Neuromag';
                         nAvg = 1;
                         Events = [];
                         History = [];
                            
                         %Save the structure in a mat file
                         save([pathToCondition '/' 'data_' ConditionName '_trial' NumTrl '.mat'], 'F', 'Comment', 'ChannelFlag', 'Time', 'DataType', 'Device', 'nAvg', 'Events', 'History');
                    end
                        
                     BadTrials = [];
                     DateOfStudy = date;
                     Name = ConditionName;
                     save([pathToCondition '/' 'brainstormstudy.mat'], 'BadTrials', 'DateOfStudy', 'Name');
                else
                     disp(['Skipping: ' 'bst_' subject '_' params.tasklab '_' params.vislab '_' params.poslab '_' params.acc '.mat']);
                end
            end
        end
    end
end


%% Import channel file and modify it
ChannelFile = ['neurospin/meg/meg_tmp/MenRot_Truebutschek_2016/Data/fif/menrot_' subject '_rot1_sss.fif'];
ChannelMat = import_channel([], ChannelFile, 'FIF', [], []);
ChannelMat.Channel = ChannelMat.Channel(1 : 306);
ChannelMat.Comment = 'Neuromag channels (400) -- modified by DT for MEG only';

%Format for brainstorm
Comment = ChannelMat.Comment;
MegRefCoef = ChannelMat.MegRefCoef;
Projector = ChannelMat.Projector;
TransfMeg = ChannelMat.TransfMeg;
TransfMegLabels = ChannelMat.TransfMegLabels;
TransfEeg = ChannelMat.TransfEeg;
TransfEegLabels = ChannelMat.TransfEegLabels;
HeadPoints = ChannelMat.HeadPoints;
Channel = ChannelMat.Channel;
History = ChannelMat.History;
SCS = ChannelMat.SCS;
         
save(['/neurospin/meg/meg_tmp/MenRot_Truebutschek_2016/bst/MenRot/data/' subject '/@intra/channel_vectorview306_acc1.mat'], 'Comment', 'MegRefCoef', 'Projector', 'TransfMeg', ...
    'TransfMegLabels', 'TransfEeg', 'TransfEegLabels', 'HeadPoints', 'Channel', 'History', 'SCS');

ChannelMat = channel_align_auto([subject '/@intra/channel_vectorview306_acc1.mat'], ChannelMat, 0, 1);

%Format again
Comment = ChannelMat.Comment;
MegRefCoef = ChannelMat.MegRefCoef;
Projector = ChannelMat.Projector;
TransfMeg = ChannelMat.TransfMeg;
TransfMegLabels = ChannelMat.TransfMegLabels;
TransfEeg = ChannelMat.TransfEeg;
TransfEegLabels = ChannelMat.TransfEegLabels;
HeadPoints = ChannelMat.HeadPoints;
Channel = ChannelMat.Channel;
History = ChannelMat.History;
SCS = ChannelMat.SCS;

save(['/neurospin/meg/meg_tmp/MenRot_Truebutschek_2016/bst/MenRot/data/' subject '/@intra/channel_vectorview306_acc1.mat'], 'Comment', 'MegRefCoef', 'Projector', 'TransfMeg', ...
    'TransfMegLabels', 'TransfEeg', 'TransfEegLabels', 'HeadPoints', 'Channel', 'History', 'SCS');

%Since channel positions are the same for all conditions, paste the channel
%file in all condition directories
for taski = 1 : length(tasklab)
    for visi = 1 : length(vislab)
        for posi = 1 : length(poslab)
            for acci = 1 : length(acc)

                ConditionName = [tasklab{taski} '_' vislab{visi} '_' poslab{posi} '_' acc{acci}];
                fileToCopy = ['/neurospin/meg/meg_tmp/MenRot_Truebutschek_2016/bst/MenRot/data/' subject '/@intra/channel_vectorview306_acc1.mat'];
                Destination = ['/neurospin/meg/meg_tmp/MenRot_Truebutschek_2016/bst/MenRot/data/' subject '/' ConditionName '/'];
                    
                if exist(Destination, 'dir')
                    mf_cmd = ['cp ' fileToCopy ' ' Destination];
                    system(mf_cmd)
                end
            end
        end
    end
end

return

%%
brainstorm stop