function stat=fp_statindepregr(channel,latency,varargin)
% Example: stat=fp_statindepregr('mag',[0 0.5],data1,data2,data3,data4)

% performs cluster randomization analysis 
% data is a cell array containing data structures for every subject
% (its length corresponds to the number of subjects)
% score is the vector to correlate with data (length = n subjects)
% latency is the time window of interest (in seconds, e.g. [0 0.5])
%
% Author: Marco Buiatti, 2015

% number of levels
nl=length(varargin);

% channel selection and re-label channels to match the neighbour sensors configuration
switch channel
    case 'mag'
        for level=1:nl
            varargin{level} = ft_selectdata(varargin{level},'channel',varargin{level}.typelabel.Mag2);
            varargin{level}.label=varargin{level}.typelabel.Mag2;
        end
    case 'grad1'
        for level=1:nl
            varargin{level} = ft_selectdata(varargin{level},'channel',varargin{level}.typelabel.Grad2_1);
            varargin{level}.label=varargin{level}.typelabel.Mag2;
        end
    case 'grad2'
        for level=1:nl
            varargin{level} = ft_selectdata(varargin{level},'channel',varargin{level}.typelabel.Grad2_2);
            varargin{level}.label=varargin{level}.typelabel.Mag2;
        end
    otherwise
        disp('Error: Incorrect channel selection!');
end;

%%% Setting cfg for timelockstatistics %%%
cfg = [];
cfg.neighbours = varargin{1}.neighbours;
cfg.method = 'montecarlo';       % use the Monte Carlo Method to calculate the significance probability
cfg.statistic = 'indepsamplesregrT'; % use the dependent samples T-statistic as a measure to evaluate 
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

design=[];
for level=1:nl
    design=[design level*ones(1,size(varargin{level}.trial,1))];
end

cfg.design = design;             % design matrix
cfg.ivar  = 1;

cfg.latency = latency;   % time interval over which the experimental 
                         % conditions must be compared (in seconds)

%compute the stat!
stat = ft_timelockstatistics(cfg,varargin{:});
ns_statinfo(stat);
% keep design in stat for easy reference
stat.cfg.design=design;