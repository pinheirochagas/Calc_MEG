%% Set paths and directories
AddPathsMEGcalc
InitDirsMEGcalc

% Load operations
load([rsa_result_dir 'stim_matrices/allop.mat'])

%% Operand 1
RDM.op1_mag = zeros(32);
for i = 1:size(RDM.op1_mag,1)
    for j = 1:size(RDM.op1_mag,2)
        RDM.op1_mag(i,j) = abs(str2num(allop{i}(1)) - str2num(allop{j}(1)));
    end
end

%% Operand 2
RDM.op2_mag = zeros(32);
for i = 1:size(RDM.op2_mag,1)
    for j = 1:size(RDM.op2_mag,2)
        RDM.op2_mag(i,j) = abs(str2num(allop{i}(3)) - str2num(allop{j}(3)));
    end
end

%% Operator
RDM.operator = zeros(32);
for i = 1:size(RDM.operator,1)
    for j = 1:size(RDM.operator,2)
        RDM.operator(i,j) = allop{i}(2) ~= allop{j}(2);
    end
end

%% Result
RDM.result_mag = zeros(32);
for i = 1:size(RDM.result_mag,1)
    for j = 1:size(RDM.result_mag,2)
        RDM.result_mag(i,j) = abs(str2num(allop{i}) - str2num(allop{j}));
    end
end


%% Visual models
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/stimuli_analises/image_similarity_toolbox-master/'
imageDir = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/stimuli_analises/images'
imageDirAll = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/stimuli_analises/images/all'


[F word_map RDM_visual img_categories] = img_sim(imageDir, 8, 1, 1, 1, 5)
close all
subplot(2,1,1)
imagesc(RDM_visual)
title('dissimilarity matrix garbor')
set(gca, 'XTick', 1:4);
set(gca, 'YTick', 1:4);
set(gca, 'Xticklabels', 3:6)
set(gca, 'Yticklabels', 3:6)
set(gca, 'FontSize', 18)
axis square
colorbar

load('/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/RSA/stim_matrices/calc_RDM_matrices_jaccard.mat', 'jaccardMAT');
jaccardMAT(isnan(jaccardMAT)) = 0;

%% COmpare jaccart and gabor
count = 1
for i = 1:length(RDM_visual)-1
    for j = i+1:length(RDM_visual)
        RDM_visualVZ(count)=RDM_visual(i,j);
        jaccardMATVZ(count)=jaccardMAT(i,j);
        count=count+1;
    end
end

%%
RDM.op1_vis = zeros(32);
for i = 1:size(RDM.op1_vis,1)
    for j = 1:size(RDM.op1_vis,2)
        RDM.op1_vis(i,j) = RDM_visual(str2num(allop{i}(1))+1,str2num(allop{j}(1))+1);
        RDM.op1_vis_jc(i,j) = jaccardMAT(str2num(allop{i}(1))+1,str2num(allop{j}(1))+1);
    end
end

%% Operand 2
RDM.op2_vis = zeros(32);
for i = 1:size(RDM.op2_vis,1)
    for j = 1:size(RDM.op2_vis,2)
        RDM.op2_vis(i,j) = RDM_visual(str2num(allop{i}(3))+1,str2num(allop{j}(3))+1);
        RDM.op2_vis_jc(i,j) = jaccardMAT(str2num(allop{i}(3))+1,str2num(allop{j}(3))+1);
    end
end

%% Result
RDM.result_vis = zeros(32);
for i = 1:size(RDM.result_vis,1)
    for j = 1:size(RDM.result_vis,2)
        RDM.result_vis(i,j) = RDM_visual(str2num(allop{i})+1,str2num(allop{j})+1);
        RDM.result_vis_jc(i,j) = jaccardMAT(str2num(allop{i})+1,str2num(allop{j})+1);
    end
end

%% Save 
save([rsa_result_dir 'stim_matrices/calc_RDM_matrices.mat'], 'RDM')

load([rsa_result_dir 'stim_matrices/calc_RDM_matrices.mat'], 'RDM')


%% Plotting
fieldnames_RDM = fieldnames(RDM);
fieldnames_RDM = fieldnames_RDM(~strcmp(fieldnames_RDM,'operator'));
figureDim = [0 0 1 1];
figure('units','normalized','outerposition',figureDim)
count = 1;
for s = [1 2 3 4 5 6]
    subplot(2,3,count)
    imagesc(RDM.(fieldnames_RDM{s}))
%     title(fieldnames_RDM{s}, 'interpreter', 'none')
    axis square
    set(gca,'XTick',1:1:32)
    set(gca,'XTickLabel',allop);
    set(gca,'XaxisLocation','top')
    set(gca,'XTickLabelRotation',-90)
    set(gca,'YTick',1:1:32)
    set(gca,'YTickLabel',allop);
    count = count+1;
end
% Save
savePNG(gcf,200, [rsa_result_dir 'stim_matrices/calc_RDM_matrices.png'])
savePNG(gcf,200, [rsa_result_dir 'stim_matrices/calc_RDM_matric_operator.png'])



% %% Magnitude
% RDM_number = zeros(10,10)
% for i  = -9:9
%     RDM_number = RDM_number + triu(ones(10,10),i)
% end
% RDM_number = abs(RDM_number - 10)
% imagesc(RDM_number)







