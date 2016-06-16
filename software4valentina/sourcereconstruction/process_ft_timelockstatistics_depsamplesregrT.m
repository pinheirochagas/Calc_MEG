function varargout = process_ft_timelockstatistics_depsamplesregrT( varargin )
% PROCESS_FT_TIMELOCKESTATISTICS Call FieldTrip function ft_timelockstatistics.
%
% Reference: http://www.fieldtriptoolbox.org/reference/ft_timelockstatistics

% @=============================================================================
% This software is part of the Brainstorm software:
% http://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2015 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPL
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Arnaud Gloaguen, Francois Tadel, 2015

macro_methodcall;
end


%% ===== GET DESCRIPTION =====
function sProcess = GetDescription() %#ok<DEFNU>
    % Description the process
    sProcess.Comment     = 'FieldTrip: ft_timelockstatistics';
    sProcess.FileTag     = '';
    sProcess.Category    = 'Stat1';
    sProcess.SubGroup    = 'Test';
    sProcess.Index       = 110;
    % Definition of the input accepted by this process
    sProcess.InputTypes  = {'data'};
    sProcess.OutputTypes = {'pdata'};
    sProcess.nInputs     = 1;
    sProcess.nMinFiles   = 2;
    % Definition of the options
    sProcess = DefineStatOptions(sProcess);
end


%% ===== FORMAT COMMENT =====
function Comment = FormatComment(sProcess) %#ok<DEFNU>
    switch (sProcess.options.correctiontype.Value{1})
        case 1, Comment = 'Permutation t-test: Uncorrected';
        case 2, Comment = 'Permutation t-test: Cluster-based correction';
        case 3, Comment = 'Permutation t-test: Bonferroni correction';
        case 4, Comment = 'Permutation t-test: FDR correction';
        case 5, Comment = 'Permutation t-test: Maximum-statistic correction';
        case 6, Comment = 'Permutation t-test: Holm-Bonferroni correction';
        case 7, Comment = 'Permutation t-test: Hochberg correction';
    end
end


