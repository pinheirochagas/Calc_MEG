function CalcMegRSA(subName, condition)
% Script to run time resolved RSA in the Calc MEG data
subName = {'s01', 's02', 's03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15','s16','s17','s18','s19','s21','s22'}
% condition = 'operand1', 'operand2', 'operand12'

%% Define dirs
datadir = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/mat/';
%datadir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/';
resultsdir = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/RSA';
%resultsdit = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/RSA';
stimMatricesdir = ['/Volumes/NeuroSpin2T/Calculation_Pedro_2014/stimuli_analises/results/'];

%% Load dissimilarity matrices
% load([stimMatricesdir '/stimDissimilarityMatrices.mat'])

%% List conditions
conditions = {'operand1', 'operand2', 'presRestul'}; % conditions to average



%% Loop across subjects
for sub = 1:length(subName)
    % Load subject data
    load([datadir subName{sub} '_calc' '.mat']);

    %% Select trials based on condition
%     switch condition
%         case 'operand1'
% %             condOperand1 = [3 4 5 6]; % conditions to average
%         case 'operand2'
%             % Pick only the calculation trials
%             operand2 = vertcat(data.trialinfo.Operand2)';
%             dataOp2.trial = data.trial(operand2 ~= 33); % Exclude comparison trials
%             dataOp2.trialinfo = structfun(@(x) (x(operand2 ~= 33)), data.trialinfo, 'UniformOutput', false);        
% %             condOperand2 = [0 1 2 3];
%         case 'operand12'
%             % Add here the time locked time series
% %             condOperand12 = [0 1 2 3 4 5 6];
%         otherwise    
%     end
    
    %% Smooth the data (in case its not smoothed)

    %% Average trials for each condition
    % Operand1
    condOperand1 = [3 4 5 6]; % conditions to average
    for conds = 1:length(condOperand1)
        trialsCondIdx = arrayfun(@(x) x.operand1 == condOperand1(conds), data.trialinfo, 'UniformOutput', false);
        trialsCond = data.trial(trialsCondIdx{1});
        trialsCond = permute(cell2mat(arrayfun(@(x)permute(x{:},[1 3 2]),trialsCond,'UniformOutput',false)), [2 1 3]);
        for chan = 1:size(data.trial{1},1)
            trialsavgOperand1(conds,chan,:) = mean(trialsCond(:,chan,:),1);        
        end
    end
    % Operand 2
    condOperand2 = [0 1 2 3]; % conditions to average
    for conds = 1:length(condOperand2)
        trialsCondIdx = arrayfun(@(x) x.operand2 == condOperand2(conds), data.trialinfo, 'UniformOutput', false);
        trialsCond = data.trial(trialsCondIdx{1});
        trialsCond = permute(cell2mat(arrayfun(@(x)permute(x{:},[1 3 2]),trialsCond,'UniformOutput',false)), [2 1 3]);
        for chan = 1:size(data.trial{1},1)
            trialsavgOperand2(conds,chan,:) = mean(trialsCond(:,chan,:),1);        
        end
    end
    % Result
    condpresResult = [0 1 2 3 4 5 6 7 8 9]; % conditions to average
    for conds = 1:length(condpresResult)
        trialsCondIdx = arrayfun(@(x) x.presResult == condpresResult(conds), data.trialinfo, 'UniformOutput', false);
        trialsCond = data.trial(trialsCondIdx{1});
        trialsCond = permute(cell2mat(arrayfun(@(x)permute(x{:},[1 3 2]),trialsCond,'UniformOutput',false)), [2 1 3]);
        for chan = 1:size(data.trial{1},1)
            trialsavgpresResult(conds,chan,:) = mean(trialsCond(:,chan,:),1);        
        end
    end

    %% Calculate the neural dissimilarity matrices
    trialsavgOperand1 = permute(trialsavgOperand1,[2 1 3]);
    % calculate the neural matrices
    for t = 1:size(trialsavgOperand1,3)
        %corrmat = 1-corr(trialsavgCondTimeW(:,:,t)); % 1-correlation = dissimilarity matrix
        corrmat = 1-corr(trialsavgOperand1(:,:,t), 'type', 'Spearman'); % 1-correlation = dissimilarity matrix
        neuralMatricesOp1(:,:,t) = corrmat;
    end
    clear trialsavgOperand1
    
    trialsavgOperand2 = permute(trialsavgOperand2,[2 1 3]);
    % calculate the neural matrices
    for t = 1:size(trialsavgOperand2,3)
        %corrmat = 1-corr(trialsavgCondTimeW(:,:,t)); % 1-correlation = dissimilarity matrix
        corrmat = 1-corr(trialsavgOperand2(:,:,t), 'type', 'Spearman'); % 1-correlation = dissimilarity matrix
        neuralMatricesOp2(:,:,t) = corrmat;
    end
    clear trialsavgOperand2
    
    trialsavgpresResult = permute(trialsavgpresResult,[2 1 3]);
    % calculate the neural matrices
    for t = 1:size(trialsavgpresResult,3)
        %corrmat = 1-corr(trialsavgCondTimeW(:,:,t)); % 1-correlation = dissimilarity matrix
        corrmat = 1-corr(trialsavgpresResult(:,:,t), 'type', 'Spearman'); % 1-correlation = dissimilarity matrix
        neuralMatricespresResult(:,:,t) = corrmat;
    end
    clear trialsavgpresResult

    
    %% Calculate the correlation between neural and stim matrices per time point
    % Operand1
    load([stimMatricesdir 'operand1/stimDissimilarityMatricesOp1.mat'])
    for t = 1:size(neuralMatricesOp1,3) % time points
        neuralMatrix = neuralMatricesOp1(:,:,t);
        % Vectorize neural matrix
        count=1;
        for i = 1:length(neuralMatrix)-1
            for j = i+1:length(neuralMatrix)
                neuralMatrixVZ(count)=neuralMatrix(i,j);
                count=count+1;
            end
        end
          CorMAGOp1(t) = corr(neuralMatrixVZ', magDistMatrixVZ', 'type', 'Spearman');
          CorVISOp1(t) = corr(neuralMatrixVZ', visualMatrixVZ','type', 'Spearman');
    end
    clear neuralMatrixVZ
    % Operand2 
    load([stimMatricesdir 'operand2/stimDissimilarityMatricesOp2.mat'])
    %% Calculate the correlation between neural and stim matrices per time point
    for t = 1:size(neuralMatricesOp2,3) % time points
        neuralMatrix = neuralMatricesOp2(:,:,t);
        % Vectorize neural matrix
        count=1;
        for i = 1:length(neuralMatrix)-1
            for j = i+1:length(neuralMatrix)
                neuralMatrixVZ(count)=neuralMatrix(i,j);
                count=count+1;
            end
        end
          CorMAGOp2(t) = corr(neuralMatrixVZ', magDistMatrixVZ', 'type', 'Spearman');
          CorVISOp2(t) = corr(neuralMatrixVZ', visualMatrixVZ','type', 'Spearman');
    end
    clear neuralMatrixVZ
    % preResult 
    load([stimMatricesdir 'presResult/stimDissimilarityMatricesPresResult.mat'])
    %% Calculate the correlation between neural and stim matrices per time point
    for t = 1:size(neuralMatricespresResult,3) % time points
        neuralMatrix = neuralMatricespresResult(:,:,t);
        % Vectorize neural matrix
        count=1;
        for i = 1:length(neuralMatrix)-1
            for j = i+1:length(neuralMatrix)
                neuralMatrixVZ(count)=neuralMatrix(i,j);
                count=count+1;
            end
        end
          CorMAGRes(t) = corr(neuralMatrixVZ', magDistMatrixVZ', 'type', 'Spearman');
          CorVISRes(t) = corr(neuralMatrixVZ', visualMatrixVZ','type', 'Spearman');
    end
    clear neuralMatrixVZ
    
    CorMAGOp1all(sub,:) = CorMAGOp1; 
    CorVISOp1all(sub,:) = CorVISOp1;
    CorMAGOp2all(sub,:) = CorMAGOp2; 
    CorVISOp2all(sub,:) = CorVISOp2; 
    CorMAGResall(sub,:) = CorMAGRes; 
    CorVISResall(sub,:) = CorVISRes; 
    
