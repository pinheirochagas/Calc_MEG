function stat=ns_wsstat_cmb(tr1,tr2,lat)
% stat=ns_wsstat(tr1,tr2,av1,av2,lat,timepoints)
% Computes ERF statistical analysis between two conditions, separately for
% each sensor group. Uses ns_wscra (wscra=within-subjects cluster
% randomization analysis) which is based on ft_timelockstatistics.
% For extended info on the method: 
% type help ft_timelockstatistics and help statistics_montecarlo 
% or look at http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock
%
% Input:
% tr1(tr2) = grand-averaged dataset for condition 1(2) containing all the
% trials (from ft_timelockgrandaverage)
% lat = temporal latency over which statistical analysis is computed (in seconds)
% (example: lat=[0 0.4])
%
% Output:
% stat = cell containing statistics for each of the three groups of
% sensors.

sensors={'mag','grad_cmb'};

% statlabel=[condition{1} 'vs' condition{2}];
for s=1:length(sensors)
    stat{s} = ns_wscra(tr1,tr2,sensors{s},lat);
end;
disp('  ');
disp('%% stats for MAG sensors %%')
ns_statinfo(stat{1});
disp('  ');
disp('%% stats for GRAD_CMB sensors %%')
ns_statinfo(stat{2});