%% ===== DEFINE STATISTICS OPTIONS ======
function sProcess = DefineStatOptions(sProcess)
    % ===== INPUT OPTIONS =====
    sProcess.options.label1.Comment = '<B><U>Input options</U></B>:';
    sProcess.options.label1.Type    = 'label';
    % === REGRESSION LEVELS ===
    sProcess.options.regressionlevels.Comment = 'Regression levels:';
    sProcess.options.regressionlevels.Type    = 'value';
    sProcess.options.regressionlevels.Value   = {0, '', 0};
    % === SENSOR TYPES
    sProcess.options.sensortypes.Comment    = 'Sensor types (empty=all): ';
    sProcess.options.sensortypes.Type       = 'text';
    sProcess.options.sensortypes.Value      = 'EEG'; % why not MEG?
    sProcess.options.sensortypes.InputTypes = {'data'};
    % === TIME WINDOW ===
    sProcess.options.timewindow.Comment = 'Time window:';
    sProcess.options.timewindow.Type    = 'timewindow';
    sProcess.options.timewindow.Value   = [];
    % === SCOUTS SELECTION ===
    sProcess.options.scoutsel.Comment    = 'Use scouts';
    sProcess.options.scoutsel.Type       = 'scout_confirm';
    sProcess.options.scoutsel.Value      = {};
    sProcess.options.scoutsel.InputTypes = {'results'};
    % === SCOUT FUNCTION ===
    sProcess.options.scoutfunc.Comment   = {'Mean', 'PCA', 'All', 'Scout function:'};
    sProcess.options.scoutfunc.Type      = 'radio_line';
    sProcess.options.scoutfunc.Value     = 2;
    sProcess.options.scoutfunc.InputTypes = {'results'};
    % === AVERAGE OVER TIME
    sProcess.options.avgtime.Comment    = 'Average over time';
    sProcess.options.avgtime.Type       = 'checkbox';
    sProcess.options.avgtime.Value      = 0;
    % === AVERAGE OVER CHANNELS
    sProcess.options.avgchan.Comment    = 'Average over channels';
    sProcess.options.avgchan.Type       = 'checkbox';
    sProcess.options.avgchan.Value      = 0;
    sProcess.options.avgchan.InputTypes = {'data'};

    % ===== STATISTICAL TESTING OPTIONS =====
    sProcess.options.label2.Comment  = '<BR><B><U>Statistical testing (Monte-carlo)</U></B>:';
    sProcess.options.label2.Type     = 'label';
    % === NUMBER OF RANDOMIZATIONS
    sProcess.options.randomizations.Comment = 'Number of randomizations:';
    sProcess.options.randomizations.Type    = 'value';
    sProcess.options.randomizations.Value   = {1000, '', 0};
    % === STATISTICS APPLIED FOR SAMPLES : TYPE
    % The statistic that is computed for each sample in each random reshuffling of the data
    sProcess.options.statistictype.Comment = {'Dependent Samples Regression T-statistic', ''};   % More options: See below 'statcfg.statistic' TO ADD: indep samples
    sProcess.options.statistictype.Type    = 'radio_line';
    sProcess.options.statistictype.Value   = 1;
    % === TAIL FOR THE TEST STATISTIC
    sProcess.options.tail.Comment  = {'One-tailed (-)', 'Two-tailed', 'One-tailed (+)', ''};  % (default = 'two-sided')};
    sProcess.options.tail.Type     = 'radio_line';
    sProcess.options.tail.Value    = 2;
    
    % ===== MULTIPLE COMPARISONS OPTIONS =====
    sProcess.options.label3.Comment = '<BR><B><U>Correction for multiple comparisons</U></B>:';
    sProcess.options.label3.Type    = 'label';
    % === TYPE OF CORRECTION
    sProcess.options.correctiontype.Comment = 'Type of correction: ';   % More options: See below 'statcfg.correctm'
    sProcess.options.correctiontype.Type    = 'combobox';
    sProcess.options.correctiontype.Value   = {2, {'no', 'cluster', 'bonferroni', 'fdr', 'max', 'holm', 'hochberg'}};
    % === WAY TO COMBINE SAMPLES OF A CLUSTER
    % How to combine the single samples that belong to a cluster
    % 'wcm' refers to 'weighted cluster mass', a statistic that combines cluster size and intensity; see Hayasaka & Nichols (2004) NeuroImage for details.
    sProcess.options.clusterstatistic.Comment   = {'maxsum', 'maxsize', 'wcm', 'Cluster function: '};  
    sProcess.options.clusterstatistic.Type      = 'radio_line';
    sProcess.options.clusterstatistic.Value     = 1;    
    % === MINIMUM NUMBER OF NEIGHBOURING CHANNELS
    sProcess.options.minnbchan.Comment    = 'Min number of neighbours (minnbchan): ';
    sProcess.options.minnbchan.Type       = 'value';
    sProcess.options.minnbchan.Value      = {0, '', 0};
%     sProcess.options.minnbchan.InputTypes = {'data'};
    % === MAXIMAL DISTANCE BETWEEN NEIGHBOURS
    sProcess.options.maxdist.Comment    = 'Maximum distance between neighbours: ';
    sProcess.options.maxdist.Type       = 'value';
    sProcess.options.maxdist.Value      = {4, 'cm', 1};
    sProcess.options.maxdist.InputTypes = {'data'};
    % === CLUSTER TAIL FOR THE TEST STATISTIC
    sProcess.options.clustertail.Comment  = {'One-tailed (-)', 'Two-tailed', 'One-tailed (+)', ''}; 
    sProcess.options.clustertail.Type     = 'radio_line';
    sProcess.options.clustertail.Value    = 2;
    % === CLUSTER ALPHA VALUE
    sProcess.options.clusteralpha.Comment = 'Cluster Alpha :';
    sProcess.options.clusteralpha.Type    = 'value';
    sProcess.options.clusteralpha.Value   = {0.05, '', 4};
end


%% ===== GET STAT OPTIONS =====
function OPT = GetStatOptions(sProcess)
    % Input options
    if isfield(sProcess.options, 'sensortypes') && isfield(sProcess.options.sensortypes, 'Value')
        OPT.SensorTypes = sProcess.options.sensortypes.Value;
    end
    OPT.TimeWindow  = sProcess.options.timewindow.Value{1};