end

%% PLot results

% Combine matrices
RDmeasures{1} = mean(CorMAGOp1all,1);
RDmeasures{2} = mean(CorVISOp1all,1);
RDmeasures{3} = mean(CorMAGOp2all,1);
RDmeasures{4} = mean(CorVISOp2all,1);
RDmeasures{5} = mean(CorMAGResall,1);
RDmeasures{6} = mean(CorVISResall,1);
semRDmeasures{1} = std(CorMAGOp1all,1)/sqrt(size(CorMAGOp1all,1));
semRDmeasures{2} = std(CorVISOp1all,1)/sqrt(size(CorVISOp1all,1));
semRDmeasures{3} = std(CorMAGOp2all,1)/sqrt(size(CorMAGOp2all,1));
semRDmeasures{4} = std(CorVISOp2all,1)/sqrt(size(CorVISOp2all,1));
semRDmeasures{5} = std(CorMAGResall,1)/sqrt(size(CorMAGResall,1));
semRDmeasures{6} = std(CorVISResall,1)/sqrt(size(CorVISResall,1));


% RDmeasures{3} = CorRAND;

% RDmeasures{1} = particalCorVIS;
% RDmeasures{2} = particalCorMAG;
% RDmeasures{3} = particalCorRAND;


%% Ploting 
% timePlot = 1:1000


