function varargout = process_ft_sourcestatistics_nonorm( varargin )
% PROCESS_FT_SOURCESTATISTICS Call FieldTrip function ft_sourcestatistics.
%
% Reference: http://www.fieldtriptoolbox.org/reference/ft_sourcestatistics

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
    sProcess.Comment     = 'FieldTrip: ft_sourcestatistics (no normalization)';
    sProcess.FileTag     = '';
    sProcess.Category    = 'Stat2';
    sProcess.SubGroup    = 'Test';
    sProcess.Index       = 111;
    % Definition of the input accepted by this process
    sProcess.InputTypes  = {'results'};
    sProcess.OutputTypes = {'presults'};
    sProcess.nInputs     = 2;
    sProcess.nMinFiles   = 2;
    % Definition of the options
    sProcess = process_ft_timelockstatistics('DefineStatOptions', sProcess);
end


%% ===== FORMAT COMMENT =====
function Comment = FormatComment(sProcess) %#ok<DEFNU>
    Comment = process_ft_timelockstatistics('FormatComment', sProcess);
end


%% ===== RUN =====
function sOutput = Run(sProcess, sInputsA, sInputsB) %#ok<DEFNU>
    % Initialize returned variable 
    sOutput = [];
    
    % ===== PREPARE FIELDTRIP =====
    % Initialize fieldtrip
    if isempty(which('ft_defaults'))
        error('Please add FieldTrip to your matlab path.');
    end
    ft_defaults;
    
    % ===== CHECK INPUTS =====
    % Make sure that file type is indentical for both sets
    if ~isempty(sInputsA) && ~isempty(sInputsB) && ~strcmpi(sInputsA(1).FileType, sInputsB(1).FileType)
        bst_report('Error', sProcess, sInputsA, 'Cannot process inputs from different types.');
        return;
    end
    % Check the number of files in input
    if (length(sInputsA) < 2) || (length(sInputsB) < 2)
        bst_report('Error', sProcess, sInputsA, 'Not enough files in input.');
        return;
    end
    
    % ===== GET OPTIONS =====
    OPT = process_ft_timelockstatistics('GetStatOptions', sProcess);
    % Number of files
    nFilesA = length(sInputsA);
    nFilesB = length(sInputsB);
    % Check number of files
    if (nFilesA ~= nFilesB) && strcmpi(OPT.StatisticType, 'depsamplesT')
        bst_report('Error', sProcess, [], 'For a paired t-test, the number of files must be the same in the two groups.');
        return;
    end

    % ===== CREATE FIELDTRIP STRUCTURES =====
    % Load all the files in the same structure
    sAllInputs = [sInputsA, sInputsB];
    ftAllFiles = cell(1, length(sAllInputs));
%     isNorm = 1;  % Take the norm of the source activations
    isNorm = 0;  % Take the source values as they are stored in the file (to use for z-scored values)
    for i = 1:length(sAllInputs)
        bst_progress('text', sprintf('Reading input files... [%d/%d]', i, length(sAllInputs)));
        % Convert Brainstorm file to FieldTrip structure
        if (i == 1)
            % First call: convert more information
            [ftAllFiles{i}, ResultsMat, VertConn] = out_fieldtrip_results(sAllInputs(i).FileName, OPT.ScoutSel, OPT.ScoutFunc, OPT.TimeWindow, isNorm);
            % Use the information from the first file for all the files
            TimeVector  = ResultsMat.Time;
            nComponents = ResultsMat.nComponents;
            GridAtlas   = ResultsMat.GridAtlas;
            RowNames    = ResultsMat.RowNames;
        else
            % Following calls: Just get the source values
            ftAllFiles{i} = out_fieldtrip_results(sAllInputs(i).FileName, OPT.ScoutSel, OPT.ScoutFunc, OPT.TimeWindow, isNorm);
        end
        % Check that something was read
        if isempty(ftAllFiles{i}.pow)
            bst_report('Error', sProcess, sAllInputs(i), 'Nothing read from the file.');
            return;
        end