%     OPT.RegressionLevel = sProcess.options.regressionlevels.Value;
    OPT.isAvgTime   = sProcess.options.avgtime.Value;
    if isfield(sProcess.options, 'avgchan') && isfield(sProcess.options.avgchan, 'Value')
        OPT.isAvgChan = sProcess.options.avgchan.Value;
    end
    % Scouts
    if isfield(sProcess.options, 'scoutsel') && isfield(sProcess.options.scoutsel, 'Value') && isfield(sProcess.options, 'scoutfunc') && isfield(sProcess.options.scoutfunc, 'Value')
        OPT.ScoutSel = sProcess.options.scoutsel.Value;
        switch (sProcess.options.scoutfunc.Value)
            case 1, OPT.ScoutFunc = 'mean';
            case 2, OPT.ScoutFunc = 'pca';
            case 3, OPT.ScoutFunc = 'all';
        end
    else
        OPT.ScoutSel = [];
        OPT.ScoutFunc = [];
    end
    % Test statistic options %% TO COMPLETE FOR INDEP S, but you need to
    % update file input selection which is a bit complicated
    switch (sProcess.options.statistictype.Value)
        case 1,  OPT.StatisticType  = 'depsamplesregrT';
%         case 2,  OPT.StatisticType  = 'indepsamplesregrT';
    end
    switch (sProcess.options.tail.Value)
        case 1,  OPT.Tail = -1;   % One-sided (negative)
        case 2,  OPT.Tail = 0;    % Two-sided
        case 3,  OPT.Tail = 1;    % One-sided (positive)
    end
    % Cluster statistic options
    OPT.Randomizations     = sProcess.options.randomizations.Value{1};
    OPT.ClusterAlphaValue  = sProcess.options.clusteralpha.Value{1};
    switch (sProcess.options.correctiontype.Value{1})
        case 1,  OPT.Correction = 'no';          OPT.strComment = 'Perm t-test [uncorrected]';
        case 2,  OPT.Correction = 'cluster';     OPT.strComment = 'Perm t-test [cluster]';
        case 3,  OPT.Correction = 'bonferroni';  OPT.strComment = 'Perm t-test [bonferroni]';
        case 4,  OPT.Correction = 'fdr';         OPT.strComment = 'Perm t-test [fdr]';
        case 5,  OPT.Correction = 'max';         OPT.strComment = 'Perm t-test [max]';
        case 6,  OPT.Correction = 'holm';        OPT.strComment = 'Perm t-test [holm]';
        case 7,  OPT.Correction = 'hochberg';    OPT.strComment = 'Perm t-test [hochberg]';
    end
    switch (sProcess.options.clustertail.Value)
        case 1,  OPT.ClusterTail = -1;   % One-sided (negative)
        case 2,  OPT.ClusterTail = 0;    % Two-sided
        case 3,  OPT.ClusterTail = 1;    % One-sided (positive)
    end
    switch (sProcess.options.clusterstatistic.Value)
        case 1,  OPT.ClusterStatistic = 'maxsum';
        case 2,  OPT.ClusterStatistic = 'maxsize';
        case 3,  OPT.ClusterStatistic = 'wcm';
    end
    % Neighborhood
    if isfield(sProcess.options, 'minnbchan') && isfield(sProcess.options.minnbchan, 'Value') && iscell(sProcess.options.minnbchan.Value) && ~isempty(sProcess.options.minnbchan.Value)
        OPT.MinNbChan = sProcess.options.minnbchan.Value{1};
    end
    if isfield(sProcess.options, 'maxdist') && isfield(sProcess.options.maxdist, 'Value') && iscell(sProcess.options.maxdist.Value) && ~isempty(sProcess.options.maxdist.Value)
        OPT.MaxDist = sProcess.options.maxdist.Value{1} / 100;   % Convert from centimeters to meters
    end
end


%% ===== RUN =====
function sOutput = Run(sProcess, sInputsA) %#ok<DEFNU>
    % Initialize returned variable 
    sOutput = [];
    
    % ===== PREPARE FIELDTRIP =====
    % Initialize fieldtrip
    if isempty(which('ft_defaults'))
        error('Please add FieldTrip to your matlab path.');
    end
    ft_defaults;
    
    % ===== CHECK INPUTS =====