subplot(2,1,1)
hold on
plot(data.time{1}, RDmeasures{1}, 'LineWidth', 2)
plot(data.time{1}, RDmeasures{2}, 'LineWidth', 2)
%xlim([-.2 1.5])
ylim([-.5 .5])
line([0 0], ylim, 'Color', 'k', 'LineWidth', 2);
line([1.6 1.6], ylim, 'Color', 'k', 'LineWidth', 2);
line(xlim,[0 0], 'Color', 'k', 'LineWidth', 2 ,'LineStyle', ':');
set(gca, 'FontSize', 18)
legend('Magnitude', 'Visual')
xlabel('Times sec.')
ylabel('rho')
title('Operand 1')

subplot(2,1,2)
hold on
plot(data.time{1}, RDmeasures{3}, 'LineWidth', 2)
plot(data.time{1}, RDmeasures{4}, 'LineWidth', 2)
% xlim([-.2 1.5])
ylim([-.5 .5])
line([0 0], ylim, 'Color', 'k', 'LineWidth', 2);
line([1.6 1.6], ylim, 'Color', 'k', 'LineWidth', 2);
line(xlim,[0 0], 'Color', 'k', 'LineWidth', 2 ,'LineStyle', ':');
set(gca, 'FontSize', 18)
legend('Magnitude', 'Visual')
xlabel('Times sec.')
ylabel('rho')
title('Operand 2')

save2pdf([resultsdir '/RSA_testing_MEG_op1-op2.pdf'], gcf, 600)
%save2pdf([resultsDir 'RSA_testing.pdf'], gcf, 600)



% Define timepoints
for i = 1:length(RDmeasures);
    hold on
    plot(data.time{1}(timePlot), RDmeasures{i}(timePlot), 'LineWidth', 2)
end

%% Make a movie of the neural matrix
for j = 1:length(RDmeasures{1})
    imagesc(neuralMatrices(:,:,j))
    title(['Neural matrix time: ', num2str(data.time(timePlot(j)))])
    set(gca, 'XTick', 1:length(neuralMatrices(:,:,j)));
    set(gca, 'YTick', 1:length(neuralMatrices(:,:,j)));
    set(gca, 'Xticklabels', conditions)
    set(gca, 'Yticklabels', conditions)
    set(gca, 'FontSize', 18)
    axis square
    set(gcf,'color','w');
    F(j) = getframe(gcf);
end

% test movie
fig = figure;
movie(fig,F,1)


videoRSA = VideoWriter([resultsDir 'videoRSA_context.avi']);
uncompressedVideo = VideoWriter([resultsDir 'videoRSA_contex.avi'], 'Uncompressed AVI');
videoRSA.FrameRate = 15;  % Default 30
videoRSA.Quality = 100;    % Default 75
open(videoRSA);
writeVideo(videoRSA, F);
close(videoRSA);






%% Reshape to channelsXtrials 
dataReshape = cell2mat(arrayfun(@(x)permute(x{:},[1 3 2]),data.trial,'UniformOutput',false));

cell2mat(arrayfun(@(x)permute(x{:},[1 3 2]),data.trial,'UniformOutput',false))




reshape(triu(corrmat),1, size())

b = corrmat(find(~triu(ones(size(corrmat)))))'


v = reshape(triu(corrmat,1),1,numel(corrmat));



a = plot(GlobalCorrmatSub(1,:,:), GlobalCorrmatSub(2,:,:))

















% Save data
save([data_fieldtrip_dir subjectname '_selected.mat'], 'data')
