function stat=ns_statdepf_all(data1,data2,data3,data4,lat)
% stat=ns_stat(tr1,tr2,av1,av2,lat,timepoints)
% Computes statistical analysis of regression among ERFs belonging to 4 conditions, separately for
% each sensor group. Uses ns_statindepregr (between-trials regression analysis) which is based on ft_timelockstatistics.
% For extended info on the method: 
% type help ft_timelockstatistics and help statistics_montecarlo 
% or look at http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock
%
% Input:
% data1,data2,data3,data4 = averaged dataset for condition 1,2,3,4 containing all the trials
% (from ft_timelockanalysis)
% lat = temporal latency over which statistical analysis is computed (in seconds)
% (example: lat=[0 0.4])
%
% Output:
% stat = cell containing statistics for each of the three groups of
% sensors.

sensors={'mag','grad1','grad2'};

%% compute statistics for each sensor type %%
for s=1:length(sensors)
    stat{s} = ns_statdepf(data1,data2,data3,data4,sensors{s},lat);
end;

%% visualize results for each sensor type %%
disp('  ');
disp('%% stats for MAG sensors %%')
ns_statinfo(stat{1});
disp('  ');
disp('%% stats for GRAD1 sensors %%')
ns_statinfo(stat{2});
disp('  ');
disp('%% stats for GRAD2 sensors %%')
ns_statinfo(stat{3});