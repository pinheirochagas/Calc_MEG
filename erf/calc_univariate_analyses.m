%% Directories
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/fieldtrips/fieldtrip_testedversion/'   % fieldtrip version tested with this pipeline                                                                                                                                                  
ft_defaults  

%% Data and results 
% MAC
datapath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/mat/';
resultpath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/erf/';

% Hard drive
datapath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/mat/';
resultpath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/erf/';
figurespath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/results/erf/figures/';
statspath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/results/erf/stats/';

%Linux
datapath = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/';
resultpath = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/erf/';
figures_path = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/results/erf/figures/';
stats_path = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/results/erf/stats/';


%% Fildtrip stats
lat = [-.5 4.5];
% probthr=0.2;

%% Operation
lat = [.8 1.2]; 
probthr=0.05;

gav_operator = load([resultpath 'calc_erf_addsub_operator.mat']);
gav_add = gav_operator.avgERFallGavg.addsub.operator.operator1;
gav_sub = gav_operator.avgERFallGavg.addsub.operator.operator10;

stat_op_800_1200 = ns_wsstat(gav_add,gav_sub,lat);
ns_statinfo_all(stat_op_800_1200,probthr)

% Save stats
save([stats_path 'stat_op_800_1200.mat'], 'stat_op_800_1200')

% Plot and save
bn_plotsinglecluster(lat,stat_op_800_1200,gav_add,gav_sub,1,1,0.05);
figure(3)
savePNG(gcf,200, [figures_path 'erf_gav_op_800_1200_1.png'])
figure(3)
savePNG(gcf,200, [figures_path 'topo_gav_op_800_1200_1.png'])


% Around operand 2. 
lat_1600_3200 = [1.6 3.2];
probthr=0.05;
statop_1600_3200= ns_wsstat(gav_add,gav_sub,lat_1600_3200);
ns_statinfo_all(statop_1600_3200,probthr)

% Around operand 2.4
lat_1600_2400 = [1.6 2.4];
probthr=0.05;
statop_1600_2400= ns_wsstat(gav_add,gav_sub,lat_1600_2400);
ns_statinfo_all(statop_1600_2400,probthr)
bn_plotsinglecluster(lat_1600_2400,statop_1600_2400,gav_add,gav_sub,3,1,0.01);



%% delay
gav_delaynodelay = load('calc_erf_all_delay.mat');
gav_delay = gav_delaynodelay.avgERFallGavg.all.delay.delay0;
gav_nodelay = gav_delaynodelay.avgERFallGavg.all.delay.delay1;

plot(gav_delaynodelay.avgERFallGavg.all.delay.delay0.time, gav_delaynodelay.avgERFallGavg.all.delay.delay0.avg(3,:))
statdelay= ns_wsstat(gav_delay,gav_nodelay,lat);

ns_statinfo_all(statdelay,probthr);
bn_plotsinglecluster(statdelay,gav_delay,gav_nodelay,2,1,0.01);


%% Operand1 in all
lat = [0 .8];
gav_op1 = load([resultpath 'calc_erf_all_operand1.mat']);
gav_op13 = gav_op1.avgERFallGavg.all.operand1.operand13;
gav_op14 = gav_op1.avgERFallGavg.all.operand1.operand14;
gav_op15 = gav_op1.avgERFallGavg.all.operand1.operand15;
gav_op16 = gav_op1.avgERFallGavg.all.operand1.operand16;

% Calculate Stats
stataallop1 = fp_statdepregr_all(lat,gav_op13,gav_op14,gav_op15,gav_op16);
save([stats_path 'stataallop1.mat'], 'stataallop1')
% Check Stats
ns_statinfo_all(stataallop1,probthr);

%% Operand 2 in additions and subtractions
lat = [1.6 2.4];
gav_addsub_op2 = load([resultpath 'calc_erf_addsub_operand2.mat']);
gav_addsubop20 = gav_addsub_op2.avgERFallGavg.addsub.operand2.operand20;
gav_addsubop21 = gav_addsub_op2.avgERFallGavg.addsub.operand2.operand21;
gav_addsubop22 = gav_addsub_op2.avgERFallGavg.addsub.operand2.operand22;
gav_addsubop23 = gav_addsub_op2.avgERFallGavg.addsub.operand2.operand23;
% Calculate Stats
stataddsubop2 = fp_statdepregr_all(lat,gav_addsubop20,gav_addsubop21,gav_addsubop22,gav_addsubop23);
save([stats_path 'stataddsubop2.mat'], 'stataddsubop2')
% Check Stats
ns_statinfo_all(stataddsubop2,probthr);

%% Operand 2 in additions and subtractions no 0
% Calculate Stats
stataddsubop2no0 = fp_statdepregr_all(lat,gav_addsubop21,gav_addsubop22,gav_addsubop23);
save([stats_path 'stataddsubop2no0.mat'], 'stataddsubop2no0')
% Check Stats
ns_statinfo_all(stataddsubop2no0,probthr);

