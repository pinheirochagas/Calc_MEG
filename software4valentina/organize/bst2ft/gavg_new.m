%% all subjects that are ready for CLIKS
subj=[1 3 5:8 13:19];

% Click1
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S0' num2str(subj(s)) '\data'],'data_click1')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S' num2str(subj(s)) '\data'],'data_click1')
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
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S0' num2str(subj(s)) '\data'],'data_click2')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S' num2str(subj(s)) '\data'],'data_click2')
    end;
    dataavg=data_click2;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_click2 
end;
gav_click2=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_click2.avg=squeeze(mean(gav_click2.individual,1));

%% all subjects that are ready
subj=[1 3:8 13:19];

% Audio
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S0' num2str(subj(s)) '\data'],'data_audio')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S' num2str(subj(s)) '\data'],'data_audio')
    end;
    dataavg=data_audio;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_audio  
end;
gav_audio=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_audio.avg=squeeze(mean(gav_audio.individual,1));

% No Audio
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S0' num2str(subj(s)) '\data'],'data_noaudio')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S' num2str(subj(s)) '\data'],'data_noaudio')
    end;
    dataavg=data_noaudio;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_noaudio  
end;
gav_noaudio=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_noaudio.avg=squeeze(mean(gav_noaudio.individual,1));

% Big
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S0' num2str(subj(s)) '\data'],'data_big')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S' num2str(subj(s)) '\data'],'data_big')
    end;
    dataavg=data_big;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_big  
end;
gav_big=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_big.avg=squeeze(mean(gav_big.individual,1));

% Small
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S0' num2str(subj(s)) '\data'],'data_small')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S' num2str(subj(s)) '\data'],'data_small')
    end;
    dataavg=data_small;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_small  
end;
gav_small=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_small.avg=squeeze(mean(gav_small.individual,1));

% Animals
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S0' num2str(subj(s)) '\data'],'data_animals')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S' num2str(subj(s)) '\data'],'data_animals')
    end;
    dataavg=data_animals;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_animals  
end;
gav_animals=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_animals.avg=squeeze(mean(gav_animals.individual,1));

% Tools
cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    if subj(s)<10
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S0' num2str(subj(s)) '\data'],'data_tools')
    else
         load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs\S' num2str(subj(s)) '\data'],'data_tools')
    end;
    dataavg=data_tools;
    dataavg=rmfield(dataavg,'trial');
    dataavg_loc{s} = dataavg;
    clear data_tools  
end;
gav_tools=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_tools.avg=squeeze(mean(gav_tools.individual,1));

% save grand average 
cd C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs
save gave gav*;

