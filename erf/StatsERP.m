%Contrasts of interests:
%Target-present - Target-absent --> to check that there is indeed a
%difference between these two condtions
%Seen - 

function [stat, cond1, cond2] = StatsERP
load SensorClassification

%Define important variables
subnips = {'ab140235', 'ad120287', 'ar140056', 'cc140058', 'cf140251', 'eg140204', ...
    'el130086', 'lm130479', 'ma130185', 'ro130031', 'sa130042', 'sb120316', ...
    'th130177', 'ws140212'};

%Load average data for each subject for each condition & store it in two
%seperate variables
cond1 = {};
cond2 = {};

task1 = 'wm';
task2 = 'wm';
vis1 = 'seen';
vis2 = 'v1';
pos1 = 'present';
pos2 = 'present';
dis1 = 'all';
dis2 = 'all';
acc1 = 'all';
acc2 = 'all';

for subi = 1 : length(subnips)
    filename1 = ['Filtered_Avg_ERF_' subnips{subi} '_' task1 '_' vis1 '_' pos1 '_' dis1 '_' acc1 '.mat'];
    load(filename1);
    cond1{subi} = avgERF;
    
    filename2 = ['Filtered_Avg_ERF_' subnips{subi} '_' task2 '_' vis2 '_' pos2 '_' dis2 '_' acc2 '.mat'];
    load(filename2);
    cond2{subi} = avgERF;
end

%Prepare neighbours file (important: this should only be done for the mag)
% cfg = [];
% cfg.method = 'distance';
% cfg.neighbourdist = 4;
% %cfg.template = 'neuromag306_neighb.mat';
% cfg.layout = 'neuromag306all.lay';
% cfg.feedback = 'yes';
% cfg.channel = 'all';
% neighbours = ft_prepare_neighbours(cfg, cond1{1});

cfg = [];
cfg.method = 'template';
%cfg.neighbourdist = 4;
cfg.template = 'neuromag306mag_neighb.mat';
%cfg.layout = 'neuromag306all.lay';
%cfg.feedback = 'yes';
cfg.channel = Mag2;
neighbours = ft_prepare_neighbours(cfg, cond1{1});

% %Compute the permutation test
cfg = [];
cfg.channel = Mag2;
cfg.latency = [0.9 1.2]; %i.e., the time window in which we expect to observe the effects (beginning at target-presentation & extending for a second)

cfg.method = 'montecarlo';
cfg.statistic = 'depsamplesT';
cfg.correctm = 'cluster';
cfg.clusteralpha = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan = 2;
cfg.neighbours = neighbours;
cfg.tail = 0;
cfg.clustertail = 0;
cfg.alpha = 0.025;
cfg.numrandomization = 1000;

subj = 14;
design = zeros(2, 2 * subj);
for i = 1 : subj
    design(1, i) = i;
end
for i = 1 : subj
    design(1, subj + i) = i;
end
design(2, 1 : subj) = 1;
design(2, subj + 1 : 2 * subj) = 2;

cfg.design = design;
cfg.uvar = 1;
cfg.ivar = 2; 

[stat] = ft_timelockstatistics(cfg, cond1{:}, cond2{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Simply plot the significant p values
figure;

if isfield(stat, 'posclusterslabelmat') == 0 
   sig = zeros(102, length(stat.stat(1, :)));
elseif isempty(stat.negclusters)
   pos_cluster_pvals = [stat.posclusters(:).prob]; %make a vector of all p-values associated with the clusters from ft_timelockstatistics
   pos_signif_clust = find(pos_cluster_pvals < stat.cfg.alpha); %find which clusters are significant, outputting their indices as held in stat.posclusters
   pos = ismember(stat.posclusterslabelmat, pos_signif_clust); %make a boolean matrix of which (channel, time)-pairs are part of a significant cluster
   neg = [];
   sig = pos;
else
   pos_cluster_pvals = [stat.posclusters(:).prob]; %make a vector of all p-values associated with the clusters from ft_timelockstatistics
   pos_signif_clust = find(pos_cluster_pvals < stat.cfg.alpha); %find which clusters are significant, outputting their indices as held in stat.posclusters
   pos = ismember(stat.posclusterslabelmat, pos_signif_clust); %make a boolean matrix of which (channel, time)-pairs are part of a significant cluster
   neg_cluster_pvals = [stat.negclusters(:).prob];
   neg_signif_clust = find(neg_cluster_pvals < stat.cfg.alpha);
   neg = ismember(stat.negclusterslabelmat, neg_signif_clust);
   sig = pos + neg;
end

imagesc(sig);

%saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Darinka_2015/Darinka_ERF/Figures/Filtered_Significance_verylate_' task1 '_' vis1 '_' pos1 '_' dis1 '_' acc1 ...
    %'_' task2 '_' vis2 '_' pos2 '_' dis2 '_' acc2], 'png');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot topography of difference in conditions across time
