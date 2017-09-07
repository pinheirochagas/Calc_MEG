%% Directories
InitDirsMEGcalc

% Subjects
subs = {'s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15', ...
        's16','s17','s18','s19','s21','s22'};
    
% Retrieve all the conditions from an example data
load([data_dir subs{1} '_calc.mat'])
data.trialinfoCustom = data.trialinfo; 
conditions = defineConditionsERF(data);
op_names = fields(conditions);
cond_names = fields(conditions.all);
clear data

% Load all data from all subjects (needs at least 30 gb free in disk space)
for sub = 1:length(subs)
    load([data_dir subs{sub} '_calc_lp30.mat'])
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
for op = 1:1%length(op_names)
    for c = 1:1%length(cond_names);
        for l = 1:1%length(conditions.(op_names{op}).(cond_names{c}));
            for sub = 1:length(subs);
                data = dataAll.(subs{sub});
                
                % Baseline correction
                cfg = [];
                cfg.baseline = [-0.5 -0.01];
                data = ft_timelockbaseline(cfg, data);
                
                % Calculated the averaged ERF for specific trials and stores for each subject            
                filter = calcFilterData(data, op_names{op}, cond_names{c}, conditions.(op_names{op}).(cond_names{c})(l));               
                cfg = [];
                cfg.trials = find(filter);
                cfg.keepindividual = 'yes';
                cfg.keeptrials = 'yes';
                avgERFsubs{sub} = ft_timelockanalysis(cfg, data);
                
                % Calculate GFP and store for each subject
                % First z-score trials to combine grad and mag
                avgERF_GFP = avgERFsubs{sub}
                for z = 1:size(avgERF_GFP.trial,1)
                    for zz = 1:size(avgERF_GFP.trial,2)
                        avgERF_GFP.trial(z,zz,:) = zscore(avgERF_GFP.trial(z,zz,:));
                    end
                end
                cfg = [];
                cfg.methods = 'amplitude';
                GFPERFsubs{sub} = ft_globalmeanfield(cfg, avgERF_GFP);                
            end
            
            % Correct naming of conditions for easier manipulation
            if conditions.(op_names{op}).(cond_names{c})(l) < 0 % negative values are pushed to 10 (Basically the subtractions, and deviant I guess)
                conditions.(op_names{op}).(cond_names{c})(l) = abs(conditions.(op_names{op}).(cond_names{c})(l)*10);
            else
            end
            
            % Calculate the grand average
            cfg = [];
            cfg.keepindividual = 'yes';
            cfg.keeptrials = 'yes';
            avgERFallGavg.(op_names{op}).(cond_names{c}).([cond_names{c} num2str(conditions.(op_names{op}).(cond_names{c})(l))]) = ft_timelockgrandaverage(cfg,avgERFsubs{:});
            
            % Global field power            
            GFPallGavg.(op_names{op}).(cond_names{c}).([cond_names{c} num2str(conditions.(op_names{op}).(cond_names{c})(l))]) = ft_timelockgrandaverage(cfg,GFPERFsubs{:});

            % reset conditions to their original values
            conditions = defineConditionsERF(data); 
        end
        
        % Saving
        save([[data_root_dir 'data/erf/'] 'calc_erf_' op_names{op} '_' cond_names{c} '.mat'], 'avgERFallGavg')
        save([[data_root_dir 'data/erf/'] 'calc_gfp_' op_names{op} '_' cond_names{c} '.mat'], 'GFPallGavg')
        
        % Clear variables
        clear avgERFallGavg
        clear GFPallGavg
    end
end

