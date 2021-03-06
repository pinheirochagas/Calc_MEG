function CalcMegRSA(subName, condition)
% Script to run time resolved RSA in the Calc MEG data
subName = {'s01', 's02', 's03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15','s16','s17','s18','s19','s21','s22'}
% condition = 'operand1', 'operand2', 'operand12'

%% Define dirs
datadir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/data/mat/';
%datadir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/';
resultsdir = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/data/RSA';
%resultsdit = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/RSA';
stimMatricesdir = ['/Volumes/NeuroSpin4T/Calculation_Pedro_2014/stimuli_analises/results/'];

%% Load dissimilarity matrices
% load([stimMatricesdir '/stimDissimilarityMatrices.mat'])

%% List conditions
conditions = {'operand1', 'operand2', 'corrResult'}; % conditions to average
conditions = {'corrResult'}; % conditions to average

%% Smoothing parameters
KernWidth = 0.05; %%% size in sec of the std of the Gaussian kernel for smoothing the data
nKernStdToInc=4;    % the number of stds of the Gaussian to include when generating the kernel    
opts.KernWidth=KernWidth;
opts.nKernStdToInc=nKernStdToInc;
tOutLims=[-.5 4.5]; % check that! 


for cond = 1%:length(conditions)
    
    %% Loop across subjects
    for sub = 1:length(subName)
        display(['processing ' subName{sub}])
        % Load subject data
        load([datadir subName{sub} '_calc' '.mat']);
        
        % Select trials based on condition
            switch conditions{cond}
                case 'operand1'
                     condStim = [3 4 5 6]; % conditions to average
                case 'operand2'
                     condStim = [0 1 2 3]; % conditions to average
                case 'operand12'
                    % Add here the time locked time series
        %             condOperand12 = [0 1 2 3 4 5 6];
                case 'corrResult'
                     condStim = [1:8]; % conditions to average
                otherwise
            end
        
        %% Smooth the data (in case its not smoothed)
        data.trial = smoothMEG(subName{sub}, 'calc');
        
        %% Average trials for each condition
        for conds = 1:length(condStim)
            trialsCondIdx = arrayfun(@(x) x.(conditions{cond}) == condStim(conds), data.trialinfo, 'UniformOutput', false);
            trialsCond = data.trial(trialsCondIdx{1});
            trialsCond = permute(cell2mat(arrayfun(@(x)permute(x{:},[1 3 2]),trialsCond,'UniformOutput',false)), [2 1 3]);
            for chan = 1:size(data.trial{1},1)
                trialsavg(conds,chan,:) = mean(trialsCond(:,chan,:),1);
            end
        end
        
        %% Calculate the neural dissimilarity matrices
        trialsavg = permute(trialsavg,[2 1 3]);
        % calculate the neural matrices
        for t = 1:size(trialsavg,3)
            %corrmat = 1-corr(trialsavgCondTimeW(:,:,t)); % 1-correlation = dissimilarity matrix
            corrmat = 1-corr(trialsavg(:,:,t), 'type', 'Spearman'); % 1-correlation = dissimilarity matrix
            neuralMatrices(:,:,t) = corrmat;
        end
        clear trialsavg   
        
        %% Calculate the correlation between neural and stim matrices per time point
        % Operand1
        load([stimMatricesdir conditions{cond} '/stimDissimilarityMatrices.mat'])
        for t = 1:size(neuralMatrices,3) % time points
            neuralMatrix = neuralMatrices(:,:,t);
            % Vectorize neural matrix
            count=1;
            for i = 1:length(neuralMatrix)-1
                for j = i+1:length(neuralMatrix)
                    neuralMatrixVZ(count)=neuralMatrix(i,j);
                    count=count+1;
                end
            end
            CorMAG(t) = corr(neuralMatrixVZ', magDistMatrixVZ', 'type', 'Spearman');
            CorVIS(t) = corr(neuralMatrixVZ', visualMatrixVZ','type', 'Spearman');
        end
        clear neuralMatrixVZ
        dataTime = data.time{1};
        clear data
        
        CorMAGallsub(sub,:) = CorMAG;
        CorVISallsub(sub,:) = CorVIS;
        
    end
    CorMAGallsubAllcond{cond} = CorMAGallsub;
    CorVISallsubAllcond{cond} = CorVISallsub;
end

%% PLot results

% Combine matrices
RDmeasures{1} = mean(CorMAGallsubAllcond{1},1);
RDmeasures{2} = mean(CorVISallsubAllcond{1},1);
RDmeasures{3} = mean(CorMAGallsubAllcond{2},1);
RDmeasures{4} = mean(CorVISallsubAllcond{2},1);
% RDmeasures{5} = mean(CorMAGResall,1);
% RDmeasures{6} = mean(CorVISResall,1);
semRDmeasures{1} = std(CorMAGallsubAllcond{1},1)/sqrt(size(CorMAGallsubAllcond{1},1));
semRDmeasures{2} = std(CorVISallsubAllcond{1},1)/sqrt(size(CorVISallsubAllcond{1},1));
semRDmeasures{3} = std(CorMAGallsubAllcond{2},1)/sqrt(size(CorMAGallsubAllcond{2},1));
semRDmeasures{4} = std(CorVISallsubAllcond{2},1)/sqrt(size(CorVISallsubAllcond{2},1));
% semRDmeasures{5} = std(CorMAGResall,1)/sqrt(size(CorMAGResall,1));
% semRDmeasures{6} = std(CorVISResall,1)/sqrt(size(CorVISResall,1));


% RDmeasures{3} = CorRAND;

% RDmeasures{1} = particalCorVIS;
% RDmeasures{2} = particalCorMAG;
% RDmeasures{3} = particalCorRAND;


%% Ploting 
% timePlot = 1:1000


subplot(2,1,1)
hold on
plot(dataTime, RDmeasures{1}, 'LineWidth', 2)
plot(dataTime, RDmeasures{2}, 'LineWidth', 2)
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
plot(dataTime, RDmeasures{3}, 'LineWidth', 2)
plot(dataTime, RDmeasures{4}, 'LineWidth', 2)
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

save2pdf([resultsdir '/RSA_testing_MEG_corrResult_smooth.pdf'], gcf, 600)
%save2pdf([resultsDir 'RSA_testing.pdf'], gcf, 600)



% Define timepoints
for i = 1:length(RDmeasures);
    hold on
    plot(dataTime(timePlot), RDmeasures{i}(timePlot), 'LineWidth', 2)
end

%% Make a movie of the neural matrix
for j = 1:length(RDmeasures{1})
    imagesc(neuralMatrices(:,:,j))
    title(['Neural matrix time: ', num2str(dataTime(j))])
%     title(['Neural matrix time: ', num2str(data.time(timePlot(j)))])
    set(gca, 'XTick', 1:length(neuralMatrices(:,:,j)));
    set(gca, 'YTick', 1:length(neuralMatrices(:,:,j)));
%     set(gca, 'Xticklabels', conditions)
%     set(gca, 'Yticklabels', conditions)
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
