function ds_z_sm_pd(SubjectName,Condition,intra)

% SubjectName = 's03';
% Condition = 'click1';
% Intra (0 - no ned for intra- or 1 - look into intra-)

if intra==0
    [sStudySrc, iStudySrc] = bst_get('StudyWithCondition', [SubjectName '/' Condition]);
    for i=1:length(sStudySrc.Result)
        if strfind(sStudySrc.Result(i).FileName,'average') ...            % average
                & strfind(sStudySrc.Result(i).FileName,'resample') ...    % downsampled
                & strfind(sStudySrc.Result(i).FileName,'results_wMNE')    % wMNE
            good_index=i;
        end;
    end;
else
    % look into @intra folder.
    [sStudySrc, iStudySrc] = bst_get('StudyWithCondition', [SubjectName '/@intra']);
    % find the target average file
    for i=1:length(sStudySrc.Data)
        if strfind(sStudySrc.Data(i).Comment,Condition)
            intra_index=i;
        end;
    end;
    % find indexes of source reconstructions relative to averages only
    average_index=[];
    for i=1:length(sStudySrc.Result)
        if strfind(sStudySrc.Result(i).FileName,'data_average')
            average_index=[average_index i];
        end
    end
    % and choose the one corresponding to the target average
    good_index=average_index(intra_index);
end;

%% 

% Input files, e.g.:
% 'link|S05/@default_study/results_wMNE_MEG_GRAD_MEG_MAG_KERNEL_150605_1307.mat|
%      S05/click1_short/data_1024_average_150528_1733_resample.mat'
sFiles = {sStudySrc.Result(good_index).FileName};

% Start a new report
bst_report('Start', sFiles);

% Process: Z-score normalization: [-200ms,-4ms]
sFiles = bst_process('CallProcess', 'process_zscore_dynamic', sFiles, [], ...
    'baseline', [-0.2, -0.004], ...
    'source_abs', 1, ...
    'dynamic', 1);

% Process: Spatial smoothing (10a)
sFiles = bst_process('CallProcess', 'process_ssmooth', sFiles, [], ...
    'fwhm', 10, ...
    'method', 3, ...  % Average: (euclidian distance + path length) / 2
    'overwrite', 1, ...
    'source_abs', 0);

% Process: Project on default anatomy
sFiles = bst_process('CallProcess', 'process_project_sources', sFiles, []);

% Save and display report
ReportFile = bst_report('Save', sFiles);
bst_report('Open', ReportFile);