%% Operand2 in additions
lat = [1.6 2.4];
gav_add_op2 = load([resultpath 'calc_erf_add_operand2.mat']);
gav_addop20 = gav_add_op2.avgERFallGavg.add.operand2.operand20;
gav_addop21 = gav_add_op2.avgERFallGavg.add.operand2.operand21;
gav_addop22 = gav_add_op2.avgERFallGavg.add.operand2.operand22;
gav_addop23 = gav_add_op2.avgERFallGavg.add.operand2.operand23;
% Calculate Stats
stataddop2 = fp_statdepregr_all(lat,gav_addop20,gav_addop21,gav_addop22,gav_addop23);
save([stats_path 'stataddop2.mat'], 'stataddop2')
% Check Stats
ns_statinfo_all(stataddop2,probthr)


%% Operand2 in additions no 0
lat = [1.6 2.4];
% Calculate Stats
stataddop2no0 = fp_statdepregr_all(lat,gav_addop21,gav_addop22,gav_addop23);
save([stats_path 'stataddop2no0.mat'], 'stataddop2no0')
% Check Stats
ns_statinfo_all(stataddop2no0,probthr)

%% Operand2 in subtractions
gav_sub_op2 = load([resultpath 'calc_erf_sub_operand2']);
gav_subop20 = gav_sub_op2.avgERFallGavg.sub.operand2.operand20;
gav_subop21 = gav_sub_op2.avgERFallGavg.sub.operand2.operand21;
gav_subop22 = gav_sub_op2.avgERFallGavg.sub.operand2.operand22;
gav_subop23 = gav_sub_op2.avgERFallGavg.sub.operand2.operand23;

% Calculate Stats
statsubop2 = fp_statdepregr_all(lat,gav_subop20,gav_subop21,gav_subop22,gav_subop23);
save([stats_path 'statsubop2.mat'], 'statsubop2')
% Check Stats
ns_statinfo_all(statsubop2,probthr)

%% Operand2 in subtractions no 0
% Calculate Stats
statsubop2no0 = fp_statdepregr_all(lat,gav_subop21,gav_subop22,gav_subop23);
save([stats_path 'statsubop2no0.mat'], 'statsubop2no0')
% Check Stats
ns_statinfo_all(statsubop2no0,probthr)

%% Correct result in addsub
gav_addsub_corrResult = load([resultpath 'calc_erf_addsub_corrResult.mat']);
gav_addsubcorrResult3 = gav_addsub_corrResult.avgERFallGavg.addsub.corrResult.corrResult3;
gav_addsubcorrResult4 = gav_addsub_corrResult.avgERFallGavg.addsub.corrResult.corrResult4;
gav_addsubcorrResult5 = gav_addsub_corrResult.avgERFallGavg.addsub.corrResult.corrResult5;
gav_addsubcorrResult6 = gav_addsub_corrResult.avgERFallGavg.addsub.corrResult.corrResult6;
% Calculate Stats
stataddsubcorrResult = fp_statdepregr_all(lat,gav_addsubcorrResult3,gav_addsubcorrResult4,gav_addsubcorrResult5,gav_addsubcorrResult6);
% Check Stats
ns_statinfo_all(stataddsubcorrResult,probthr);


%% Correct result in add
gav_add_corrResult = load([resultpath 'calc_erf_add_corrResult.mat']);
gav_addcorrResult3 = gav_add_corrResult.avgERFallGavg.add.corrResult.corrResult3;
gav_addcorrResult4 = gav_add_corrResult.avgERFallGavg.add.corrResult.corrResult4;
gav_addcorrResult5 = gav_add_corrResult.avgERFallGavg.add.corrResult.corrResult5;
gav_addcorrResult6 = gav_add_corrResult.avgERFallGavg.add.corrResult.corrResult6;
% Calculate Stats
stataddcorrResult = fp_statdepregr_all(lat,gav_addcorrResult3,gav_addcorrResult4,gav_addcorrResult5,gav_addcorrResult6);
% Check Stats
ns_statinfo_all(stataddcorrResult,probthr);

%Plot
fp_plotsinglecluster_depregr(stataddcorrResult,3,2,0,gav_addcorrResult3,gav_addcorrResult4,gav_addcorrResult5,gav_addcorrResult6) 
figure(3)
save2pdf([figurespath 'erf_gav_add_corrResult.pdf'],gcf, 600)


%% Correct result in sub
gav_sub_corrResult = load([resultpath 'calc_erf_sub_corrResult.mat']);
gav_subcorrResult3 = gav_sub_corrResult.avgERFallGavg.sub.corrResult.corrResult3;
gav_subcorrResult4 = gav_sub_corrResult.avgERFallGavg.sub.corrResult.corrResult4;
gav_subcorrResult5 = gav_sub_corrResult.avgERFallGavg.sub.corrResult.corrResult5;
gav_subcorrResult6 = gav_sub_corrResult.avgERFallGavg.sub.corrResult.corrResult6;
% Calculate Stats
statsubcorrResult = fp_statdepregr_all(lat,gav_subcorrResult3,gav_subcorrResult4,gav_subcorrResult5,gav_subcorrResult6);
% Check Stats
ns_statinfo_all(statsubcorrResult,probthr);

