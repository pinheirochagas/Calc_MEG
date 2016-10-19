function [roi,tpeakreal,xclus]=bn_plotsinglecluster_depregr(stat,data1,data2,data3,data4,sensor,cluster,tshw)
% function [tp,t]=ns_plotsinglecluster(stat,av1,av2,sensor,cluster,tshw)
% plots cluster statistics time course, topography at the peak of cluster statistics and ERFs of single clusters
% computed with FT CRA.
% INPUT:
%
% stat = structure containing CRA stat for the three different sensor types
% (output of ns_btstat or ns_wsstat)
% av1(av2) = averaged data from ft_timelockanalysis or
% ft_timelockgrandaverage from which stat has been computed
% cluster = order of cluster to be plotted, e.g. 1 for first positive
% cluster, -2 for second negative cluster.
% tshw = time-smoothing half-width, in seconds, determines the half
% temporal window over which topographies are averaged around the latencies
% determined by cfg.lat (choose 0 for no smoothing)
%
% Marco Buiatti, INSERM Cognitive Neuroimaging Unit, Neurospin (2011).

if isfield(data1,'trial')
    av1=rmfield(data1,'trial'); av1.dimord='chan_time';
    av2=rmfield(data2,'trial'); av2.dimord='chan_time';
    av3=rmfield(data3,'trial'); av3.dimord='chan_time';
    av4=rmfield(data4,'trial'); av4.dimord='chan_time';
elseif isfield(data1,'individual')
    av1=rmfield(data1,'individual'); av1.dimord='chan_time';
    av2=rmfield(data2,'individual'); av2.dimord='chan_time';
    av3=rmfield(data3,'individual'); av3.dimord='chan_time';
    av4=rmfield(data4,'individual'); av4.dimord='chan_time';
else error('No trials or subjects in the data');
end;

% Retrieve cluster statistics time course, maximum peak and time, set of sensors of
% the selected cluster
stat=stat{sensor};
if cluster<0
    tp=mean((stat.negclusterslabelmat==abs(cluster)).*stat.stat,1);
    [peak,tpeak]=max(abs(tp));
    roi=find(stat.negclusterslabelmat(:,tpeak)==abs(cluster));
else
    tp=mean((stat.posclusterslabelmat==abs(cluster)).*stat.stat,1);
    [peak,tpeak]=max(abs(tp));
    roi=find(stat.posclusterslabelmat(:,tpeak)==abs(cluster));1
end;
t=stat.time;

% Plot cluster statistics time course
figure; 
set(gca,'Fontsize',14);
plot(t,tp,'b','Linewidth',2); 
axis tight;
xlabel('ms');
ylabel('cluster statistics');

% Display cluster coordinates on your command line
disp(['Max cluster statistics: ' num2str(peak) ' at time point ' num2str(tpeak) ' (' num2str(t(tpeak)) ' ms)']);

% Plot cluster topography at peak of cluster statistics
cfg             = [];
cfg.layout      = 'neuromag306mag.lay';
cfg.parameter   = 'avg';
cfg.lat         = [stat.time(tpeak)];
cfg.alpha       = 0.3; % threshold of cluster visualization
cfg.tshw        = tshw;
cfg.highlightsymbolseries = ['*','x','+','o','.'];  %for p < [0.01 0.05 0.1 0.2 0.3]
% cfg.highlightsymbolseries = ['o','o','o','x','x'];
cfg.highlightsizeseries = 6*[1 1 0.5 0.5 0.5];
sensors={'mag','grad1','grad2'};
ns_clusterplot_statregrsingle(cfg,stat,av1,av2,av3,av4,sensors{sensor});

% Plot ERFs of the two conditions averaged over the sensors belonging to
% the cluster
a=t(abs(tp)>0);
xclus=[a(1) a(end)];
ns_roierf_depregr(roi,[a(1) a(end)],av1,av2,av3,av4,sensors{sensor});

tpeakreal=t(tpeak);