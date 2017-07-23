function trialinfoAll = behAnalysisCalcMEG(subs, condition)

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
    
    %% Plot
    % Variables to plot
    figureDim = [0 0 1 .8];
    figure('units','normalized','outerposition',figureDim)
    
    beh_var_num = [1 2 3 4 5 6 7 8 9 12];
    beh_var_names = {'block', 'operand1', 'operator', 'operand2', 'presResult', 'delay', 'corrResult',...
        'deviant', 'absDeviant','accuracy'};
    for ss = 1:length(beh_var_num)
        subplot(2,5,ss)
        boxplot(trialinfo(:,10),trialinfo(:,beh_var_num(ss)))
        title(beh_var_names{ss})
        axis square
    end
    savePNG(gcf,200, [beh_res_dir_group 'rt_effect_' subs{sub} '_' condition '_.png'])
    close all
    %% Put together
    trialinfoAll{sub} = trialinfo;
    RTextremeAll{sub} = RTextreme;
    clear trialinfo
    clear data
    clear RTextreme
end

%% Plot group
trialinfoALL = vertcat(trialinfoAll{:});
% Variables to plot
figureDim = [0 0 1 .8];
figure('units','normalized','outerposition',figureDim)

beh_var_num = [1 2 3 4 5 6 7 8 9 12];
beh_var_names = {'block', 'operand1', 'operator', 'operand2', 'presResult', 'delay', 'corrResult',...
    'deviant', 'absDeviant','accuracy'};
for ss = 1:length(beh_var_num)
    subplot(2,5,ss)
    boxplot(trialinfoALL(:,10),trialinfoALL(:,beh_var_num(ss)))
    title(beh_var_names{ss})
    axis square
end
savePNG(gcf,200, [beh_res_dir_group 'rt_effect_all_' condition '.png'])
save([beh_res_dir_group 'behavior_data_processed_' condition '.mat'] , 'trialinfoAll', 'trialinfoALL', 'RTextremeAll')

end

