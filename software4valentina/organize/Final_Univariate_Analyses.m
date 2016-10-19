%% set path 

% at NeuroSpin 
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/pipeline_tmp/'                        %  pipeline scripts
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/bst2ft/'                              % local processing scripts
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/fieldtrip_testedversion/fieldtrip/'   % fieldtrip version tested with this pipeline                                                                                   
ft_defaults  

% at CIMeC
addpath 'C:\Users\valentina.borghesani\Desktop\software4valentina\pipeline_tmp\'                        %  pipeline scripts
addpath 'C:\Users\valentina.borghesani\Desktop\software4valentina\bst2ft\'                              % local processing scripts
addpath 'C:\Users\valentina.borghesani\Desktop\software4valentina\fieldtrip_testedversion\fieldtrip\'   % fieldtrip version tested with this pipeline                                                                                   
ft_defaults  

%% ========================== IMPORT ========================== %%

% downsampled, with single items, with info run
subs = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'}
for i = 1:15
    % Subject name/directory
    subj=subs{i}
    mkdir(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/' subj])
    % Import Brainstorm data to Fieldtrip format
    data=bst2ft_all_inditems_withrun(subj);
    % save Fieldtrip dataset(s) - separated to save memory
    names=...
    {'gor','ele','gir','lam','oui','per','sco','cam','vac','mou','tau','cha','cri','coq','fur','lap',...
    'asp','lav','arm','sof','mix','rev','ore', 'fuc','hel','mot','vel','can','aut','gyr','rol','bot'};
    for d=1:32;
        eval(sprintf('data_%s = data{d}', char(names(d))));
    end
    clear data
    save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/' subj '/data'],'data_*');
    clearvars -except i subs
end
clearvars
clc
subs = {'S01','S02','S03','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'}
for i = 1:14
    % Subject name/directory
    subj=subs{i}
    % Import Brainstorm data to Fieldtrip format
    dataclick=bst2ft_all_inditems_withrun_clicks(subj);
    % save Fieldtrip dataset(s) - separated to save memory
    names= {'click1_short','click2_short'};
    for d=1:2;
        eval(sprintf('dataclick_%s = dataclick{d}', char(names(d))));
    end
    clear dataclick
    save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/' subj '/dataclick'],'dataclick_*');
    clearvars -except i subs
end


%% ========================== Grand Average ========================== %%

subs = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'}

% ========================== length
cfg=[];
cfg.keepindividual = 'yes';
for s = 1:15
    subj=subs{s}
    clear data_*
    load(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/' subj '/data'])

    len1=ns_appendftdata(data_coq);  
    len2=ns_appendftdata(data_lam,data_sof,data_mot,data_vel); 
    len3=ns_appendftdata(data_vac,data_lap,data_can);  
    len4=ns_appendftdata(data_gir,data_mou,data_fur,data_mix,data_rev,data_rol,data_bot);  
    len5=ns_appendftdata(data_gor,data_tau,data_cha,data_cri,data_arm);  
    len6=ns_appendftdata(data_ele,data_oui,data_sco,data_cam,data_ore);  
    len7=ns_appendftdata(data_per,data_aut,data_gyr);  
    len8=ns_appendftdata(data_fuc,data_asp,data_lav);  
    len9=ns_appendftdata(data_hel);  
    clear data_*
    
    dataavglen1=len1;
    dataavglen1=rmfield(dataavglen1,'trial');
    dataavg_loclen1{s} = dataavglen1;
    dataavglen2=len2;
    dataavglen2=rmfield(dataavglen2,'trial');
    dataavg_loclen2{s} = dataavglen2;
    dataavglen3=len3;
    dataavglen3=rmfield(dataavglen3,'trial');
    dataavg_loclen3{s} = dataavglen3;
    dataavglen4=len4;
    dataavglen4=rmfield(dataavglen4,'trial');
    dataavg_loclen4{s} = dataavglen4;
    dataavglen5=len5;
    dataavglen5=rmfield(dataavglen5,'trial');
    dataavg_loclen5{s} = dataavglen5;
    dataavglen6=len6;
    dataavglen6=rmfield(dataavglen6,'trial');
    dataavg_loclen6{s} = dataavglen6;
    dataavglen7=len7;
    dataavglen7=rmfield(dataavglen7,'trial');
    dataavg_loclen7{s} = dataavglen7;
    dataavglen8=len8;
    dataavglen8=rmfield(dataavglen8,'trial');
    dataavg_loclen8{s} = dataavglen8;
    dataavglen9=len9;
    dataavglen9=rmfield(dataavglen9,'trial');
    dataavg_loclen9{s} = dataavglen9;
    clear len*
    
end;
clear data_*  
clear len*
    
gav_clust1=ft_timelockgrandaverage(cfg,dataavg_loclen1{:});
gav_clust1.avg=squeeze(mean(gav_clust1.individual,1));
gav_clust2=ft_timelockgrandaverage(cfg,dataavg_loclen2{:});
gav_clust2.avg=squeeze(mean(gav_clust2.individual,1));
gav_clust3=ft_timelockgrandaverage(cfg,dataavg_loclen3{:});
gav_clust3.avg=squeeze(mean(gav_clust3.individual,1));
gav_clust4=ft_timelockgrandaverage(cfg,dataavg_loclen4{:});
gav_clust4.avg=squeeze(mean(gav_clust4.individual,1));
gav_len5=ft_timelockgrandaverage(cfg,dataavg_loclen5{:});
gav_len5.avg=squeeze(mean(gav_len5.individual,1));
gav_len6=ft_timelockgrandaverage(cfg,dataavg_loclen6{:});
gav_len6.avg=squeeze(mean(gav_len6.individual,1));
gav_len7=ft_timelockgrandaverage(cfg,dataavg_loclen7{:});
gav_len7.avg=squeeze(mean(gav_len7.individual,1));
gav_len8=ft_timelockgrandaverage(cfg,dataavg_loclen8{:});
gav_len8.avg=squeeze(mean(gav_len8.individual,1));
gav_len9=ft_timelockgrandaverage(cfg,dataavg_loclen9{:});
gav_len9.avg=squeeze(mean(gav_len9.individual,1));

% save grand average length
cd /neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/
save gave_len gav*;


% ========================== category
cfg=[];
cfg.keepindividual = 'yes';
for s = 1:15
    subj=subs{s}
    clear data_*
    load(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/' subj '/data'])
    animals=ns_appendftdata(data_gor,data_ele,data_gir,data_lam,data_oui,data_per,data_sco,data_cam,...
                           data_vac,data_mou,data_tau,data_cha,data_cri,data_coq,data_fur,data_lap);  
    tools=ns_appendftdata(data_asp,data_lav,data_arm,data_sof,data_mix,data_rev,data_ore,data_fuc,...
                          data_hel,data_mot,data_vel,data_can,data_aut,data_gyr,data_rol,data_bot  );   
    clear data_*
    dataavganimals=animals;
    dataavganimals=rmfield(dataavganimals,'trial');
    dataavg_locanimals{s} = dataavganimals;
    dataavgtools=tools;
    dataavgtools=rmfield(dataavgtools,'trial');
    dataavg_loctools{s} = dataavgtools;
    clear animals
    clear tools
end;
clear data_*  
% compute grand average for the two categories
gav_animals=ft_timelockgrandaverage(cfg,dataavg_locanimals{:});
gav_animals.avg=squeeze(mean(gav_animals.individual,1));
gav_click2=ft_timelockgrandaverage(cfg,dataavg_loctools{:});
gav_click2.avg=squeeze(mean(gav_click2.individual,1));
% save grand average 
cd /neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/
save gave_category gav*;

% ========================== sound
cfg=[];
cfg.keepindividual = 'yes';
for s = 1:15
    subj=subs{s}
    clear data_*
    load(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/' subj '/data'])
    sound=ns_appendftdata(data_gor,data_ele,data_oui,data_per,data_vac,data_mou,data_cri,data_coq,...
                          data_asp,data_lav,data_mix,data_rev,data_hel,data_mot,data_aut,data_gyr);  
    nosound=ns_appendftdata(data_gir,data_lam,data_sco,data_cam,data_tau,data_cha,data_fur,data_lap,...
                            data_arm,data_sof,data_ore,data_fuc,data_vel,data_can,data_rol,data_bot);   
    clear data_*
    dataavgsound=sound;
    dataavgsound=rmfield(dataavgsound,'trial');
    dataavg_locsound{s} = dataavgsound;
    dataavgnosound=nosound;
    dataavgnosound=rmfield(dataavgnosound,'trial');
    dataavg_locnosound{s} = dataavgnosound;
    clear sound
    clear nosound
end;
clear data_*  
% compute grand average for the two categories
gav_sound=ft_timelockgrandaverage(cfg,dataavg_locsound{:});
gav_sound.avg=squeeze(mean(gav_sound.individual,1));
gav_nosound=ft_timelockgrandaverage(cfg,dataavg_locnosound{:});
gav_nosound.avg=squeeze(mean(gav_nosound.individual,1));
% save grand average 
cd /neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/
save gave_sound gav*;


% ========================== size
cfg=[];
cfg.keepindividual = 'yes';
for s = 1:15
    subj=subs{s}
    clear data_*
    load(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/' subj '/data'])
    big=ns_appendftdata(data_gor,data_ele,data_gir,data_lam,data_vac,data_mou,data_tau,data_cha,...
                        data_asp,data_lav,data_arm,data_sof,data_hel,data_mot,data_vel,data_can);  
    small=ns_appendftdata(data_oui,data_per,data_sco,data_cam,data_cri,data_coq,data_fur,data_lap,...
                          data_mix,data_rev,data_ore,data_fuc,data_aut,data_gyr,data_rol,data_bot);   
    clear data_*
    dataavgbig=big;
    dataavgbig=rmfield(dataavgbig,'trial');
    dataavg_locbig{s} = dataavgbig;
    dataavgsmall=small;
    dataavgsmall=rmfield(dataavgsmall,'trial');
    dataavg_locsmall{s} = dataavgsmall;
    clear big
    clear small
end;
clear data_*  
% compute grand average for the two categories
gav_big=ft_timelockgrandaverage(cfg,dataavg_locbig{:});
gav_big.avg=squeeze(mean(gav_big.individual,1));
gav_small=ft_timelockgrandaverage(cfg,dataavg_locsmall{:});
gav_small.avg=squeeze(mean(gav_small.individual,1));
% save grand average 
cd /neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/
save gave_size gav*;


% ========================== cluster
cfg=[];
cfg.keepindividual = 'yes';
for s = 1:15
    subj=subs{s}
    clear data_*
    load(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/' subj '/data'])

    clust1=ns_appendftdata(data_gor,data_ele,data_gir,data_lam,data_oui,data_per,data_sco,data_cam);  
    clust2=ns_appendftdata(data_vac,data_mou,data_tau,data_cha,data_cri,data_coq,data_fur,data_lap); 
    clust3=ns_appendftdata(data_asp,data_lav,data_arm,data_sof,data_mix,data_rev,data_ore,data_fuc);  
    clust4=ns_appendftdata(data_hel,data_mot,data_vel,data_can,data_aut,data_gyr,data_rol,data_bot);  
    clear data_*
    
    dataavgclust1=clust1;
    dataavgclust1=rmfield(dataavgclust1,'trial');
    dataavg_locclust1{s} = dataavgclust1;
    dataavgclust2=clust2;
    dataavgclust2=rmfield(dataavgclust2,'trial');
    dataavg_locclust2{s} = dataavgclust2;
    dataavgclust3=clust3;
    dataavgclust3=rmfield(dataavgclust3,'trial');
    dataavg_locclust3{s} = dataavgclust3;
    dataavgclust4=clust4;
    dataavgclust4=rmfield(dataavgclust4,'trial');
    dataavg_locclust4{s} = dataavgclust4;
    clear len*  
end;
clear data_*  
clear len*
gav_clust1=ft_timelockgrandaverage(cfg,dataavg_locclust1{:});
gav_clust1.avg=squeeze(mean(gav_clust1.individual,1));
gav_clust2=ft_timelockgrandaverage(cfg,dataavg_locclust2{:});
gav_clust2.avg=squeeze(mean(gav_clust2.individual,1));
gav_clust3=ft_timelockgrandaverage(cfg,dataavg_locclust3{:});
gav_clust3.avg=squeeze(mean(gav_clust3.individual,1));
gav_clust4=ft_timelockgrandaverage(cfg,dataavg_locclust4{:});
gav_clust4.avg=squeeze(mean(gav_clust4.individual,1));
% save grand average 
cd /neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/
save gave_cluster gav*;


% ========================== clicks
subs = {'S01','S02','S03','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'}
cfg=[];
cfg.keepindividual = 'yes';
for s = 1:14
    subj=subs{s}
    clear data_*
    load(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/' subj '/dataclick'])
    click1=ns_appendftdata(dataclick_click1_short);  
    click2=ns_appendftdata(dataclick_click2_short);   
    clear data_*
    dataavgclick1=click1;
    dataavgclick1=rmfield(dataavgclick1,'trial');
    dataavg_locclick1{s} = dataavgclick1;
    dataavgclick2=click2;
    dataavgclick2=rmfield(dataavgclick2,'trial');
    dataavg_locclick2{s} = dataavgclick2;
    clear click1
    clear click2
end;
clear data_*  
% compute grand average for the two categories
gav_click1=ft_timelockgrandaverage(cfg,dataavg_locclick1{:});
gav_click1.avg=squeeze(mean(gav_click1.individual,1));
gav_click2=ft_timelockgrandaverage(cfg,dataavg_locclick2{:});
gav_click2.avg=squeeze(mean(gav_click2.individual,1));
% save grand average 
cd /neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/
save gave_clicks gav*;


%% ========================== ERF STATISTICAL ANALYSIS ========================== %%

% Group 
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_len.mat');
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_category.mat');
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_cluster.mat');
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_size.mat');
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_sound.mat');
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_clicks.mat');

    % ========================== All time
    lat = [0 0.5] 
    
        % Length
        statlen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9);
        % Clicks
        statclick = ns_wsstat(gav_click1,gav_click2,lat);
        % Sound
        stataudio = ns_wsstat(gav_sound,gav_nosound,lat);
        % Size
        statsize = ns_wsstat(gav_big,gav_small,lat);
        % Category
        statcategory = ns_wsstat(gav_animals,gav_tools,lat);
        % Cluster
        
        save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/AllTime_group_stats.mat'],'stat*');
        clear stat*  

    % ========================== Window of interest 
    lat = [0.2 0.5] 
    
        % Length
        statlen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9);
        % Clicks
        statclick = ns_wsstat(gav_click1,gav_click2,lat);
        % Sound
        stataudio = ns_wsstat(gav_sound,gav_nosound,lat);
        % Size
        statsize = ns_wsstat(gav_big,gav_small,lat);
        % Category
        statcategory = ns_wsstat(gav_animals,gav_tools,lat);
        % Cluster
        
        save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/WindInf_group_stats.mat'],'stat*');
        clear stat*  
            
    % ========================== small 1 [150 - 250]
    lat = [0.15 0.25];
    
        % Length
        statlen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9);
        % Clicks
        statclick = ns_wsstat(gav_click1,gav_click2,lat);
        % Sound
        stataudio = ns_wsstat(gav_sound,gav_nosound,lat);
        % Size
        statsize = ns_wsstat(gav_big,gav_small,lat);
        % Category
        statcategory = ns_wsstat(gav_animals,gav_tools,lat);
        % Cluster
        
        save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/Time1_group_stats.mat'],'stat*');
        clear stat*  
    
    % ========================== small 2 [250 - 350]
    lat = [0.25 0.35];
        
        % Length
        statlen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9);
        % Clicks
        statclick = ns_wsstat(gav_click1,gav_click2,lat);
        % Sound
        stataudio = ns_wsstat(gav_sound,gav_nosound,lat);
        % Size
        statsize = ns_wsstat(gav_big,gav_small,lat);
        % Category
        statcategory = ns_wsstat(gav_animals,gav_tools,lat);
        % Cluster
        
        save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/Time2_group_stats.mat'],'stat*');
        clear stat*  
        
    % ========================== small 3 [350 - 450]
    lat = [0.35 0.45]; 
        
        % Length
        statlen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9);
        % Clicks
        statclick = ns_wsstat(gav_click1,gav_click2,lat);
        % Sound
        stataudio = ns_wsstat(gav_sound,gav_nosound,lat);
        % Size
        statsize = ns_wsstat(gav_big,gav_small,lat);
        % Category
        statcategory = ns_wsstat(gav_animals,gav_tools,lat);
        % Cluster
        
        save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/Time3_group_stats.mat'],'stat*');
        clear stat*  
    
    % ========================== small 4 [450 - 550]
    lat = [0.45 0.55];
    
        % Length
        statlen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9);
        % Clicks
        statclick = ns_wsstat(gav_click1,gav_click2,lat);
        % Sound
        stataudio = ns_wsstat(gav_sound,gav_nosound,lat);
        % Size
        statsize = ns_wsstat(gav_big,gav_small,lat);
        % Category
        statcategory = ns_wsstat(gav_animals,gav_tools,lat);
        % Cluster
        
        save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/Time4_group_stats.mat'],'stat*');
        clear stat*  

        
        
%% ========================== PLOT INTERESTING RESULTS ========================== %%
             
probthr=0.2;
        
% ========================== All time        
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/AllTime_group_stats.mat');
    
    % Length
    ns_statinfo_all(statlen,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_len.mat')
    fp_plotsinglecluster_depregr(statlen,3,-1,0,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9) 
    clear gav*

    % Clicks
    ns_statinfo_all(statclick,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_clicks.mat')
    bn_plotsinglecluster(statclick,gav_click1,gav_click2,2,1,0.01);
    clear gav*

    % Sound
    ns_statinfo_all(stataudio,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_sound.mat')
    bn_plotsinglecluster(stataudio,gav_sound,gav_nosound,3,1,0.01);
    clear gav*
    
    % Size
    ns_statinfo_all(statsize,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_size.mat')
    bn_plotsinglecluster(statsize,gav_big,gav_small,3,1,0.01);
    clear gav*
    
    % Category
    ns_statinfo_all(statcategory,probthr); 
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_category.mat')
    bn_plotsinglecluster(statcategory,gav_animals,gav_tools,1,-1,0.01);
    clear gav*
    
    % Cluster


% ========================== Window of interest 
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/WindInf_group_stats.mat');

    % Length
    ns_statinfo_all(statlen,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_len.mat')
    fp_plotsinglecluster_depregr(statlen,3,-1,0,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9) 
    clear gav*
    
    % Clicks
    ns_statinfo_all(statclick,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_clicks.mat')
    bn_plotsinglecluster(statclick,gav_click1,gav_click2,3,1,0.01);
    clear gav*

    % Sound
    ns_statinfo_all(stataudio,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_sound.mat')
    bn_plotsinglecluster(stataudio,gav_sound,gav_nosound,3,1,0.01);
    clear gav*    
    
    % Size
    ns_statinfo_all(statsize,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_size.mat')
    bn_plotsinglecluster(statsize,gav_big,gav_small,3,1,0.01);
    clear gav*
    
    % Category
    ns_statinfo_all(statcategory,probthr); 
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_category.mat')
    bn_plotsinglecluster(statcategory,gav_animals,gav_tools,1,-1,0.01);
    clear gav*
    
    % Cluster

% ========================== small 1 [150 - 250]
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/Time1_group_stats.mat');

    % Length
    ns_statinfo_all(statlen,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_len.mat')
    fp_plotsinglecluster_depregr(statlen,3,1,0,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9) 
    clear gav*
    
    % Clicks
    ns_statinfo_all(statclick,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_clicks.mat')
    bn_plotsinglecluster(statclick,gav_click1,gav_click2,1,-1,0.01);
    clear gav*

    % Sound
    ns_statinfo_all(stataudio,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_sound.mat')
    bn_plotsinglecluster(stataudio,gav_sound,gav_nosound,3,-1,0.01);
    clear gav*    
    
    % Size
    ns_statinfo_all(statsize,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_size.mat')
    bn_plotsinglecluster(statsize,gav_big,gav_small,2,1,0.01);     % cannot plot it because border problem
    clear gav*
    
    % Category
    ns_statinfo_all(statcategory,probthr); 
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_category.mat')
    bn_plotsinglecluster(statcategory,gav_animals,gav_tools,1,-1,0.01);
    clear gav*
    
    % Cluster

% ========================== small 2 [250 - 350]
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/Time2_group_stats.mat');

    % Length
    ns_statinfo_all(statlen,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_len.mat')
    fp_plotsinglecluster_depregr(statlen,3,-1,0,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9) 
    clear gav*
    
    % Clicks
    ns_statinfo_all(statclick,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_clicks.mat')
    bn_plotsinglecluster(statclick,gav_click1,gav_click2,2,-1,0.01);   % cannot plot it because border problem
    clear gav*

    % Sound
    ns_statinfo_all(stataudio,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_sound.mat')
    bn_plotsinglecluster(stataudio,gav_sound,gav_nosound,3,1,0.01);
    clear gav*    
    
    % Size
    ns_statinfo_all(statsize,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_size.mat')
    bn_plotsinglecluster(statsize,gav_big,gav_small,3,1,0.01);    
    clear gav*
    
    % Category
    ns_statinfo_all(statcategory,probthr); 
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_category.mat')
    bn_plotsinglecluster(statcategory,gav_animals,gav_tools,1,-1,0.01);
    clear gav*
    
    % Cluster

% ========================== small 3 [350 - 450]
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/Time3_group_stats.mat');

    % Length
    ns_statinfo_all(statlen,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_len.mat')
    fp_plotsinglecluster_depregr(statlen,3,1,0,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9) 
    clear gav*
    
    % Clicks
    ns_statinfo_all(statclick,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_clicks.mat')
    bn_plotsinglecluster(statclick,gav_click1,gav_click2,2,-1,0.01);
    clear gav*

    % Sound
    ns_statinfo_all(stataudio,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_sound.mat')
    bn_plotsinglecluster(stataudio,gav_sound,gav_nosound,3,1,0.01);
    clear gav*    
    
    % Size
    ns_statinfo_all(statsize,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_size.mat')
    bn_plotsinglecluster(statsize,gav_big,gav_small,2,1,0.01);     % cannot plot it because border problem
    clear gav*
    
    % Category
    ns_statinfo_all(statcategory,probthr); 
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_category.mat')
    bn_plotsinglecluster(statcategory,gav_animals,gav_tools,1,-1,0.01);
    clear gav*
    
    % Cluster

% ========================== small 4 [450 - 550]
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/Time4_group_stats.mat');

    % Length
    ns_statinfo_all(statlen,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_len.mat')
    fp_plotsinglecluster_depregr(statlen,3,1,0,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9) 
    clear gav*
    
    % Clicks
    ns_statinfo_all(statclick,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_clicks.mat')
    bn_plotsinglecluster(statclick,gav_click1,gav_click2,1,-1,0.01);
    clear gav*

    % Sound
    ns_statinfo_all(stataudio,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_sound.mat')
    bn_plotsinglecluster(stataudio,gav_sound,gav_nosound,3,-1,0.01);
    clear gav*    
    
    % Size
    ns_statinfo_all(statsize,probthr);
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_size.mat')
    bn_plotsinglecluster(statsize,gav_big,gav_small,2,1,0.01);     
    clear gav*
    
    % Category
    ns_statinfo_all(statcategory,probthr); 
    load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs/stats/gave_category.mat')
    bn_plotsinglecluster(statcategory,gav_animals,gav_tools,1,-1,0.01);
    clear gav*
    
    % Cluster      
    
    
%% ========================== Explore more topography ========================== %%


