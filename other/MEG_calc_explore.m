% plot fieldtrip stats
% Define subjects
clear all
close all
subj = 's02'

% Define conditions
cond_1 ='data_left_arrow';                         
cond_2 ='data_rigth_arrow';


% Stats dir
statsDir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/bst2ft_data/';

% Data dir
dirdata = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/bst2ft_data-todelete_downsampled/';

% Load stats
load([statsDir subj '/stats.mat']);

% Load data
load([dirdata subj '/data.mat'],cond_1,cond_2);
cond1 = eval(cond_1);                  % e.g. [225x306x176 double]
cond2 = eval(cond_2);                  % e.g. [225x306x176 double]


close all
bn_plotsinglecluster(statrightleftAttention,cond1,cond2,1,1,0.01);
figure(1) 
save2pdf([dirdata subj '/' subj 'FT_'  cond_1 '_' cond_2 '_topo' '_MAG' '.pdf'], gcf, 600)
figure(2) 
title([subj ' FieldTrip Stats - MAG'], 'Interpreter', 'none')
save2pdf([dirdata subj '/' subj 'FT_'  cond_1 '_' cond_2 '_MAG' '.pdf'], gcf, 600)
legend({cond_1, cond_2},'Location','northwest', 'Interpreter', 'none')
close all

bn_plotsinglecluster(statrightleftAttention,cond1,cond2,2,1,0.01);
figure(1) 
save2pdf([dirdata subj '/' subj 'FT_'  cond_1 '_' cond_2 '_topo' '_GRAD1' '.pdf'], gcf, 600)
figure(2) 
title([subj ' FieldTrip Stats - GRAD1'], 'Interpreter', 'none')
save2pdf([dirdata subj '/' subj 'FT_'  cond_1 '_' cond_2 '_GRAD1' '.pdf'], gcf, 600)
legend({cond_1, cond_2},'Location','northwest', 'Interpreter', 'none')
close all

bn_plotsinglecluster(statrightleftAttention,cond1,cond2,3,1,0.01);
figure(1) 
save2pdf([dirdata subj '/' subj 'FT_'  cond_1 '_' cond_2 '_topo' '_GRAD2' '.pdf'], gcf, 600)
figure(2) 
title([subj ' FieldTrip Stats - GRAD2'], 'Interpreter', 'none')
save2pdf([dirdata subj '/' subj 'FT_'  cond_1 '_' cond_2 '_GRAD2' '.pdf'], gcf, 600)
legend({cond_1, cond_2},'Location','northwest', 'Interpreter', 'none')






