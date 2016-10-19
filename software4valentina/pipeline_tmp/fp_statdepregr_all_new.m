function stat=fp_statdepregr_all(lat,varargin)

% Example: stat=fp_statdepregr_all([0 0.5],data1,data2,data3,data4)

% Computes statistical analysis of regression among ERFs belonging to length(varargin conditions, separately for
% each sensor group. Uses fp_statdepregr (within-subjects regression analysis) which is based on ft_timelockstatistics.
% For extended info on the method: 
% type help ft_timelockstatistics and help statistics_montecarlo 
% or look at http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock
%
% Input:
% data1,data2,data3,data4,... = averaged dataset for condition 1,2,3,4,...
% containing all the subjects
% (from ft_timelockanalysis)
% lat = temporal latency over which statistical analysis is computed (in seconds)
% (example: lat=[0 0.4])
%
% Output:
% stat = cell containing statistics for each of the three groups of
% sensors.
%
% Author: Marco Buiatti, 2015

sensors={'mag','grad1','grad2'};

%% compute statistics for each sensor type %%
for s=1:length(sensors)
    stat{s} = fp_statdepregr(sensors{s},lat,varargin{:});
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