%Plot
fp_plotsinglecluster_depregr(statsubcorrResult,3,2,0,gav_subcorrResult3,gav_subcorrResult4,gav_subcorrResult5,gav_subcorrResult6) 
figure(3)
save2pdf([figurespath 'erf_gav_sub_corrResult.pdf'],gcf, 600)




%% PLOT

%% Operand1 in all
latPlot = [0 .8];
fp_plotsinglecluster_depregr(lat,stataallop1,3,2,0,gav_op13,gav_op14,gav_op15,gav_op16) 

% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_allop1_grad2_2.png'])
% Topo
FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_allop1_grad2_2.png'])

%% Operand 2 in additions and subtractions
ns_statinfo_all(stataddsubop2,probthr)
%Plot
latPlot = [1.6 2.4];
fp_plotsinglecluster_depregr(latPlot,stataddsubop2,3,-2,0,gav_addsubop20,gav_addsubop21,gav_addsubop22,gav_addsubop23) 
% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_addsub_op2_grad2_-2.png'])
% Topo

FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_addsub_op2_grad2_-2.png'])
close all

%% Operand 2 in additions and subtractions no 0
ns_statinfo_all(stataddsubop2no0,probthr)
%Plot
latPlot = [1.6 2.4];
fp_plotsinglecluster_depregr(latPlot,stataddsubop2,3,-1,0,gav_addsubop21,gav_addsubop22,gav_addsubop23) 
% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_addsub_op2no0_grad2_-1.png'])
% Topo

FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_addsub_op2no0_grad2_-1.png'])
close all

%% Operand 2 in additions
ns_statinfo_all(stataddop2,probthr)
%Plot
latPlot = [1.6 2.4];
fp_plotsinglecluster_depregr(latPlot,stataddop2,3,-2,0,gav_addop20,gav_addop21,gav_addop22,gav_addop23) 
% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_add_op2_grad2_-2.png'])
% Topo

FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_add_op2_grad2_-2.png'])
close all


%% Operand 2 in additions no 0
ns_statinfo_all(stataddop2no0,probthr)
%Plot
latPlot = [1.6 2.4];
fp_plotsinglecluster_depregr(latPlot,stataddop2no0,1,-1,0,gav_addop21,gav_addop22,gav_addop23) 
% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_add_op2no0_mag_-1.png'])
% Topo

FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_add_op2no0_mag_-1.png'])
close all

%% Operand 2 in subtractions
ns_statinfo_all(statsubop2,probthr)
%Plot
latPlot = [1.6 2.4];
fp_plotsinglecluster_depregr(latPlot,statsubop2,3,-2,0,gav_subop20,gav_subop21,gav_subop22,gav_addsubop23) 
% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_sub_op2_grad2_-2.png'])
% Topo
FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_sub_op2_grad2_-2.png'])
close all

%% Operand 2 in subtractions no 0
ns_statinfo_all(statsubop2no0,probthr)
%Plot
latPlot = [1.6 2.4];
fp_plotsinglecluster_depregr(latPlot,statsubop2no0,1,-1,0,gav_subop21,gav_subop22,gav_subop23) 
% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_sub_op2no0_mag_-1.png'])
% Topo
FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_sub_op2no0_mag_-1.png'])
close all


%% Correct result in additions and subtractions
ns_statinfo_all(stataddsubcorrResult,probthr)
%Plot
latPlot = [1.6 2.4];
fp_plotsinglecluster_depregr(latPlot,stataddsubcorrResult,3,-2,0,gav_addsubcorrResult3,gav_addsubcorrResult4,gav_addsubcorrResult5,gav_subcorrResult6) 
% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_addsub_corrResult_grad2_-2.png'])
% Topo
FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_addsub_corrResult_grad2_-2.png'])
close all


%% Correct result in additions
ns_statinfo_all(stataddcorrResult,probthr)
%Plot
latPlot = [1.6 2.4];
fp_plotsinglecluster_depregr(latPlot,stataddcorrResult,3,-2,0,gav_subcorrResult3,gav_subcorrResult4,gav_subcorrResult3,gav_subcorrResult4) 
% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_add_corrResult_grad2_-2.png'])
% Topo
FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_add_corrResult_grad2_-2.png'])
close all

%% Correct result in subtractions
ns_statinfo_all(statsubcorrResult,0.3)
%Plot
latPlot = [1.6 2.4];
fp_plotsinglecluster_depregr(latPlot,statsubcorrResult,3,-2,0,gav_subcorrResult3,gav_subcorrResult4,gav_subcorrResult3,gav_subcorrResult4) 
% Time course
figure(3)
savePNG(gcf,200, [figurespath 'erf_gav_sub_corrResult_grad2_-2.png'])
% Topo
FigHandle = figure(2);
set(FigHandle,'units','normalized', 'outerposition', [0 0 1 1]);
savePNG(gcf,200, [figurespath 'topo_gav_sub_corrResult_grad2_-2.png'])
close all



