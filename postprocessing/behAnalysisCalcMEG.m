function behAnalysisCalcMEG(subs)

%% Paths
addPathInitDirsMEGcalc
figures_path = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/behavior/';

%% Load response key
load('response.mat')
response(22,2) = 2
response = response([1:19 21 22],:) %% correct that just once

%% Loop accross subjects
for sub = 1:length(subs)
    %% Load data
    load([datapath subs{sub} '_calc.mat'])
    trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    
    %% Add accuracy
    for ii = 1:size(trialinfo,1)
        if response(sub,2) == 1
            if trialinfo(ii,1) < 6
                if (trialinfo(ii,8) == 0 && trialinfo(ii,11) == -1) || (trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == 1)
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            else
                if (trialinfo(ii,8) == 0 && trialinfo(ii,11) == 1) || (trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == -1)
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            end
        else
            if trialinfo(ii,1) < 6
                if (trialinfo(ii,8) == 0 && trialinfo(ii,11) == 1) || (trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == -1)
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            else
                if (trialinfo(ii,8) == 0 && trialinfo(ii,11) == -1) || (trialinfo(ii,8) ~= 0 && trialinfo(ii,11) == 1)
                    trialinfo(ii,12) = 1;
                else
                    trialinfo(ii,12) = 0;
                end
            end
        end
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
    savePNG(gcf,200, [figures_path 'rt_effect_' subs{sub} '_.png'])
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
savePNG(gcf,200, [figures_path 'rt_effect_all_.png'])
save([figures_path 'behavior_data_processed.m'] , 'trialinfoAll', 'trialinfoALL', 'RTextremeAll')


end

