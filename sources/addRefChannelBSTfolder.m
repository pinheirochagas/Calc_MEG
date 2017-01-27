function addRefChannelBSTfolder(subjects)

%% Initialize dirs
addPathInitDirsMEGcalc

%% Star brainstorm without a GUI
%Get study

for s = 1:length(subjects)
    %% Import channel file and modify it
    subject = subjects{s}
    ChannelFile = [data_sss_dir subject '/calc1_sss.fif'];
    ChannelMat = import_channel([], ChannelFile, 'FIF', [], []);
    ChannelMat.Channel = ChannelMat.Channel(1 : 306);
    ChannelMat.Comment = 'Neuromag channels';
    
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
end

end

