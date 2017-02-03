function source_z_sm_group(subjects,conditions, method)
%% Source: calculate z-score from baseline, spatial smooth and project to group analysis 
% subjects = 's01';
% conditions = 'addsub_opall';
% Intra (0 - no ned for intra- or 1 - look into intra-)

%% Loop across subjects and conditions
for cond = 1 : length(conditions);
    for subi = 1 : length(subjects);  % loop across sub
        
        [sStudySrc, iStudySrc] = bst_get('StudyWithCondition', [subjects{subi} '/' conditions{cond}]);
        for i=1:length(sStudySrc.Result)
            if strfind(sStudySrc.Result(i).FileName,'average') & strfind(sStudySrc.Result(i).FileName,method) % MN for wMNE or dSPM
                good_index=i;
            end;
        end;
        
        %%
        % Input files, e.g.:
        % 'link|S05/@default_study/results_wMNE_MEG_GRAD_MEG_MAG_KERNEL_150605_1307.mat|
        %      S05/click1_short/data_1024_average_150528_1733_resample.mat'
        sFiles = {sStudySrc.Result(good_index).FileName};
        
        % Start a new report
        bst_report('Start', sFiles);
        
        %% Process: Z-score normalization: [-500ms,-4ms]
        sFiles = bst_process('CallProcess', 'process_zscore_dynamic', sFiles, [], ...
            'baseline', [-0.5, -0.004], ...
            'source_abs', 1, ...
            'dynamic', 1);
        
        %% Process: Spatial smoothing (10a)
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
    end
end


end








% if intra==0
%     [sStudySrc, iStudySrc] = bst_get('StudyWithCondition', [subjects '/' conditions]);
%     for i=1:length(sStudySrc.Result)
%         if strfind(sStudySrc.Result(i).FileName,'average') % wMNE
%             good_index=i;
%         end;
%     end;
% else
%     % look into @intra folder.
%     [sStudySrc, iStudySrc] = bst_get('StudyWithCondition', [subjects '/@intra']);
%     % find the target average file
%     for i=1:length(sStudySrc.Data)
%         if strfind(sStudySrc.Data(i).Comment,conditions)
%             intra_index=i;
%         end;
%     end;
%     % find indexes of source reconstructions relative to averages only
%     average_index=[];
%     for i=1:length(sStudySrc.Result)
%         if strfind(sStudySrc.Result(i).FileName,'data_average')
%             average_index=[average_index i];
%         end
%     end
%     % and choose the one corresponding to the target average
%     good_index=average_index(intra_index);
% end;

