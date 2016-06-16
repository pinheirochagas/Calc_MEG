function stat = ns_wscra(tl1,tl2,channel,lat)
% function stat = ns_wscra(tl1,tl2,channel,lat) 
% computes *within-subjects* statistical difference between conditions 1 and 2 by cluster
% randomization analysis implemented in Fieldtrip. For extended info on the method: 
% type help ft_timelockstatistics and help statistics_montecarlo 
% or look at http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock
% 
% Input: 
% tl1(tl2) = time-locked dataset relative to condition 1(2) computed with ft_timelockanalysis 
%            (all trials must be included!)
% channel =  selection of channel set. Options are 'mag' (magnetometers),
%           'grad1' (first set of gradiometers), 'grad2' (second set of gradiometers) 
% lat  =    [begin end] in seconds or 'all': temporal latency in seconds over which statistical analysis is computed 
%           ('all' includes the whole trial time window).
%
% Output:
% stat = structure containing all the information about the spatiotemporal
% clusters on which the difference between the two conditions is
% statistically significant. Look at
% http://fieldtrip.fcdonders.nl/tutorial/cluster_permutation_timelock for
% details.
%
% Marco Buiatti, 2011-2015 

% select channels in the data

switch channel
    case 'mag'
        tl1 = ft_selectdata(tl1,'channel',tl1.typelabel.Mag2);
        tl2 = ft_selectdata(tl2,'channel',tl1.typelabel.Mag2);
    case 'grad1'
        tl1 = ft_selectdata(tl1,'channel',tl1.typelabel.Grad2_1);
        tl2 = ft_selectdata(tl2,'channel',tl1.typelabel.Grad2_1);
    case 'grad2'
        tl1 = ft_selectdata(tl1,'channel',tl1.typelabel.Grad2_2);
        tl2 = ft_selectdata(tl2,'channel',tl1.typelabel.Grad2_2);
    case 'grad_cmb'
        tl1 = ft_selectdata(tl1,'channel',tl1.typelabel.Grad2_cmb);
        tl2 = ft_selectdata(tl2,'channel',tl1.typelabel.Grad2_cmb);
    otherwise
        disp('Error: Incorrect channel selection!');
end;

% re-label channels to match the neighbour sensors configuration
tl1.label=tl1.typelabel.Mag2;
tl2.label=tl1.typelabel.Mag2;

% parameters of the statistical analysis
cfg = [];
cfg.method = 'montecarlo';       % use the Monte Carlo Method to calculate the significance probability
cfg.statistic = 'depsamplesT'; % use the dependent samples T-statistic as a measure to evaluate 
                                 % the effect at the sample level
cfg.correctm = 'cluster';
cfg.clusteralpha = 0.05;         % alpha level of the sample-specific test statistic that will be used for thresholding
cfg.clusterstatistic = 'maxsum'; % test statistic that will be evaluated under the permutation distribution. 
cfg.minnbchan = 2;               % minimum number of neighborhood channels that is required for a selected 
                                 % sample to be included in the clustering algorithm (default=0).
cfg.neighbours = tl1.neighbours;
                                 
cfg.tail = 0;                    % -1, 1 or 0 (default = 0); one-sided or two-sided test
cfg.clustertail = 0;
cfg.alpha = 0.025;               % alpha level of the permutation test
cfg.numrandomization = 100;      % number of draws from the permutation distribution

subj = size(tl1.individual,1);
design = zeros(2,2*subj);
for i = 1:subj
  design(1,i) = i;
end
for i = 1:subj
  design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design = design;             % design matrix
cfg.uvar  = 1;
cfg.ivar  = 2;

cfg.latency = lat;   % time interval over which the experimental 
                         % conditions must be compared (in seconds)

%compute the stat!
stat = ft_timelockstatistics(cfg, tl1, tl2);

%% display basic information on significant clusters %%
ns_statinfo(stat);