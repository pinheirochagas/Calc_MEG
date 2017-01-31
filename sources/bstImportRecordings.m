function bstImportRecordings(subjects)
%% Import data from fieldtrip to brainstorm for source localization


%% Initialize directories
InitializeDirsMEGcalc

for s = 1:length(subjects)
    %% Import MEG recordigns
    %Load subject's data
    subject = subjects{s};
    
    load([data_dir subject '_calc_AICA.mat'], 'data')
    % Add accuracy info to trailinfo
    trialinfo = addAccuracy(subject);
    data.trialinfo = trialinfo; % Substiture original with the one of accuracy
    
    %Choose which condition to import
    % params = [];
    % tasklab = {'all', 'noRot', 'rot'};
    % vislab = {'all', 'v1', 'seen'};
    % poslab = {'all', 'present', 'absent'};
    % acc = {'all', 'correct', 'incorrect'};
    
    %% Define conditions to add using an automatic way
    cond_lab = {'add', 'sub', 'addsub'};
    op_lab = {'opall', 'op1_3', 'op1_4', 'op1_5', 'op1_6', 'op2_0', 'op2_1', 'op2_2', 'op2_3', 'cRes_3', 'cRes_4', 'cRes_5', 'cRes_6'};
    
    %% For each condition, save trial data following brainstorm's structure
    for condi = 1:length(cond_lab)
        for opi = 1:length(op_lab)
            params.cond_lab = cond_lab{condi};
            params.op_lab = op_lab{opi};
            
            % Set condition
            ConditionName = [params.cond_lab '_' params.op_lab];
            pathToCondition = [bst_db_data_dir subject '/' ConditionName];
            
            selectTrl = find(calc_makeConditions(params, data));
            disp(length(selectTrl));
            
            if ~isempty(selectTrl)
                mkdir(pathToCondition); %create a folder in which the trial data will be saved
                for triali = 1 : length(selectTrl)
                    NumTrl = num2str(triali);
                    if length(NumTrl) == 1
                        NumTrl = ['00' NumTrl];
                    else
                        NumTrl = ['0' NumTrl];
                    end
                    
                    %Set up brainstrom structure for single trials
                    F = data.trial{selectTrl(triali)};
                    Comment = [ConditionName ' (#' num2str(triali) ')'];
                    ChannelFlag = ones(306, 1);
                    Time = data.time{1}; %this works only if all trials have the same timing
                    DataType = 'recordings';
                    Device = 'Neuromag';
                    nAvg = 1;
                    Events = [];
                    History = [];
                    
                    %Save the structure in a mat file
                    save([pathToCondition '/' 'data_' ConditionName '_trial' NumTrl '.mat'], 'F', 'Comment', 'ChannelFlag', 'Time', 'DataType', 'Device', 'nAvg', 'Events', 'History');
                end
                
                BadTrials = [];
                DateOfStudy = date;
                Name = ConditionName;
                save([pathToCondition '/' 'brainstormstudy.mat'], 'BadTrials', 'DateOfStudy', 'Name');
            else
                disp(['Skipping: ' 'bst_' subject '_' params.cond_lab '_' params.op_lab '.mat']);
            end
        end
    end
end
end
