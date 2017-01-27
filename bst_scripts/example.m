subject = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'};
condition = {'TFA_2_audio','TFA_2_noaudio'};

for cond = 1 : length(condition);
    for subi = 1 : length(subject);  % loop across sub

        % get data bst structure
        sStudy = bst_get('StudyWithCondition', [subject{subi}  '/' condition{cond}]);
        % get FileNames and Comments of all good trials, discarding the bad ones
        isGoodTrial = ~[sStudy.Data.BadTrial];
        FileNames = {sStudy.Data(isGoodTrial).FileName};
        Comments = {sStudy.Data(isGoodTrial).Comment};

        % path
        resultFile = dir(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/scripts/brainstorm/brainstorm_db_imported/SemdimFull/data/' subject{subi} '/@default_study/results_MN_MEG_GRAD_MEG_MAG_KERNEL_160510_*.mat']);
        resultFile = resultFile.name;
        path = ['link|' subject{subi} '/@default_study/' resultFile '|'];

        % get all trials but averages and not downsampled (retrieved by the associated Comment)
        sFiles = [];
        i = 1;
        for tr=1:length(FileNames);
            if ~strcmp(Comments{tr}(1:3),'Avg');
                 if strfind(Comments{tr},'250Hz')>0;
                    sFiles{i} = [path FileNames{tr}];
                    i = i+1;
                 else
                     disp(['trial ' FileNames{tr} ' not included because is not right sampling']);
                 end
            else
                 disp(['trial ' FileNames{tr} ' not included because it is an average']);
            end;
        end;

        %Start a new report
        bst_report('Start', sFiles);
        
        
        
        % do whathever you need on sFiles
        
    end
end
