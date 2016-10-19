
subj=[3 5 8:12 14:21];
for s=1:length(subj)
    if subj(s)<10
    load(['s0' num2str(subj(s))]);
    else
        load(['s' num2str(subj(s))]);
    end;
    dataavg=data;
    clear data
    for c=1:length(dataavg)
        dataavg{c}=rmfield(dataavg{c},'trial');
    end;
    save(['s' num2str(s) '_avg'] ,'dataavg','-v7.3');
end;

cfg=[];
cfg.keepindividual = 'yes';
gav=cell(9,1);
for c=1:9
    for s=1:length(subj)
        load(['s' num2str(s) '_avg']);
        dataavg_loc{s}=dataavg{c};
    end;
    gav{c}=ft_timelockgrandaverage(cfg,dataavg_loc{:});
    gav{c}.avg=squeeze(mean(gav{c}.individual,1));
end;

subj=[3 5 8:12 14:21];
for s=1:length(subj)
    if subj(s)<10
    load(['s0' num2str(subj(s))]);
    else
        load(['s' num2str(subj(s))]);
    end;
    % number deviant +-1
    dataavg=ns_appendftdata(data{3},data{5});  dataavg=rmfield(dataavg,'trial');     
    save(['s' num2str(s) '_avg_dev1'] ,'dataavg','-v7.3');
    % number deviant +-2
    dataavg=ns_appendftdata(data{2},data{6});  dataavg=rmfield(dataavg,'trial');
    save(['s' num2str(s) '_avg_dev2'] ,'dataavg','-v7.3');
    % number deviant +-3
    dataavg=ns_appendftdata(data{1},data{7});  dataavg=rmfield(dataavg,'trial');
    save(['s' num2str(s) '_avg_dev3'] ,'dataavg','-v7.3');
    % color deviant 
    dataavg=ns_appendftdata(data{8},data{9});  dataavg=rmfield(dataavg,'trial');
    save(['s' num2str(s) '_avg_devcol'] ,'dataavg','-v7.3');
end;

cfg=[];
cfg.keepindividual = 'yes';
for s=1:length(subj)
    load(['s' num2str(s) '_avg_dev1']);
    dataavg_loc{s}=dataavg;
end;
gav_dev1=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_dev1.avg=squeeze(mean(gav_dev1.individual,1));

for s=1:length(subj)
    load(['s' num2str(s) '_avg_dev2']);
    dataavg_loc{s}=dataavg;
end;
gav_dev2=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_dev2.avg=squeeze(mean(gav_dev2.individual,1));

for s=1:length(subj)
    load(['s' num2str(s) '_avg_dev3']);
    dataavg_loc{s}=dataavg;
end;
gav_dev3=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_dev3.avg=squeeze(mean(gav_dev3.individual,1));

for s=1:length(subj)
    load(['s' num2str(s) '_avg_devcol']);
    dataavg_loc{s}=dataavg;
end;
gav_devcol=ft_timelockgrandaverage(cfg,dataavg_loc{:});
gav_devcol.avg=squeeze(mean(gav_devcol.individual,1));

save gave gav*;
    
    
    
    
    
    