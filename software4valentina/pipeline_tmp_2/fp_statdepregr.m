function stat=fp_statdepregr(channel,latency,varargin)
% Example: stat=fp_statdepregr('mag',[0 0.5],data1,data2,data3,data4)

% performs cluster randomization analysis 
% data is a cell array containing data structures for every subject
% (its length corresponds to the number of subjects)
% score is the vector to correlate with data (length = n subjects)
% latency is the time window of interest (in seconds, e.g. [0 0.5])
%
% Author: Marco Buiatti, 2015

%%% add fieldtrip directory to the current path %%%
% addpath '/neurospin/local/fieldtrip/'                 % fieldtrip
% ft_defaults                                           % sets fieldtrip defaults and configures the minimal required path settings 

% load neighbour sensors configuration (independently from channel
% selection, the magnetometers layout is loaded, as channel position is the
% same for the three types of sensors).
% load('/neurospin/meg/meg_tmp/tools_tmp/pipeline_tmp/neuromag306mag_neighb.mat');
load('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina/pipeline_tmp/neuromag306mag_neighb.mat');
% select channels in the data
% load('/neurospin/meg/meg_tmp/tools_tmp/pipeline/SensorClassification.mat');
load('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina/pipeline_tmp/SensorClassification.mat');

% number of levels
nl=length(varargin);

% channel selection and re-label channels to match the neighbour sensors configuration
switch channel
    case 'mag'
        for level=1:nl
            varargin{level} = ft_selectdata(varargin{level},'channel',Mag2);
            varargin{level}.label=Mag2;
        end
    case 'grad1'
        for level=1:nl
            varargin{level} = ft_selectdata(varargin{level},'channel',Grad2_1);
            varargin{level}.label=Mag2;
        end
    case 'grad2'
        for level=1:nl
            varargin{level} = ft_selectdata(varargin{level},'channel',Grad2_2);
            varargin{level}.label=Mag2;
        end
    otherwise
        disp('Error: Incorrect channel selection!');
end;

%%% Setting cfg for timelockstatistics %%%
cfg = [];
cfg.neighbours = neighbours;
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

subj=size(varargin{1}.individual,1);
design = zeros(2,nl*subj);
for i = 1:nl
  design(1,1+(i-1)*subj:i*subj) = 1:subj;
  design(2,1+(i-1)*subj:i*subj) = i*ones(1,subj);
end

cfg.design = design;             % design matrix
cfg.uvar  = 1;
cfg.ivar  = 2;

cfg.latency = latency;   % time interval over which the experimental 
                         % conditions must be compared (in seconds)

%compute the stat!
stat = ft_timelockstatistics(cfg,varargin{:});
ns_statinfo(stat);
% keep design in stat for easy reference
stat.cfg.design=design;