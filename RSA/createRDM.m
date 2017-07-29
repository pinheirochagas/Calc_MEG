%% Set paths and directories
AddPathsMEGcalc
InitDirsMEGcalc

% Load operations
load([rsa_result_dir 'stim_matrices/allop.mat'])
load([rsa_result_dir 'stim_matrices/allop_cres_3456.mat'])


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
%         RDM.op1_vis_jc(i,j) = jaccardMAT(str2num(allop{i}(1))+1,str2num(allop{j}(1))+1);
    end
end

%% Operand 2
RDM.op2_vis = zeros(32);
for i = 1:size(RDM.op2_vis,1)
    for j = 1:size(RDM.op2_vis,2)
        RDM.op2_vis(i,j) = RDM_visual(str2num(allop{i}(3))+1,str2num(allop{j}(3))+1);
%         RDM.op2_vis_jc(i,j) = jaccardMAT(str2num(allop{i}(3))+1,str2num(allop{j}(3))+1);
    end
end

%% Result
RDM.result_vis = zeros(32);
for i = 1:size(RDM.result_vis,1)
    for j = 1:size(RDM.result_vis,2)
        RDM.result_vis(i,j) = RDM_visual(str2num(allop{i})+1,str2num(allop{j})+1);
%         RDM.result_vis_jc(i,j) = jaccardMAT(str2num(allop{i})+1,str2num(allop{j})+1);
    end
end



%% For correct result 3 4 5 6 
load([rsa_result_dir 'stim_matrices/allop_cres_3456.mat'])
%% Result
RDM.result_mag = zeros(length(allop_cres_3456));
for i = 1:size(RDM.result_mag,1)
    for j = 1:size(RDM.result_mag,2)
        RDM.result_mag(i,j) = abs(str2num(allop_cres_3456{i}) - str2num(allop_cres_3456{j}));
    end
end

%% Operator
RDM.operator = zeros(length(allop_cres_3456));
for i = 1:size(RDM.operator,1)
    for j = 1:size(RDM.operator,2)
        RDM.operator(i,j) = allop_cres_3456{i}(2) ~= allop_cres_3456{j}(2);
    end
end

save([rsa_result_dir 'stim_matrices/calc_RDM_matrices_cres3456.mat'], 'RDM')


%% Plotting
fieldnames_RSA_plot = fieldnames(RDM);
fieldnames_RSA_plot = fieldnames_RSA_plot(~strcmp(fieldnames_RSA_plot,'operator'));
figureDim = [0 0 1 1];
figure('units','normalized','outerposition',figureDim)
count = 1;
for s = [1 2]
    subplot(2,3,count)
    imagesc(RDM.(fieldnames_RSA_plot{s}))
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



%% Add and Sub separated
% Load operations
load([rsa_result_dir 'stim_matrices/allop.mat'])
for i=1:length(allop)
    if strfind(allop{i}, '+') == 2
        allop_add(i) = 1;
        allop_sub(i) = 0
    else
        allop_add(i) = 0;
        allop_sub(i) = 1;
    end
end
allop_add = allop(allop_add == 1);
allop_sub = allop(allop_sub == 1);

%% Operand 1
RDM.addsub_op1_mag = zeros(length(allop_add));
for i = 1:size(RDM.addsub_op1_mag,1)
    for j = 1:size(RDM.addsub_op1_mag,2)
        RDM.addsub_op1_mag(i,j) = abs(str2num(allop_add{i}(1)) - str2num(allop_add{j}(1)));
    end
end

%% Operand 2
RDM.addsub_op2_mag = zeros(length(allop_add));
for i = 1:size(RDM.addsub_op2_mag,1)
    for j = 1:size(RDM.add_op1_mag,2)
        RDM.addsub_op2_mag(i,j) = abs(str2num(allop_add{i}(3)) - str2num(allop_add{j}(3)));
    end
end

%% Result
RDM.add_result_mag = zeros(length(allop_add));
RDM.sub_result_mag = zeros(length(allop_sub));
for i = 1:size(RDM.add_result_mag,1)
    for j = 1:size(RDM.add_result_mag,2)
        RDM.add_result_mag(i,j) = abs(str2num(allop_add{i}) - str2num(allop_add{j}));
        RDM.sub_result_mag(i,j) = abs(str2num(allop_sub{i}) - str2num(allop_sub{j}));
    end
end


%% Visual models

%%
RDM.addsub_op1_vis = zeros(length(allop_add));
for i = 1:size(RDM.addsub_op1_vis,1)
    for j = 1:size(RDM.addsub_op1_vis,2)
        RDM.addsub_op1_vis(i,j) = RDM_visual(str2num(allop_add{i}(1))+1,str2num(allop_add{j}(1))+1);
    end
end

%%
RDM.addsub_op2_vis = zeros(length(allop_add));
for i = 1:size(RDM.addsub_op2_vis,1)
    for j = 1:size(RDM.addsub_op2_vis,2)
        RDM.addsub_op2_vis(i,j) = RDM_visual(str2num(allop_add{i}(3))+1,str2num(allop_add{j}(3))+1);
    end
end

%% Result
RDM.add_result_vis = zeros(length(allop_add));
RDM.sub_result_vis = zeros(length(allop_sub));
for i = 1:size(RDM.add_result_vis,1)
    for j = 1:size(RDM.add_result_vis,2)
        RDM.add_result_vis(i,j) = RDM_visual(str2num(allop_add{i})+1,str2num(allop_add{j})+1);
        RDM.sub_result_vis(i,j) = RDM_visual(str2num(allop_sub{i})+1,str2num(allop_sub{j})+1);
    end
end

%% Save 
save([rsa_result_dir 'stim_matrices/calc_RDM_matrices.mat'], 'RDM', 'allop', 'allop_add', 'allop_sub')


%% Plotting
load([rsa_result_dir 'stim_matrices/calc_RDM_matrices.mat'], 'RDM')

fieldnames_RSA_plot = {'op1_vis' 'op1_mag' 'operator' 'op2_vis' 'op2_mag' 'result_vis' 'result_mag'};
colors_RSA_plot = {'RdPu' 'Greys' 'Oranges' 'Greys' 'BuGn' 'Greys' 'Greys'};

figureDim = [0 0 .3 .5];
figure('units','normalized','outerposition',figureDim)
for s = 1:length(fieldnames_RSA_plot)
    imagesc(RDM.(fieldnames_RSA_plot{s}))
%     title(fieldnames_RDM{s}, 'interpreter', 'none')
    axis square
    set(gca,'XTick',1:1:32)
    set(gca,'XTickLabel',allop);
    set(gca,'XaxisLocation','top')
    set(gca,'XTickLabelRotation',-90)
    set(gca,'YTick',1:1:32)
    set(gca,'YTickLabel',allop);
%     set(gca,'YTickLabel',[], 'XTickLabel', []);
    colorbar('YTickLabel',[]);
    colormap(cbrewer2(colors_RSA_plot{s}))
    %savePNG(gcf,200, [rsa_result_dir 'stim_matrices/calc_RDM_matrices' fieldnames_RSA_plot{s} '.png'])
end
% Save