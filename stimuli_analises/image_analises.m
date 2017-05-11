
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/stimuli_analises/image_similarity_toolbox-master/'
imageDir = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/stimuli_analises/images'
imageDirAll = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/stimuli_analises/images/all'

import('R')

[F word_map RDM img_categories] = img_sim(imageDir, 8, 1, 1, 1, 5)
close all
subplot(2,1,1)
imagesc(RDM)
title('dissimilarity matrix garbor')
set(gca, 'XTick', 1:4);
set(gca, 'YTick', 1:4);
set(gca, 'Xticklabels', 3:6)
set(gca, 'Yticklabels', 3:6)
set(gca, 'FontSize', 18)
axis square
colorbar

RDM_ratio = [1-(3/3) 1-(3/4) 1-(3/5) 1-(3/6); 1-(3/4) 1-(4/4) 1-(4/5) 1-(4/6); 1-(3/5) 1-(4/5) 1-(5/5) 1-(5/6); 1-(3/6) 1-(4/6) 1-(5/6) 1-(6/6)]


subplot(2,1,2)
imagesc(RDM_number)
title('dissimilarity matrix number')
set(gca, 'XTick', 1:4);
set(gca, 'YTick', 1:4);
set(gca, 'Xticklabels', 3:6)
set(gca, 'Yticklabels', 3:6)
set(gca, 'FontSize', 18)
axis square
colorbar

save2pdf('similarity_numbers_3to6_garbor.pdf', gcf, 600)


[F word_map RDM img_categories] = img_sim(imageDir, 1, 1, 1, 1, 5)
close all
subplot(2,1,1)
imagesc(RDM)
title('dissimilarity matrix pixels')
set(gca, 'XTick', 1:4);
set(gca, 'YTick', 1:4);
set(gca, 'Xticklabels', 3:6)
set(gca, 'Yticklabels', 3:6)
set(gca, 'FontSize', 18)
axis square
colorbar

subplot(2,1,2)
imagesc(RDM_number)
title('dissimilarity matrix number')
set(gca, 'XTick', 1:4);
set(gca, 'YTick', 1:4);
set(gca, 'Xticklabels', 3:6)
set(gca, 'Yticklabels', 3:6)
set(gca, 'FontSize', 18)
axis square
colorbar

save2pdf('similarity_numbers_3to6_pixels.pdf', gcf, 600)


[F word_map RDM img_categories] = img_sim(imageDirAll, 8, 1, 1, 1, 5)
close all
subplot(2,1,1)
imagesc(RDM)
title('dissimilarity matrix garbor')
set(gca, 'XTick', 1:11);
set(gca, 'YTick', 1:11);
set(gca, 'Xticklabels', 0:9)
set(gca, 'Yticklabels', 0:9)
set(gca, 'FontSize', 18)
axis square
colorbar
hold on
rectangle('Position',[3.5,3.5,4,4],'LineWidth', 3)

subplot(2,1,2)
RDM_number = zeros(10,10)
for i  = -9:9
    RDM_number = RDM_number + triu(ones(10,10),i)
end
RDM_number = abs(RDM_number - 10)
imagesc(RDM_number)
title('dissimilarity matrix number')
set(gca, 'XTick', 1:11);
set(gca, 'YTick', 1:11);
set(gca, 'Xticklabels', 0:9)
set(gca, 'Yticklabels', 0:9)
set(gca, 'FontSize', 18)
axis square
colorbar

hold on
rectangle('Position',[3.5,3.5,4,4], 'LineWidth', 3, 'Color', 'w')

save2pdf('similarity_numbers_0to9_pixels.pdf', gcf, 600)












RDM_number = zeros(10,10)
for i  = -9:9
    RDM_number = RDM_number + triu(ones(10,10),i)
end
RDM_number = abs(RDM_number - 10)
imagesc(RDM_number)
title('dissimilarity matrix number')
set(gca, 'XTick', 1:11);
set(gca, 'YTick', 1:11);
set(gca, 'Xticklabels', 0:9)
set(gca, 'Yticklabels', 0:9)
set(gca, 'FontSize', 18)
axis square
colorbar


numberRange = 0:9;


for i = 0:length(numberRange)-1;
    for e = 0:length(numberRange)-2;
        RDM_number(i+1,e+1) = 1-(numberRange(i+1)/numberRange(e+1));
    end
end
    
    