%     % Make sure that file type is indentical for both sets
%     if ~isempty(sInputsA) && ~isempty(sInputsB) && ~strcmpi(sInputsA(1).FileType, sInputsB(1).FileType)
%         bst_report('Error', sProcess, sInputsA, 'Cannot process inputs from different types.');
%         return;
%     end
    % Check the number of files in input
    if length(sInputsA) < 2
        bst_report('Error', sProcess, sInputsA, 'Not enough files in input.');
        return;
    end
    
    % ===== GET OPTIONS =====
    OPT = GetStatOptions(sProcess);
    % Number of files
    nFilesA = length(sInputsA);
    
    % ===== LOAD INPUT CHANNEL FILES =====
    bst_progress('text', 'Reading channel files...');
    % Get all the channel files involved
    uniqueChannelFiles = unique({sInputsA.ChannelFile});
    % Load all the channel files
    AllChannelMats = cell(1, length(uniqueChannelFiles));
    for i = 1:length(uniqueChannelFiles)
        AllChannelMats{i} = in_bst_channel(uniqueChannelFiles{i});
        % Make sure that the list of sensors is the same
        if (i > 1) && ~isequal({AllChannelMats{1}.Channel.Name}, {AllChannelMats{i}.Channel.Name})
            bst_report('Error', sProcess, sInputsA, ['The list of channels in all the input files do not match.' 10 'Run the process "Standardize > Uniform list of channels" first.']);
            return;
        end
    end

    % ===== OUTPUT CHANNEL FILE =====
    % Get output channel study
    iOutputStudy = sProcess.options.iOutputStudy;
    [sChannel, iChanStudy] = bst_get('ChannelForStudy', iOutputStudy);
    % If there is one channel already existing: use it
    if ~isempty(sChannel)
        OutChannelMat = in_bst_channel(sChannel.FileName);
        % Make sure that the list of sensors is the same
        if ~isequal({OutChannelMat.Channel.Name}, {AllChannelMats{1}.Channel.Name})
            bst_report('Error', sProcess, sInputsA, ['The list of channels in the input files does not match the output channel file:' 10 sChannel.FileName]);
            return;
        end
    % Else: Compute an average of all the channel files
    else 
        % Compute average
        OutChannelMat = channel_average(AllChannelMats);
        % Save new channel file
        db_set_channel(iOutputStudy, OutChannelMat, 0, 0);
    end

    
    % ===== SENSOR SELECTION =====
    % Find sensors by names/types
    iChannelsOut = channel_find(OutChannelMat.Channel, OPT.SensorTypes);
    if isempty(iChannelsOut)
        bst_report('Error', sProcess, sInputsA, ['Channels "' OPT.SensorTypes '" not found in output channel file.']);
        return;
    end
    % Check that only one type of channels is selected
    ChannelTypes = unique({OutChannelMat.Channel(iChannelsOut).Type});
    if (length(ChannelTypes) > 1)
        bst_report('Error', sProcess, sInputsA, ['Multiple channel types in input: ' sprintf('%s ', ChannelTypes), 10 'Cluster-based statistics can be applied on one type of sensors at a time.']);
        return;
    end
    % Keep only the channels that are good in all the trials (remove all the bad channels from all the trials)
    for i = 1:nFilesA
        DataMatA     = in_bst_data(sInputsA(i).FileName, 'ChannelFlag');
        iChannelsOut = setdiff(iChannelsOut, find(DataMatA.ChannelFlag == -1));
    end
    % Make sure that there are some sensors available
    if (length(ChannelTypes) > 1)
        bst_report('Error', sProcess, sInputsA, 'All the selected sensors are bad in at least one input file.');
        return;
    end
    
    
    % ===== CREATE FIELDTRIP STRUCTURES =====
    % Load all the files in the same structure
    sAllInputs = sInputsA;
    nlevels=sProcess.options.regressionlevels.Value;
    nsubj=length(sAllInputs)/nlevels;
    disp(['Number of subjects: ' num2str(nsubj)]);
    ftAllFiles = cell(1, length(sAllInputs));
    for i = 1:length(sAllInputs)
        bst_progress('text', sprintf('Reading input files... [%d/%d]', i, length(sAllInputs)));
        % Convert file to a FieldTrip structure
        [ftAllFiles{i}, DataMat] = out_fieldtrip_data(sAllInputs(i).FileName, sAllInputs(i).ChannelFile, iChannelsOut, 1);
        % Time selection
        if ~isempty(OPT.TimeWindow)
            iTime = panel_time('GetTimeIndices', DataMat.Time, OPT.TimeWindow);
            ftAllFiles{i}.avg  = ftAllFiles{i}.avg(:, iTime);
            ftAllFiles{i}.time = ftAllFiles{i}.time(iTime);
        end
        % Time average
        if OPT.isAvgTime
        	ftAllFiles{i}.avg  = mean(ftAllFiles{i}.avg, 2);
            ftAllFiles{i}.time = ftAllFiles{i}.time(1);
        end
        % Channel average
        if OPT.isAvgChan && (size(ftAllFiles{i}.avg,1) > 1)
            ftAllFiles{i}.avg   = mean(ftAllFiles{i}.avg, 1);
            ftAllFiles{i}.label = {'avgchan'};
        end
        % Save first time vector
        if (i == 1)
            firstTimeVector = DataMat.Time;
        elseif ~isequal(size(ftAllFiles{i}.avg,1), size(ftAllFiles{1}.avg,1))
            bst_report('Error', sProcess, [], sprintf('All the files must have the same number of channels.\nFile #%d has %d channels, file #%d has %d channels.', 1, size(ftAllFiles{1}.avg,1), i, size(ftAllFiles{i}.avg,1)));
            return;
        elseif ~isequal(size(ftAllFiles{i}.avg,2), size(ftAllFiles{1}.avg,2))
            bst_report('Error', sProcess, [], sprintf('All the files must have the same number of time samples.\nFile #%d has %d samples, file #%d has %d samples.', 1, size(ftAllFiles{1}.avg,2), i, size(ftAllFiles{i}.avg,2)));
            return;
        elseif (abs(ftAllFiles{1}.time(1) - ftAllFiles{i}.time(1)) > 1e-6)
            bst_report('Error', sProcess, [], 'The time definitions of the input files do not match.');
            return;
        end
    end
    
    
    % ===== CALL FIELDTRIP =====
    bst_progress('text', 'Calling FieldTrip function: ft_timelockstatistics...');
    % Input options
    statcfg = struct();
    statcfg.channel      = 'all'; % Channel selection already done so equal to 'all'
    statcfg.latency      = 'all'; % Time selection already done so equal to 'all'
    statcfg.avgovertime  = 'no';  % Time average already done so equal to 'no'
    statcfg.avgchan      = 'no';  % Space average already done so equal to 'no'

    % Different methods for calculating the significance probability and/or critical value
    %   cfg.method     = 'montecarlo'    get Monte-Carlo estimates of the significance probabilities and/or critical values from the permutation distribution
    %                    'analytic'      get significance probabilities and/or critical values from the analytic reference distribution (typically, the sampling distribution under the null hypothesis),
    %                    'stats'         use a parametric test from the MATLAB statistics toolbox,
    %                    'crossvalidate' use crossvalidation to compute predictive performance
    statcfg.method            = 'montecarlo';
    statcfg.numrandomization  = OPT.Randomizations;
     
    % Possible statistics to applied for each samples:
    %   cfg.statistic       = 'indepsamplesT'           independent samples T-statistic,
    %                         'indepsamplesF'           independent samples F-statistic,
    %                         'indepsamplesregrT'       independent samples regression coefficient T-statistic,
    %                         'indepsamplesZcoh'        independent samples Z-statistic for coherence,
    %                         'depsamplesT'             dependent samples T-statistic,
    %                         'depsamplesFmultivariate' dependent samples F-statistic MANOVA,
    %                         'depsamplesregrT'         dependent samples regression coefficient T-statistic,
    %                         'actvsblT'                activation versus baseline T-statistic.
    statcfg.statistic    = OPT.StatisticType;   
    statcfg.tail         = OPT.Tail;
    statcfg.correcttail  = 'prob';
    statcfg.parameter    = 'avg';    % parameter in FieldTrip structure on which the stats will be applied
    
    %%%%%%%%% DA FARE STAMATTINA %%%%%%%%%%%%%%%%%%
    
    
    % Define the design of the experiment
    switch (OPT.StatisticType)