%Calculate the grandaverage for each condition
cfg = [];

Avg1 = ft_timelockgrandaverage(cfg, cond1{:});
Avg2 = ft_timelockgrandaverage(cfg, cond2{:});

%Compute the difference
cfg = [];
cfg.operation = 'subtract';
cfg.parameter = 'avg';

diff = ft_math(cfg, Avg1, Avg2);
diff.avg = diff.avg(3:3:306,:);
diff.label = diff.label(3:3:306);

%Define parameters for plotting
timestep = 0.02; %timestep between time windows for each sublot (in seconds)
sampling_rate = 250; %I presume that this refers to the downsampled data already
sample_count = length(stat.time); %number of temporal samples in the statistics object
j1 = [0.9 : timestep : 1.2]; %temporal endpoints (in seconds) of the ERP average computed in each subplot
m1 = [1 : timestep*sampling_rate : sample_count]; %temporal endpoints in MEG samples

%Plot the difference
figure;

for k = 1 : 15
    subplot(3, 5, k);
    
    cfg = [];
    cfg.xlim = [j1(k) j1(k+1)];
    cfg.zlim = [-1.0e-13 1.0e-13];
    
    %Check which channels are significant over the entire time interval of
    %interest
    if ~isempty(pos)
        pos_int = all(pos(:, m1(k):m1(k+1)),2);
    else
        pos_int = [];
    end
    
    if ~isempty(neg)
        neg_int = all(neg(:, m1(k):m1(k+1)),2);
    else
        neg_int = [];
    end
    
    cfg.marker = 'off';
    cfg.highlight = 'on';
    if ~isempty(pos) && ~isempty(neg)
        cfg.highlightchannel = find(pos_int | neg_int);
    elseif ~isempty(pos) && isempty(neg)
        cfg.highlightchannel = find(pos_int);
    end
    cfg.comment = 'xlim';
    cfg.commentpos = 'title';
    cfg.layout = 'neuromag306mag.lay';
    
    ft_topoplotER(cfg, diff);
    
    title([num2str(cfg.xlim(1)*1000) ' - ' num2str(cfg.xlim(2)*1000) ' ms'], 'fontsize', 12, 'fontweight', 'bold');
end

% %Add colorbar to figure
% hp = get(subplot(3, 5, 15), 'Position');
% ch = colorbar('Position', [hp(1) + hp(3) + 0.02, hp(2) + 0.2*hp(2), 0.01, hp(2) + hp(3)]);

% ch = findall(gcf, 'tag', 'Colorbar')
% delete(ch)

%saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Darinka_2015/Darinka_ERF/Figures/Filtered_Topography_verylate7_' task1 '_' vis1 '_' pos1 '_' dis1 '_' acc1 ...
   % '_' task2 '_' vis2 '_' pos2 '_' dis2 '_' acc2], 'png');

%Plot the topoplot of condition 1 
Avg1.avg = Avg1.avg(3:3:306,:);
Avg1.label = Avg1.label(3:3:306);

figure;

for k = 1 : 15
    subplot(3, 5, k);
    
    cfg = [];
    cfg.xlim = [j1(k) j1(k+1)];
    cfg.zlim = [-2.0e-13 2.0e-13];   
    cfg.marker = 'off';
    cfg.comment = 'xlim';
    cfg.commentpos = 'title';
    cfg.layout = 'neuromag306mag.lay';
    
    ft_topoplotER(cfg, Avg1);
    
    title([num2str(cfg.xlim(1)*1000) ' - ' num2str(cfg.xlim(2)*1000) ' ms'], 'fontsize', 12, 'fontweight', 'bold');
end

% %Add colorbar to figure
% hp = get(subplot(2, 5, 15), 'Position');
% ch = colorbar('Position', [hp(1) + hp(3) + 0.02, hp(2) + 0.2*hp(2), 0.01, hp(2) + hp(3)]);

%saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Darinka_2015/Darinka_ERF/Figures/Filtered_Topography_verylate7_' task1 '_' vis1 '_' pos1 '_' dis1 '_' acc1], 'png');

%Plot the topoplot of condition 2 
Avg2.avg = Avg2.avg(3:3:306,:);
Avg2.label = Avg2.label(3:3:306);

figure;

