%% Set paths and directories
AddPathsMEGcalc
InitDirsMEGcalc

% Load operations
load([rsa_result_dir 'stim_matrices/allop.mat'])

%% Operand 1
RDM.op1 = zeros(32);
for i = 1:size(RDM.op1,1)
    for j = 1:size(RDM.op1,2)
        RDM.op1(i,j) = abs(str2num(allop{i}(1)) - str2num(allop{j}(1)));
    end
end

%% Operand 2
RDM.op2 = zeros(32);
for i = 1:size(RDM.op2,1)
    for j = 1:size(RDM.op2,2)
        RDM.op2(i,j) = abs(str2num(allop{i}(3)) - str2num(allop{j}(3)));
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
RDM.result = zeros(32);
for i = 1:size(RDM.result,1)
    for j = 1:size(RDM.result,2)
        RDM.result(i,j) = abs(str2num(allop{i}) - str2num(allop{j}));
    end
end

%% Save 
save([rsa_result_dir 'stim_matrices/calc_RDM_matrices.mat'], 'RDM')


%% Plotting
fieldnames_RDM = fieldnames(RDM);
figureDim = [0 0 .5 1];
figure('units','normalized','outerposition',figureDim)
for s = 1:length(fieldnames_RDM)
    subplot(2,2,s)
    imagesc(RDM.(fieldnames_RDM{s}))
    title(fieldnames_RDM{s})
    axis square
    set(gca,'XTick',1:1:32)
    set(gca,'XTickLabel',allop);
    set(gca,'XaxisLocation','top')
    set(gca,'XTickLabelRotation',-90)
    set(gca,'YTick',1:1:32)
    set(gca,'YTickLabel',allop); 
end
% Save
savePNG(gcf,200, [rsa_result_dir 'stim_matrices/calc_RDM_matrices.png'])





% %% Magnitude
% RDM_number = zeros(10,10)
% for i  = -9:9
%     RDM_number = RDM_number + triu(ones(10,10),i)
% end
% RDM_number = abs(RDM_number - 10)
% imagesc(RDM_number)