%         case 'indepsamplesT'
%             statcfg.design      = zeros(1, nFilesA + nFilesB);
%             statcfg.design(1,:) = [ones(1,nFilesA), 2*ones(1,nFilesB)];
%             statcfg.ivar        = 1;   % the one and only row in cfg.design contains the independent variable
        case 'depsamplesregrT'
%             statcfg.design = zeros(2,sProcess.options.regressionlevels.Value*nsubj);
%             for i = 1:sProcess.options.regressionlevels.Value
%                 statcfg.design(1,1+(i-1)*nsubj:i*nsubj) = i*ones(1,nsubj);
%                 statcfg.design(2,1+(i-1)*nsubj:i*nsubj) = 1:subj;
%             end
            statcfg.design = zeros(2,nlevels*nsubj);
            for i = 1:nlevels
                statcfg.design(1,1+(i-1)*nsubj:i*nsubj) = i*ones(1,nsubj);
                statcfg.design(2,1+(i-1)*nsubj:i*nsubj) = 1:nsubj;
            end
            statcfg.ivar        = 1;   % the 1st row in cfg.design contains the independent variable
            statcfg.uvar        = 2;   % the 2nd row in cfg.design contains the subject number (or trial number)
    end
    
    % Multiple-comparison correction
    statcfg.correctm = OPT.Correction;
    % Additional parameters for the method
    switch (OPT.Correction)
        case 'no'
        case 'cluster'
            % Define parameters for cluster statistics
            statcfg.clusteralpha     = OPT.ClusterAlphaValue;
            statcfg.clustertail      = OPT.ClusterTail;
            statcfg.minnbchan        = OPT.MinNbChan;
            statcfg.clusterstatistic = OPT.ClusterStatistic;

            % Prepare neighbour structure for clustering
            neicfg                 = struct();
            neicfg.method          = 'distance';
            neicfg.neighbourdist   = OPT.MaxDist;
            if isfield(ftAllFiles{1}, 'elec') && ~isempty(ftAllFiles{1}.elec)
                neicfg.elec = ftAllFiles{1}.elec;
            elseif isfield(ftAllFiles{1}, 'grad') && ~isempty(ftAllFiles{1}.grad)
                neicfg.grad = ftAllFiles{1}.grad;
            else
                bst_report('Error', sProcess, sInputsA, 'ftData.elec and ftData.grad are both empty or do not exist. Impossible to define neighbours.');
                return;
            end
            % Get neighbors
            % load neighbour electrode configuration 
            