for k = 1 : 15
    subplot(3, 5, k);
    
    cfg = [];
    cfg.xlim = [j1(k) j1(k+1)];
    cfg.zlim = [-2.0e-13 2.0e-13];   
    cfg.marker = 'off';
    cfg.comment = 'xlim';
    cfg.commentpos = 'title';
    cfg.layout = 'neuromag306mag.lay';
    
    ft_topoplotER(cfg, Avg2);
    
    title([num2str(cfg.xlim(1)*1000) ' - ' num2str(cfg.xlim(2)*1000) ' ms'], 'fontsize', 12, 'fontweight', 'bold');
end
% 
% %Add colorbar to figure
% hp = get(subplot(3, 5, 15), 'Position');
% ch = colorbar('Position', [hp(1) + hp(3) + 0.02, hp(2) + 0.2*hp(2), 0.01, hp(2) + hp(3)]);

%saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Darinka_2015/Darinka_ERF/Figures/Filtered_Topography_verylate7_' task2 '_' vis2 '_' pos2 '_' dis2 '_' acc2], 'png');

% %Plot the timecourse for the two conditions
% figure;
% 
% cfg = [];
% cfg.ylim = [-1e-13 1e-13];
% cfg.channel = 'MEG2141';
% 
% ft_singleplotER(cfg, Avg1, Avg2);
% legend('Avg1', 'Avg2');
% 
% saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Ojeda_2013/Darinka_Test/Figures/Filtered_Timecourse_MEG2141_' task1 '_' vis1 '_' pos1 '_' acc1 ...
%     task2 '_' vis2 '_' pos2 '_' acc2], 'png');
% 
% figure;
% 
% cfg = [];
% cfg.ylim = [-1e-13 1e-13];
% cfg.channel = 'MEG2131';
% 
% ft_singleplotER(cfg, Avg1, Avg2);
% legend('Avg1', 'Avg2');
% 
% saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Ojeda_2013/Darinka_Test/Figures/Filtered_Timecourse_MEG2131_' task1 '_' vis1 '_' pos1 '_' acc1 ...
%     task2 '_' vis2 '_' pos2 '_' acc2], 'png');
% 
% figure;
% 
% cfg = [];
% cfg.ylim = [-1e-13 1e-13];
% cfg.channel = 'MEG1741';
% 
% ft_singleplotER(cfg, Avg1, Avg2);
% legend('Avg1', 'Avg2');
% 
% saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Ojeda_2013/Darinka_Test/Figures/Filtered_Timecourse_MEG1741_' task1 '_' vis1 '_' pos1 '_' acc1 ...
%     task2 '_' vis2 '_' pos2 '_' acc2], 'png');
% 
% figure;
% 
% cfg = [];
% cfg.ylim = [-1e-13 1e-13];
% cfg.channel = 'MEG2121';
% 
% ft_singleplotER(cfg, Avg1, Avg2);
% legend('Avg1', 'Avg2');
% 
% saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Ojeda_2013/Darinka_Test/Figures/Filtered_Timecourse_MEG2121_' task1 '_' vis1 '_' pos1 '_' acc1 ...
%     task2 '_' vis2 '_' pos2 '_' acc2], 'png');
% 
% figure;
% 
% cfg = [];
% cfg.ylim = [-1e-13 1e-13];
% cfg.channel = 'MEG2541';
% 
% ft_singleplotER(cfg, Avg1, Avg2);
% legend('Avg1', 'Avg2');
% 
% saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Ojeda_2013/Darinka_Test/Figures/Filtered_Timecourse_MEG2541_' task1 '_' vis1 '_' pos1 '_' acc1 ...
%     task2 '_' vis2 '_' pos2 '_' acc2], 'png');
% 
% figure;
% 
% cfg = [];
% cfg.ylim = [-1e-13 1e-13];
% cfg.channel = 'MEG1931';
% 
% ft_singleplotER(cfg, Avg1, Avg2);
% legend('Avg1', 'Avg2');
% 
% saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Ojeda_2013/Darinka_Test/Figures/Filtered_Timecourse_MEG1931_' task1 '_' vis1 '_' pos1 '_' acc1 ...
%     task2 '_' vis2 '_' pos2 '_' acc2], 'png');
% 
% figure;
% 
% cfg = [];
% cfg.ylim = [-1e-13 1e-13];
% cfg.channel = 'MEG2331';
% 
% ft_singleplotER(cfg, Avg1, Avg2);
% legend('Avg1', 'Avg2');
% 
% saveas(gcf, ['/neurospin/meg/meg_tmp/WMP_Ojeda_2013/Darinka_Test/Figures/FilteredTimecourse_MEG2331_' task1 '_' vis1 '_' pos1 '_' acc1 ...
%     task2 '_' vis2 '_' pos2 '_' acc2], 'png');
end