function btsAVGtrialsByCond(subjects, conditions)
%% Average trials whiting brainstorm
% subjects = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'};
% conditions = {'TFA_2_audio','TFA_2_noaudio'};

%% Initialize dirs and paths
InitializeDirsMEGcalc


%% Loop across subjects and conditions
for cond = 1 : length(conditions);
    for subi = 1 : length(subjects);  % loop across sub
        
        % get data bst structure
        sStudy = bst_get('StudyWithCondition', [subjects{subi}  '/' conditions{cond}]);
        % get FileNames and Comments of all good trials, discarding the bad ones
        isGoodTrial = ~[sStudy.Data.BadTrial];
        FileNames = {sStudy.Data(isGoodTrial).FileName};
        Comments = {sStudy.Data(isGoodTrial).Comment};
        
        % path
%         resultFile = dir([bst_db_data_dir subjects{subi} '/@default_study/results_MN_MEG_GRAD_MEG_MAG_KERNEL_170131_*.mat']);
%         resultFile = resultFile.name;
%         path = ['link|' subjects{subi} '/@default_study/' resultFile '|'];
        
        % get all trials but averages
        sFiles = [];
        i = 1;
        for tr=1:length(FileNames);
            if ~strcmp(Comments{tr}(1:3),'Avg');
                sFiles{i} = FileNames{tr};
%                 sFiles{i} = [path FileNames{tr}];
                i = i+1;
            else
                disp(['trial ' FileNames{tr} ' not included because it is an average']);
            end;
        end;
        
        %Start a new report
        bst_report('Start', sFiles);
        
        % Process: Average: Everything
        sFiles = bst_process('CallProcess', 'process_average', sFiles, [], ...
            'avgtype',    1, ...  % Everything
            'avg_func',   1, ...  % Arithmetic average:  mean(x)
            'weighted',   0, ...
            'keepevents', 0);
        
        % Save and display report
        ReportFile = bst_report('Save', sFiles);
        bst_report('Open', ReportFile);
        % bst_report('Export', ReportFile, ExportDir);

    end
end
