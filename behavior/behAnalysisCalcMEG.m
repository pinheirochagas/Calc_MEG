function [trialinfoAll,table_deviant, table_correctness, table_operand1, table_operand2, table_operation, table_operand1_sep_op, table_operand2_sep_op] = behAnalysisCalcMEG(subs, condition)



%% Paths
InitDirsMEGcalc	
figures_path = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/results/behavior/';

%% Load response key
load('response_key.mat')

%% Loop accross subjects
for sub = 1:length(subs)
    %% Load data
    load([data_dir subs{sub} '_calc_lp30.mat'])
    trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    % Take only correct trials 
    trialinfo = trialinfo(trialinfo(:,12) == 1,:);
    % Select calc or comp
    if strcmp(condition, 'calc')
        trialinfo = trialinfo(trialinfo(:,3) ~= 0,:);
    elseif strcmp(condition, 'comp')
        trialinfo = trialinfo(trialinfo(:,3) == 0,:);
    elseif strcmp(condition, 'add')
        trialinfo = trialinfo(trialinfo(:,3) == 1,:);
    elseif strcmp(condition, 'sub')
        trialinfo = trialinfo(trialinfo(:,3) == -1,:);
    end      
   
    %% Trimming
    RTmax = data.time(end);
    %% Math
    RTCalc = trialinfo(:,10);
    mean_RTCalc = mean(RTCalc); % Already excluding RT > then max
    std_RTCalc = std(RTCalc);
    RTtrim = 3; % Trimming factor
    for i = 1:length(RTCalc)
        if RTCalc(i) >= mean_RTCalc+RTtrim*std_RTCalc || RTCalc(i) <= mean_RTCalc-RTtrim*std_RTCalc || RTCalc(i) < 100 %
            RTextreme(i) = 1;
        else
            RTextreme(i) = 0;
        end;
    end
    trialinfo = trialinfo(RTextreme==0,:);
    
%     %% Plot
%     % Variables to plot
%     figureDim = [0 0 1 .8];
%     figure('units','normalized','outerposition',figureDim)
%     
%     beh_var_num = [1 2 3 4 5 6 7 8 9 12];
%     beh_var_names = {'block', 'operand1', 'operator', 'operand2', 'presResult', 'delay', 'corrResult',...
%         'deviant', 'absDeviant','accuracy'};
%     for ss = 1:length(beh_var_num)
%         subplot(2,5,ss)
%         boxplot(trialinfo(:,10),trialinfo(:,beh_var_num(ss)))
%         title(beh_var_names{ss})
%         axis square
%     end
%     savePNG(gcf,200, [beh_res_dir_group 'rt_effect_' subs{sub} '_' condition '_.png'])
%     close all
    %% Put together
    trialinfoAll{sub} = trialinfo;
    RTextremeAll{sub} = RTextreme;
    clear trialinfo
    clear data
    clear RTextreme
end

% %% Plot group
% trialinfoALL = vertcat(trialinfoAll{:});
% 
% % Variables to plot
% figureDim = [0 0 1 .8];
% figure('units','normalized','outerposition',figureDim)
% 
% beh_var_num = [1 2 3 4 5 6 7 8 9 12];
% beh_var_names = {'block', 'operand1', 'operator', 'operand2', 'presResult', 'delay', 'corrResult',...
%     'deviant', 'absDeviant','accuracy'};
% for ss = 1:length(beh_var_num)
%     subplot(2,5,ss)
%     boxplot(trialinfoALL(:,10),trialinfoALL(:,beh_var_num(ss)))
%     title(beh_var_names{ss})
%     axis square
% end
% savePNG(gcf,200, [beh_res_dir_group 'rt_effect_all_' condition '.png'])
% save([beh_res_dir_group 'behavior_data_processed_' condition '.mat'] , 'trialinfoAll', 'trialinfoALL', 'RTextremeAll')

%% Group stats
for s = 1:length(subs)
    table_beh = array2table(trialinfoAll{s});
    table_beh(:,14) = table_beh(:,9);
    table_beh.Var14(table_beh.Var14>0) = 1;

    table_beh.Properties.VariableNames = {'block', 'operand1', 'operator', 'operand2', 'presResult', 'delay', 'corrResult',...
        'deviant', 'absDeviant', 'RT', 'respSide', 'accuracy', 'correct_choice', 'correctness'};

    % Deviant
    group_absDeviant = grpstats(table_beh, 'absDeviant');
    RT = group_absDeviant.mean_RT;
    absDeviant = group_absDeviant.absDeviant;
    correctness = [1 0 0 0 0]';
    parity = [1 0 1 0 1]';
    subject = repmat(s, length(absDeviant), 1);
    table_deviant{s} = table(subject, absDeviant, correctness, parity, RT);
    
    % Correctness 
    group_correctness = grpstats(table_beh, 'correctness');
    RT = group_correctness.mean_RT;
    correctness = group_correctness.correctness;
    subject = repmat(s, length(correctness), 1);
    table_correctness{s} = table(subject, correctness, RT);

    % Operand 1
    group_op1 = grpstats(table_beh, 'operand1');
    RT = group_op1.mean_RT;
    operand1 = group_op1.operand1;
    subject = repmat(s, length(operand1), 1);
    table_operand1{s} = table(subject, operand1, RT);

    % Operand 2
    group_op2 = grpstats(table_beh, 'operand2');
    RT = group_op2.mean_RT;
    operand2 = group_op2.operand2;
    subject = repmat(s, length(operand2), 1);
    table_operand2{s} = table(subject, operand2, RT);
    
    % Operation
    group_operation = grpstats(table_beh, 'operator');
    RT = group_operation.mean_RT;
    operation = group_operation.operator;
    subject = repmat(s, length(operation), 1);
    table_operation{s} = table(subject, operation, RT);
    
    % Operand 1 - separate by operation
    group_op1 = grpstats(table_beh, {'operand1', 'operator'});
    RT = group_op1.mean_RT;
    operand1 = group_op1.operand1;
    operation = group_op1.operator;
    subject = repmat(s, length(operation), 1);
    table_operand1_sep_op{s} = table(subject, operand1, operation, RT);

    % Operand 2
    group_op2 = grpstats(table_beh, {'operand2', 'operator'});
    RT = group_op2.mean_RT;
    operand2 = group_op2.operand2;
    operation = group_op2.operator;
    subject = repmat(s, length(operand2), 1);
    table_operand2_sep_op{s} = table(subject, operand2, operation, RT);
    
end

% Concat tables
table_deviant = vertcat(table_deviant{:});
table_correctness = vertcat(table_correctness{:});
table_operand1 = vertcat(table_operand1{:});
table_operand2 = vertcat(table_operand2{:});
table_operation = vertcat(table_operation{:});
table_operand1_sep_op = vertcat(table_operand1_sep_op{:});
table_operand2_sep_op = vertcat(table_operand2_sep_op{:});

end

