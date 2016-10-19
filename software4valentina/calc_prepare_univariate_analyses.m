%% Directories
%Mac
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/'
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/software4valentina/pipeline_tmp/'                        %  pipeline scripts
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/software4valentina/bst2ft/'     
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/software4valentina'                              % local processing scripts
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/fieldtrips/fieldtrip_testedversion/'   % fieldtrip version tested with this pipeline                                                                                   
addpath '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/erf/'                                                                          
ft_defaults  

% Linux
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/'
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/software4valentina/pipeline_tmp/'                        %  pipeline scripts
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/software4valentina/bst2ft/'     
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/software4valentina/'                              % local processing scripts
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/fieldtrips/fieldtrip_testedversion/'   % fieldtrip version tested with this pipeline                                                                                   
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/erf/'                                                                          
ft_defaults  

%% Data
% MAC
datapath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/mat/';
resultpath = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/erf/';

% Hard drive
datapath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/mat/';
resultpath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/erf/';
figurespath = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/results/erf/figures/';

%Linux
datapath = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/';
resultpath = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/erf/';
figurespath = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/results/erf/figures/';


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


%op_names = {'all'; 'addsub'}
%op_names = {'add'; 'sub'}

%op_names = {'sub'}
%cond_names = {'presResult'}
cond_names = cond_names(6:8)

%subs = {'s01','s02','s03','s04','s05','s07','s09','s10','s11','s12','s13','s14','s15', ...
        %'s16','s17','s18','s19','s21','s22'};
    


% Load all data from all subjects (needs at least 30 gb free in disk space)
for sub = 1:length(subs)
    load([datapath subs{sub} '_calc.mat'])
    data.trialinfoCustom = data.trialinfo; 
    data.trialinfo = cell2mat(struct2cell(data.trialinfo))'; % To make trialinfo compatible with new fieldtrip. This simple converts the separate fields into a single matrix: each field is a column
    dataAll.(subs{sub}) = data;
    clear data
end

% Check the presence of each level in each condition. 
for sub = 1:length(subs);
    data = dataAll.(subs{sub});
    for c = 1:size(data.trialinfo,2)-2
        unique(data.trialinfo(data.trialinfo(:,3)==1,c))
    end
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
                cfg.keeptrials = 'yes';
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
%      save([resultpath 'calc_erf_' op_names{op} '.mat'], 'avgERFallGavg')
%      clear avgERFallGavg
end

