function stat=ns_statdepregr(data1,data2,data3,data4,channel,latency)
% performs cluster randomization analysis 
% data is a cell array containing data structures for every subject
% (its length corresponds to the number of subjects)
% score is the vector to correlate with data (length = n subjects)
% latency is the time window of interest (in seconds, e.g. [0 0.5])
%

switch channel
    case 'mag'
        data1 = ft_selectdata(data1,'channel',data1.typelabel.Mag2);
        data2 = ft_selectdata(data2,'channel',data1.typelabel.Mag2);
        data3 = ft_selectdata(data3,'channel',data1.typelabel.Mag2);
        data4 = ft_selectdata(data4,'channel',data1.typelabel.Mag2);
    case 'grad1'
        data1 = ft_selectdata(data1,'channel',data1.typelabel.Grad2_1);
        data2 = ft_selectdata(data2,'channel',data1.typelabel.Grad2_1);
        data3 = ft_selectdata(data3,'channel',data1.typelabel.Grad2_1);
        data4 = ft_selectdata(data4,'channel',data1.typelabel.Grad2_1);
    case 'grad2'
        data1 = ft_selectdata(data1,'channel',data1.typelabel.Grad2_2);
        data2 = ft_selectdata(data2,'channel',data1.typelabel.Grad2_2);
        data3 = ft_selectdata(data3,'channel',data1.typelabel.Grad2_2);
        data4 = ft_selectdata(data4,'channel',data1.typelabel.Grad2_2);
    otherwise
        disp('Error: Incorrect channel selection!');
end;

% re-label channels to match the neighbour sensors configuration
data1.label=data1.typelabel.Mag2;
data2.label=data1.typelabel.Mag2;
data3.label=data1.typelabel.Mag2;
data4.label=data1.typelabel.Mag2;

%%% Setting cfg for timelockstatistics %%%
cfg = [];
cfg.neighbours = data1.neighbours;
cfg.method = 'montecarlo';       % use the Monte Carlo Method to calculate the significance probability
cfg.statistic = 'depsamplesregrT'; % use the dependent samples T-statistic as a measure to evaluate 
                                 % the effect at the sample level
cfg.correctm = 'cluster';
cfg.clusteralpha = 0.05;         % alpha level of the sample-specific test statistic that will be used for thresholding
cfg.clusterstatistic = 'maxsum'; % test statistic that will be evaluated under the permutation distribution. 
cfg.minnbchan = 2;               % minimum number of neighborhood channels that is required for a selected 
                                 % sample to be included in the clustering algorithm (default=0).
cfg.tail = 0;                    % -1, 1 or 0 (default = 0); one-sided or two-sided test
cfg.clustertail = 0;
cfg.alpha = 0.025;               % alpha level of the permutation test
cfg.numrandomization = 100;      % number of draws from the permutation distribution

subj=size(data1.individual,1);
nds=4;
design = zeros(2,nds*subj);
for i = 1:nds
  design(1,1+(i-1)*subj:i*subj) = i*ones(1,subj);
  design(2,1+(i-1)*subj:i*subj) = 1:subj;
end

cfg.design = design;             % design matrix
cfg.ivar  = 1;      % the 1st row in cfg.design contains the independent variable
cfg.uvar  = 2;      % the 2nd row in cfg.design contains the subject number (or trial number)

cfg.latency = latency;   % time interval over which the experimental 
                         % conditions must be compared (in seconds)

%compute the stat!
stat = ft_timelockstatistics(cfg,data1,data2,data3,data4);
ns_statinfo(stat);
% keep design in stat for easy reference
stat.cfg.design=design;