%             % for sd only:
%             load('C:\Users\marco.buiatti\Documents\FromOmega\projects\sd\workspaces\sd_neighbours64.mat');
            neighbours = ft_prepare_neighbours(neicfg);
            statcfg.neighbours = neighbours;
        case 'bonferroni'
        case 'fdr'
        case 'max'
        case 'holm'
        case 'hochberg'
    end

    % Main function that will compute the statistics
    ftStat = ft_timelockstatistics(statcfg, ftAllFiles{:});
    % Error management
    if ~isfield(ftStat, 'prob') || ~isfield(ftStat, 'stat') || isempty(ftStat.prob) || isempty(ftStat.stat)
        bst_report('Error', sProcess, [], 'Unknown error: The function ft_timelockstatistics did not return anything.');
        return;
    end
    % Apply thresholded mask on the p-values (the prob map is already thresholded for clusters)
    if ~ismember(OPT.Correction, {'no', 'cluster'})
        ftStat.prob(~ftStat.mask) = .999;
    end

    % ===== CHANNEL ORDER =====
    % Check if at the end you still have the list of channel you want to keep and if they are in the same order
    if ~OPT.isAvgChan
        % Channel names to save in the file
        ChannelNames = {OutChannelMat.Channel(iChannelsOut).Name};
        % Check that the number of output signals is ok
        if length(ChannelNames) ~= length(ftStat.label)
            bst_report('Error', sProcess, [], 'Unknown problem with the output channels...');
            return;
        end
        % If the channels were re-ordered: fix it
        if ~isequal(ChannelNames', ftStat.label)
            % Find the corresponding channels in both lists
            [tmp, iFieltrip, iBrainstorm] = intersect(ftStat.label, ChannelNames);
            % Re-order all the matrices
            stat_tmp = ftStat;
            ftStat.stat(iBrainstorm, :)     = stat_tmp.stat(iFieltrip, :);
            ftStat.prob(iBrainstorm, :)     = stat_tmp.prob(iFieltrip, :);
            ftStat.label(iBrainstorm, :)    = stat_tmp.label(iFieltrip, :);
            if isfield(ftStat, 'posclusters') && ~isempty(ftStat.posclusters)
                ftStat.posclusterslabelmat(iBrainstorm, :) = stat_tmp.posclusterslabelmat(iFieltrip, :);
            end
            if isfield(ftStat, 'negclusters') && ~isempty(ftStat.negclusters)
                ftStat.negclusterslabelmat(iBrainstorm, :) = stat_tmp.negclusterslabelmat(iFieltrip, :);
            end
        end
    else
        ftStat.stat = repmat(ftStat.stat, length(iChannelsOut), 1);
        ftStat.prob = repmat(ftStat.prob, length(iChannelsOut), 1);
    end
    
    
    % ===== OUTPUT STRUCTURE =====
    sOutput = db_template('statmat');
    % Store t- and p-values
    sOutput.tmap = zeros(length(OutChannelMat.Channel), length(ftStat.time));
    sOutput.pmap = ones(length(OutChannelMat.Channel), length(ftStat.time));
    sOutput.tmap(iChannelsOut,:) = ftStat.stat;
    sOutput.pmap(iChannelsOut,:) = ftStat.prob;
    % Store other stuff
    sOutput.df            = [];
    sOutput.Correction    = OPT.Correction;
    sOutput.ColormapType  = 'stat2';
    sOutput.Comment       = OPT.strComment;
    % Output channel flag
    sOutput.ChannelFlag  = -1 * ones(1, length(OutChannelMat.Channel));
    sOutput.ChannelFlag(iChannelsOut) = 1;
    % Save clusters
    if isfield(ftStat, 'posclusters')
        sOutput.posclusters         = ftStat.posclusters;
        sOutput.posdistribution     = ftStat.posdistribution;
        sOutput.posclusterslabelmat = ones(length(OutChannelMat.Channel), length(ftStat.time));
        sOutput.posclusterslabelmat(iChannelsOut,:) = ftStat.posclusterslabelmat;
    else
        sOutput.posclusters         = [];
        sOutput.posclusterslabelmat = [];
        sOutput.posdistribution     = [];
    end
    if isfield(ftStat, 'negclusters')
        sOutput.negclusters         = ftStat.negclusters;
        sOutput.negdistribution     = ftStat.negdistribution;
        sOutput.negclusterslabelmat = ones(length(OutChannelMat.Channel), length(ftStat.time));
        sOutput.negclusterslabelmat(iChannelsOut,:) = ftStat.negclusterslabelmat;
    else
        sOutput.negclusters         = [];
        sOutput.negclusterslabelmat = [];
        sOutput.negdistribution     = [];
    end
    % Time: If there is only one time point, replicate to have two
    if (length(ftStat.time) == 1)
        sOutput.Time = [firstTimeVector(1), firstTimeVector(end)];
        sOutput.tmap = [sOutput.tmap(:,1), sOutput.tmap(:,1)];
        sOutput.pmap = [sOutput.pmap(:,1), sOutput.pmap(:,1)];
        if ~isempty(sOutput.posclusterslabelmat)
            sOutput.posclusterslabelmat = [sOutput.posclusterslabelmat(:,1), sOutput.posclusterslabelmat(:,1)];
        end
        if ~isempty(sOutput.negclusterslabelmat)
            sOutput.negclusterslabelmat = [sOutput.negclusterslabelmat(:,1), sOutput.negclusterslabelmat(:,1)];
        end
    else
        sOutput.Time = ftStat.time;
    end
    % Save FieldTrip configuration structure
    sOutput.Options = statcfg;
    if isfield(sOutput.Options, 'neighbours')
        sOutput.Options = rmfield(sOutput.Options, 'neighbours');
    end
    % Last message
    bst_progress('text', 'Saving results...');
end




