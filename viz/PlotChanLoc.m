function PlotChanLoc(chan)
% Plot empty layout highlighting a given sensor

load SensorClassification.mat;

% Prepare fake data
fakeData.avg = zeros(306,1);
fakeData.time = 1;
fakeData.label = All2;
fakeData.dimord='subj_chan_time';

%Plot
cfg = [];
cfg.zlim = [0 1];
cfg.comment = 'no';
cfg.marker = 'off';
cfg.style = 'straight';
cfg.layout = 'neuromag306all.lay';
cfg.colormap = [1 1 1];
cfg.colorbar = 'no';
cfg.highlight = 'on';
cfg.highlightchannel = chan;
cfg.highlightsymbol = '.';
cfg.highlightsize = 15;

ft_topoplotER(cfg, fakeData);
end