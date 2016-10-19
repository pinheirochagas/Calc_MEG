function [roi,tp]=ns_plotsinglecluster(stat,av1,av2,sensor,cluster,tshw)
% function [roi,tp,t]=ns_plotsinglecluster(stat,av1,av2,sensor,cluster,tshw)
% plots cluster statistics time course, topography at the peak of cluster statistics and ERFs of single clusters
% computed with FT CRA.
% 
% INPUT:
% stat = structure containing CRA stat for the three different sensor types
% (output of ns_btstat or ns_wsstat)
% av1(av2) = averaged data from ft_timelockanalysis or
% ft_timelockgrandaverage from which stat has been computed
% sensor =  selection of channel set. Options are 1 (magnetometers),
%           2 (first set of gradiometers), 3 (second set of gradiometers)
% cluster = order of cluster to be plotted, e.g. 1 for first positive
% cluster, -2 for second negative cluster.
% tshw = time-smoothing half-width, in seconds, determines the half
% temporal window over which topographies are averaged around the latencies
% determined by cfg.lat (choose 0 for no smoothing)
%
% OUTPUT:
% roi = list of the sensors of the selected cluster
% tp = temporal profile of the statistics of the cluster

% Marco Buiatti, INSERM Cognitive Neuroimaging Unit, Neurospin (2011).

% backward compatibility with old sensor label convention
if strcmp(av1.label{1},'0113')
    disp('Old label format: MEG suffix added for layout compatibility.');
    load /neurospin/meg/meg_tmp/tools_tmp/pipeline/SensorClassification.mat
    av1.label = All2';
    av2.label = All2';
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
    roi=find(stat.posclusterslabelmat(:,tpeak)==abs(cluster));
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
sensors={'mag','grad1','grad2'};
cfg.sensortype=sensors{sensor};
ns_clusterplot(cfg,stat,av1,av2);

% Plot ERFs of the two conditions averaged over the sensors belonging to
% the cluster
a=t(abs(tp)>0);
sm_roierf(roi,[a(1) a(end)],av1,av2,sensors{sensor})

