%% all subjects that are ready for CLIKS
subj=[1 3 5:8 13 16];

% Click1
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\bst2ft_data\S0' num2str(subj(s)) '\data'],'data_click1')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\bst2ft_data\S' num2str(subj(s)) '\data'],'data_click1')
    end;
    dataavg=data_click1;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_click1  
end;
gav_click1=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_click1.avg=squeeze(mean(gav_click1.individual,1));

% Click2
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\bst2ft_data\S0' num2str(subj(s)) '\data'],'data_click2')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\bst2ft_data\S' num2str(subj(s)) '\data'],'data_click2')
    end;
    dataavg=data_click2;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_click2 
end;
gav_click2=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_click2.avg=squeeze(mean(gav_click2.individual,1));


%% all subjects that are ready
subj=[1 3:8 13 16];

% Click1
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\bst2ft_data\S0' num2str(subj(s)) '\data'],'data_click1')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\bst2ft_data\S' num2str(subj(s)) '\data'],'data_click1')
    end;
    dataavg=data_click1;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_click1  
end;
gav_click1=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_click1.avg=squeeze(mean(gav_click1.individual,1));

% Click2
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\bst2ft_data\S0' num2str(subj(s)) '\data'],'data_click2')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\bst2ft_data\S' num2str(subj(s)) '\data'],'data_click2')
    end;
    dataavg=data_click2;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_click2 
end;
gav_click2=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_click2.avg=squeeze(mean(gav_click2.individual,1));




% save grand average 
cd C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\bst2ft_data
save gave gav*;