%         % Make sure all the values are positive
%         ftAllFiles{i}.pow = abs(ftAllFiles{i}.pow);
        % Time average
        if OPT.isAvgTime
        	ftAllFiles{i}.pow  = mean(ftAllFiles{i}.pow, 2);
            ftAllFiles{i}.time = ftAllFiles{i}.time(1);
        end
        % Check that all the files have the same dimensions as the first one
        if (i > 1)
            if ~isequal(size(ftAllFiles{i}.pow,1), size(ftAllFiles{1}.pow,1))
                bst_report('Error', sProcess, [], sprintf('All the files must have the same number of sources.\nFile #%d has %d sources, file #%d has %d sources.', 1, size(ftAllFiles{1}.pow,1), i, size(ftAllFiles{i}.pow,1)));
                return;
            elseif ~isequal(size(ftAllFiles{i}.pow,2), size(ftAllFiles{1}.pow,2))
                bst_report('Error', sProcess, [], sprintf('All the files must have the same number of time samples.\nFile #%d has %d samples, file #%d has %d samples.', 1, size(ftAllFiles{1}.pow,2), i, size(ftAllFiles{i}.pow,2)));
                return;
            elseif (abs(ftAllFiles{1}.time(1) - ftAllFiles{i}.time(1)) > 1e-6)
                bst_report('Error', sProcess, [], 'The time definitions of the input files do not match.');
                return;
            end
        end
    end
            
    % ===== CALL FIELDTRIP =====
    bst_progress('text', 'Calling FieldTrip function: ft_sourcestatistics...');
    % Input options
    statcfg = struct();
    statcfg.method            = 'montecarlo';
    statcfg.numrandomization  = OPT.Randomizations;
    statcfg.statistic         = OPT.StatisticType; 
    statcfg.tail              = OPT.Tail;
    statcfg.correcttail       = 'prob';
    statcfg.parameter         = 'pow';
    
    % Define the design of the experiment
    switch (OPT.StatisticType)
        case 'indepsamplesT'
            statcfg.design      = zeros(1, nFilesA + nFilesB);
            statcfg.design(1,:) = [ones(1,nFilesA), 2*ones(1,nFilesB)];
            statcfg.ivar        = 1;   % the one and only row in cfg.design contains the independent variable
        case 'depsamplesT'
            statcfg.design      = zeros(2, nFilesA + nFilesB);
            statcfg.design(1,:) = [ones(1,nFilesA), 2*ones(1,nFilesB)];
            statcfg.design(2,:) = [1:nFilesA 1:nFilesB];
            statcfg.ivar        = 1;   % the 1st row in cfg.design contains the independent variable
            statcfg.uvar        = 2;   % the 2nd row in cfg.design contains the subject number (or trial number)
    end
    
    % Correction for multiple comparisons
    statcfg.correctm = OPT.Correction;
    switch (OPT.Correction)
        case 'no'
        case 'cluster'
            % Define parameters for cluster statistics
            statcfg.clusteralpha     = OPT.ClusterAlphaValue;
            statcfg.clustertail      = OPT.ClusterTail;
            statcfg.minnbchan        = OPT.MinNbChan; 
            statcfg.clusterstatistic = OPT.ClusterStatistic;
            % Keep only the selected vertices in the vertex adjacency matrix
            if ~isempty(VertConn) && isempty(OPT.ScoutSel)
                statcfg.connectivity = full(VertConn);
            else
                statcfg.connectivity = zeros(size(ftAllFiles{1}.pos, 1)); 
            end
        case 'bonferroni'
        case 'fdr'
        case 'max'
        case 'holm'
        case 'hochberg'
    end

    % Main function that will compute the statistics
    ftStat = ft_sourcestatistics(statcfg, ftAllFiles{:});
    % Error management
    if ~isfield(ftStat, 'prob') || ~isfield(ftStat, 'stat') || isempty(ftStat.prob) || isempty(ftStat.stat)
        bst_report('Error', sProcess, [], 'Unknown error: The function ft_sourcestatistics did not return anything.');
        return;
    end
    % Apply thresholded mask on the p-values (the prob map is already thresholded for clusters)
    if ~ismember(OPT.Correction, {'no', 'cluster'})
        ftStat.prob(~ftStat.mask) = .999;
    end
    
    % === OUTPUT STRUCTURE ===
    sOutput = db_template('statmat');
    % Store t- and p-values
    sOutput.pmap = ftStat.prob;
    sOutput.tmap = ftStat.stat;
    % Store other stuff
    sOutput.df            = [];
    sOutput.Correction    = OPT.Correction;
    sOutput.ColormapType  = 'stat2';
    sOutput.Comment       = OPT.strComment;
    % Output type
    if ~isempty(OPT.ScoutSel)
        sOutput.Type = 'matrix';
        sOutput.Description = RowNames;
    else
        sOutput.Type = 'results';
    end
    % Source model fields
    sOutput.nComponents = nComponents;
    sOutput.GridAtlas   = GridAtlas;
    % Time: If there is only one time point, replicate to have two
    if (length(ftStat.time) == 1)
        sOutput.Time = [TimeVector(1), TimeVector(end)];
        sOutput.tmap = [sOutput.tmap(:,1), sOutput.tmap(:,1)];
        sOutput.pmap = [sOutput.pmap(:,1), sOutput.pmap(:,1)];
    else
        sOutput.Time = ftStat.time;
    end
    % Save clusters
    if isfield(ftStat, 'posclusters')
        sOutput.posclusters         = ftStat.posclusters;
        sOutput.posclusterslabelmat = ftStat.posclusterslabelmat;
        sOutput.posdistribution     = ftStat.posdistribution;
    else
        sOutput.posclusters         = [];
        sOutput.posclusterslabelmat = [];
        sOutput.posdistribution     = [];
    end
    if isfield(ftStat, 'negclusters')
        sOutput.negclusters         = ftStat.negclusters;
        sOutput.negclusterslabelmat = ftStat.negclusterslabelmat;
        sOutput.negdistribution     = ftStat.negdistribution;
    else
        sOutput.negclusters         = [];
        sOutput.negclusterslabelmat = [];
        sOutput.negdistribution     = [];
    end
    % Save FieldTrip configuration structure
    sOutput.Options = statcfg;
    if isfield(sOutput.Options, 'connectivity')
        sOutput.Options = rmfield(sOutput.Options, 'connectivity');
    end
    % Last message
    bst_progress('text', 'Saving results...');
end




