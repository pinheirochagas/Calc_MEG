%% Directories
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/'
%addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina/pipeline_tmp/'                        %  pipeline scripts
%addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina/bst2ft/'     
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina'                              % local processing scripts
%addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/fieldtrip_testedversion/fieldtrip/'   % fieldtrip version tested with this pipeline                                                                                   

addpath('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina/bst2ft_2/')
addpath('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina/pipeline_tmp_2/')

addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina/fieldtrip-20160509'

addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/erf/'                                                                          
ft_defaults  

datapath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/mat/';
resultpath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/erf/';

% In the hard drive
datapath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/mat/';
resultpath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/erf/';
figurespath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/erf/figures/';
statspath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/erf/stats/';
%% Fildtrip stats
%lat = [-.500 4.5];


probthr=0.2;

% all
gav_operatorall = load([resultpath 'calc_erf_all_operator.mat']);
gav_operatoralladd = gav_operatorall.avgERFallGavg.all.operator.operator1

plot(gav_operatoralladd.time, gav_operatoralladd.avg(1,:))

cfg.parameter = 'avg';
cfg.layout = 'neuromag306all.lay';
cfg.channel = 'all';
% this has to be a 
cfg.ylim = [-9.44e-12 8.08e-12];
cfg.xlim = [-.5 1];

ft_multiplotER(cfg, gav_operatoralladd)

% Operation
gav_operator = load([resultpath 'calc_erf_addsub_operator.mat']);
gav_add = gav_operator.avgERFallGavg.addsub.operator.operator1;
gav_sub = gav_operator.avgERFallGavg.addsub.operator.operator10;

statop= ns_wsstat(gav_add,gav_sub,lat);
ns_statinfo_all(statop,probthr);
bn_plotsinglecluster(statop,gav_add,gav_sub,3,1,0.01);


%% Delay no delay
lat = [3.2 4.5];
gav_delaynodelay = load([resultpath 'calc_erf_all_delay.mat']);
gav_delay = gav_delaynodelay.avgERFallGavg.all.delay.delay0;
gav_nodelay = gav_delaynodelay.avgERFallGavg.all.delay.delay1;

statdelay= ns_wsstat(gav_delay,gav_nodelay,lat);

ns_statinfo_all(statdelay,probthr);
bn_plotsinglecluster(lat,statdelay,gav_delay,gav_nodelay,2,2,0.01);


%% Operand1 all
lat = [-.1 .800];
gav_all_op1 = load([resultpath 'calc_erf_all_operand1']);
gav_allop13 = gav_all_op1.avgERFallGavg.all.operand1.operand13;
gav_allop14 = gav_all_op1.avgERFallGavg.all.operand1.operand14;
gav_allop15 = gav_all_op1.avgERFallGavg.all.operand1.operand15;
gav_allop16 = gav_all_op1.avgERFallGavg.all.operand1.operand16;


% Calculate Stats
stataddop1 = fp_statdepregr_all(lat,gav_allop13,gav_allop14,gav_allop15,gav_allop16);
save([statspath 'stataddop1.mat'], 'stataddop1')
% Check Stats
ns_statinfo_all(stataddop1,probthr);
%Plot
fp_plotsinglecluster_depregr(lat,stataddop1,1,2,0,gav_allop13,gav_allop14,gav_allop15,gav_allop16) 
figure(3)
save2pdf([figurespath 'erf_gav_addop2_2.pdf'],gcf, 600)
figure(2)
save2pdf([figurespath 'topo_gav_addop2_2.pdf'],gcf, 600)

%% Operand2 in additions
gav_add_op2 = load([resultpath 'calc_erf_add_operand2']);
gav_addop20 = gav_add_op2.avgERFallGavg.add.operand2.operand20;
gav_addop21 = gav_add_op2.avgERFallGavg.add.operand2.operand21;
gav_addop22 = gav_add_op2.avgERFallGavg.add.operand2.operand22;
gav_addop23 = gav_add_op2.avgERFallGavg.add.operand2.operand23;


% Calculate Stats
stataddop2 = fp_statdepregr_all(lat,gav_addop20,gav_addop21,gav_addop22,gav_addop23);
save([statspath 'stataddop2.mat'], 'stataddop2')

% Check Stats
ns_statinfo_all(stataddop2,probthr);
%Plot
fp_plotsinglecluster_depregr(stataddop2,3,2,0,gav_addop20,gav_addop21,gav_addop22,gav_addop23) 
figure(3)
save2pdf([figurespath 'erf_gav_addop2_2.pdf'],gcf, 600)
figure(2)
save2pdf([figurespath 'topo_gav_addop2_2.pdf'],gcf, 600)

%% Operand2 in subtractions
gav_sub_op2 = load([resultpath 'calc_erf_sub_operand2']);
gav_subop20 = gav_sub_op2.avgERFallGavg.sub.operand2.operand20;
gav_subop21 = gav_sub_op2.avgERFallGavg.sub.operand2.operand21;
gav_subop22 = gav_sub_op2.avgERFallGavg.sub.operand2.operand22;
gav_subop23 = gav_sub_op2.avgERFallGavg.sub.operand2.operand23;

% Calculate Stats
statsubop2 = fp_statdepregr_all(lat,gav_subop20,gav_subop21,gav_subop22,gav_subop23);
save([statspath 'statsubop2.mat'], 'statsubop2')

% Check Stats
ns_statinfo_all(statsubop2,probthr);
%Plot
fp_plotsinglecluster_depregr(statsubop2,3,2,0,gav_subop20,gav_subop21,gav_subop22,gav_subop23) 
figure(3)
save2pdf([figurespath 'erf_gav_subop2.pdf'],gcf, 600)



