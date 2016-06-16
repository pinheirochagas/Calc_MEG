%% Directories
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/'
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina/pipeline_tmp/'                        %  pipeline scripts
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina/bst2ft/'     
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/software4valentina'                              % local processing scripts
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/fieldtrip_testedversion/fieldtrip/'   % fieldtrip version tested with this pipeline                                                                                   
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts/erf/'                                                                          
ft_defaults  

datapath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/mat/';
resultpath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/erf/';

% In the hard drive
datapath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/mat/';
resultpath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/erf/';
figurespath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/erf/figures/'

%% Grand Average

subs = {'s01','s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15', ...
        's16','s17','s18','s19','s21','s22'};
    
%subs = {'s01'};


% Retrieve all the conditions from an example data
load([datapath subs{1} '_calc.mat'])
data.trialinfoCustom = data.trialinfo; 
conditions = defineConditionsERF(data);
op_names = fields(conditions);
cond_names = fields(conditions.all);
clear data

% op_names = {'all', 'addsub'}
% cond_names = {'delay','operator'}


% Load all data from all subjects (needs at least 30 gb free in disk space)
for sub = 1:length(subs)
    load([datapath subs{sub} '_calc.mat'])
    data.trialinfoCustom = data.trialinfo; 
    data.trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    dataAll.(subs{sub}) = data;
    clear data
end


% Calculate the Grand Avarage for all conditions and save for separate
% conditions, but with all subjects together. 
for op = 1:length(op_names)
    for c = 1:length(cond_names);
        for l = 1:length(conditions.(op_names{op}).(cond_names{c}));
            for sub = 1:length(subs);
%                 load([datapath subs{sub} '_calc.mat'])
                data = dataAll.(subs{sub});
                filter = calcFilterData(data, op_names{op}, cond_names{c}, conditions.(op_names{op}).(cond_names{c})(l));
                cfg = [];
                cfg.trials = find(filter);
                cfg.keepindividual = 'yes';
                avgERF = ft_timelockanalysis(cfg, data);
                avgERFsubs{sub} = avgERF;
            end
            if conditions.(op_names{op}).(cond_names{c})(l) < 0 % Just to correct the field names that has negative values = everything is pushed to 10
                conditions.(op_names{op}).(cond_names{c})(l) = abs(conditions.(op_names{op}).(cond_names{c})(l)*10);
            else
            end
            avgERFall.(op_names{op}).(cond_names{c}).([cond_names{c} num2str(conditions.(op_names{op}).(cond_names{c})(l))]) = avgERFsubs;
            avgERFallGavg.(op_names{op}).(cond_names{c}).([cond_names{c} num2str(conditions.(op_names{op}).(cond_names{c})(l))]) = ft_timelockgrandaverage(cfg,avgERFall.(op_names{op}).(cond_names{c}).([cond_names{c} num2str(conditions.(op_names{op}).(cond_names{c})(l))]){:});
            avgERFallGavg.(op_names{op}).(cond_names{c}).([cond_names{c} num2str(conditions.(op_names{op}).(cond_names{c})(l))]).avg = squeeze(mean(avgERFallGavg.(op_names{op}).(cond_names{c}).([cond_names{c} num2str(conditions.(op_names{op}).(cond_names{c})(l))]).individual,1));
            conditions = defineConditionsERF(data); % reset conditions to their original values
        end
        save([resultpath 'calc_erf_' op_names{op} '_' cond_names{c} '.mat'], 'avgERFallGavg')
        clear avgERFall
        clear avgERFallGavg
    end
%     save([resultpath 'calc_erf_' op_names{op} '.mat'], 'avgERFallGavg')
%     clear avgERFallGavg
end


%% Fildtrip stats
lat = [0 4.5];
probthr=0.2;

% Operation
gav_operator = load('calc_erf_addsub_operator.mat');
gav_add = gav_operator.avgERFallGavg.addsub.operator.operator1;
gav_sub = gav_operator.avgERFallGavg.addsub.operator.operator10;

statop= ns_wsstat(gav_add,gav_sub,lat);
ns_statinfo_all(statop,probthr);
bn_plotsinglecluster(statop,gav_add,gav_sub,3,1,0.01);


% delay
gav_delaynodelay = load('calc_erf_all_delay.mat');
gav_delay = gav_delaynodelay.avgERFallGavg.all.delay.delay0;
gav_nodelay = gav_delaynodelay.avgERFallGavg.all.delay.delay1;

plot(gav_delaynodelay.avgERFallGavg.all.delay.delay0.time, gav_delaynodelay.avgERFallGavg.all.delay.delay0.avg(3,:))
statdelay= ns_wsstat(gav_delay,gav_nodelay,lat);

ns_statinfo_all(statdelay,probthr);
bn_plotsinglecluster(statdelay,gav_delay,gav_nodelay,2,1,0.01);

%% Operand2 in additions
gav_add_op2 = load('calc_erf_add_operand2');
gav_addop20 = gav_add_op2.avgERFallGavg.add.operand2.operand20;
gav_addop21 = gav_add_op2.avgERFallGavg.add.operand2.operand21;
gav_addop22 = gav_add_op2.avgERFallGavg.add.operand2.operand22;
gav_addop23 = gav_add_op2.avgERFallGavg.add.operand2.operand23;

% Calculate Stats
stataddop2 = fp_statdepregr_all(lat,gav_addop20,gav_addop21,gav_addop22,gav_addop23);
% Check Stats
ns_statinfo_all(stataddop2,probthr);
%Plot
fp_plotsinglecluster_depregr(stataddop2,3,2,0,gav_addop20,gav_addop21,gav_addop22,gav_addop23) 
figure(3)
save2pdf([figurespath 'erf_gav_addop2_2.pdf'],gcf, 600)
figure(2)
save2pdf([figurespath 'topo_gav_addop2_2.pdf'],gcf, 600)

%% Operand2 in subtractions
gav_sub_op2 = load('calc_erf_sub_operand2');
gav_subop20 = gav_sub_op2.avgERFallGavg.sub.operand2.operand20;
gav_subop21 = gav_sub_op2.avgERFallGavg.sub.operand2.operand21;
gav_subop22 = gav_sub_op2.avgERFallGavg.sub.operand2.operand22;
gav_subop23 = gav_sub_op2.avgERFallGavg.sub.operand2.operand23;

% Calculate Stats
statsubop2 = fp_statdepregr_all(lat,gav_subop20,gav_subop21,gav_subop22,gav_subop23);
% Check Stats
ns_statinfo_all(statsubop2,probthr);
%Plot
fp_plotsinglecluster_depregr(statsubop2,3,2,0,gav_subop20,gav_subop21,gav_subop22,gav_subop23) 
figure(3)
save2pdf([figurespath 'erf_gav_subop2.pdf'],gcf, 600)



