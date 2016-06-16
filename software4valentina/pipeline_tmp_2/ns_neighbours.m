function neighbours=ns_neighbours(tl)
% Marco Buiatti, 2013
% compute neighbours of magnetometers (they will be equally valid for
% gradiometers)
% tl=the output of ft_timelockanalysis or ft_timelockgrandaverage from any neuromag dataset
% select mag channels only
% Mag2=labels from /neurospin/meg_tmp/tools_tmp/pipeline/SensorClassification.mat
load('/neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline/SensorClassification.mat');
tl = ft_selectdata(tl,'channel',Mag2);
% remove 'grad' field since it contains channel positions of all 306 channels.
% Forces the program to get positions from the layout.
tl=rmfield(tl,'grad');
cfg = [];
cfg.layout = 'neuromag306mag.lay';
% cfg.neighbourdist = 0.2;
cfg.neighbourdist = 0.3;
cfg.feedback = 'yes'; % if you select 'yes', neighbours for each sensor will be plotted one after the other
cfg.method        = 'distance';
neighbours = ft_neighbourselection(cfg, tl);
