function addRefChannelBSTfolder(subject)

%% Initialize dirs
addPathInitDirsMEGcalc
data_sss_dir
bst_db_data_dir
%% Star brainstorm without a GUI
brainstorm nogui;
%Define the directory where brainstorm's database is stored
bst_set('BrainstormDbDir', [bst_db_dir]);
%Get study
[sStudy, iStudy] = bst_get('Study');
bst_db_data_dir = [bst_db_dir 'data/']; %dir bst data
%% Import channel file and modify it
ChannelFile = [data_sss_dir subject '/calc1_sss.fif'];
ChannelMat = import_channel([], ChannelFile, 'FIF', [], []);
ChannelMat.Channel = ChannelMat.Channel(1 : 306);
ChannelMat.Comment = 'Neuromag channels (400) -- modified by PPC for MEG only';

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
         
save([bst_db_data_dir subject '/@default_study/channel_vectorview306_acc1.mat'], 'Comment', 'MegRefCoef', 'Projector', 'TransfMeg', ...
    'TransfMegLabels', 'TransfEeg', 'TransfEegLabels', 'HeadPoints', 'Channel', 'History', 'SCS');

ChannelMat = channel_align_auto([bst_db_data_dir subject '/@default_study/channel_vectorview306_acc1.mat'], ChannelMat, 0, 1);

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


end

