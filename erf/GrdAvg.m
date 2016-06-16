%This function computes the grand average ERP as a function of condition
%for the uncon WM project

function [data, data_demean] = GrdAvg

clear all;

%Define important variables
params = [];
path = '/neurospin/meg/meg_tmp/WMP_Darinka_2015/data/mat/';
%subnips = {'ab140235', 'ad120287'};

subnips = {'ab140235', 'ad120287', 'ar140056', 'cc140058', 'cf140251', 'eg140204', ...
    'el130086', 'lm130479', 'ma130185', 'ro130031', 'sa130042', 'sb120316', ...
    'th130177', 'ws140212'};

%Loop through each subject to apply appropriate baseline correction and compute the
%condition-specific ERPs
for subi = 1 : length(subnips)
    
    %Load subject file
    params.subnip = subnips{subi};
    load([path params.subnip '_BF.mat']);
    
    %Define important variables
    tasks = {'all', 'wm', 'p'};
    vis = {'all', 'v1', 'seen'};
    pos = {'all', 'present', 'absent', 1 : 20}; %target position
    dis = {'all', 'present', 'absent', 1 : 20};
    acc = {'all', 'correct', 'incorrect'};
    
    params.time = [-.5, 2.5];
    
    %Preprocess the data again in order to demean
    cfg = [];
    cfg.demean = 'yes';
    cfg.baselinewindow = [-.2, 0]; %aka: baseline from 200ms before target onset until actual target onset
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 30;
   
    data_demean = ft_preprocessing(cfg, data);
    data_demean.trialinfo = data.trialinfo;
    data_demean.ECGEOG = data.ECGEOG;
    
    %Select the conditions for which ERF is to be computed
    tasks = tasks([2]);
    vis = vis([1]);
    pos = pos([1]);
    dis = dis([1 2 3]); 
    acc = acc([1]);
    
    common = params;
    
    %Compute the ERF for the requested condition
    for taski =  1 : length(tasks)
        for visi = 1 : length(vis)
            for posi = 1 : length(pos)
                for disi = 1 : length(dis)
                    for acci = 1 : length(acc)
                        params = common;
                        params.tasklab = tasks{taski};
                        params.vislab = vis{visi};
                        params.poslab = pos{posi};
                        params.dislab = dis{disi};
                        params.acc = acc{acci};
                   
                        filter = makeconditionsERF_Darinka(params, data_demean);
                   
                        cfg = [];
                        cfg.trials = find(filter);
                   
                        avgERF = ft_timelockanalysis(cfg, data_demean);
                        %avgERF.(tasks{taski}).(vis{visi}).(pos{posi}).(acc{acci}){subi} = ft_timelockanalysis(cfg, data_demean);
                        save(['/neurospin/meg/meg_tmp/WMP_Darinka_2015/Darinka_ERF/' 'Filtered_Avg_ERF_' subnips{subi} '_' tasks{taski} '_' vis{visi} '_' pos{posi} '_' dis{disi} '_' acc{acci}], 'avgERF');
                end
            end
        end
    end    
end

%Compute the grandaverage ERF
% for taski = 1 : length(tasks)
%     for visi = 1 : length(vis)
%         for posi = 1 : length(pos)
%             for acci = 1 : length(acci)
%                 
%                 cfg = [];
%                 cfg.channel = 'all';
%                 cfg.keepindividual = 'yes';
%                 
%                 indERF = ft_timelockgrandaverage(cfg, avgERF.(tasks{taski}).(vis{visi}).(pos{posi}).(acc{acci}){:});
%                 save(['/neurospin/meg/meg_tmp/WMP_Ojeda_2013/Darinka_Test/' 'Ind_ERF_' tasks{taski} '_' vis{visi} '_' pos{posi} '_' acc{acci}], 'indERF');
%                 
%                 cfg = [];
%                 cfg.channel = 'all';
%                 
%                 groupERF = ft_timelockgrandaverage(cfg, avgERF.(tasks{taski}).(vis{visi}).(pos{posi}).(acc{acci}){:});
%                 save(['/neurospin/meg/meg_tmp/WMP_Ojeda_2013/Darinka_Test/' 'Group_ERF_' tasks{taski} '_' vis{visi} '_' pos{posi} '_' acc{acci}], 'groupERF');
%             end
%         end
%     end
% end              
end






