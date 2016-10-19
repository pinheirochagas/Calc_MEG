%% ========================== bst2ft_erfanalysis ========================== %%
%
% - Data export from Brainstorm to Fieldtrip.
% - Visualization of ERFs from data preprocessed with ns_preproc.
% - Within-subjects statistical analysis.
% - Grand-average and across-subjects statistical analysis.
% Uses Fieldtrip 
% Parameters 'par' are specific for each subject and experiment.
%
% Marco Buiatti, INSERM U992 Cognitive Neuroimaging Unit (France), 2013.
% adapt for SEMDIM by Valentina Borghesani 20/05/2015

%% set path %%

% addpath '/neurospin/local/mne/share/matlab/'                                                          % MNE (needed to read and import fif data in fieldtrip 
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/pipeline_tmp/'                        %  pipeline scripts
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/bst2ft/'                              % local processing scripts
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/fieldtrip_testedversion/fieldtrip/'   % fieldtrip version tested with this pipeline 
addpath /neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina
% sets fieldtrip defaults and configures the minimal required path settings 
ft_defaults  

%% ========================== IMPORT ========================== %%
 
subs = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'}

for i = 1:15
    % Subject name/directory
    subj=subs{i}
    mkdir(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs_items_withrun/' subj])
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
    save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs_items_withrun/' subj '/data'],'data_*');
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
    save(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/epochs_items_withrun/' subj '/dataclick'],'dataclick_*');
    clearvars -except i subs
end
 



%% ========================== Grand Average ========================== %%

% all subjects that are ready 
subs = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'}

cfg=[];
cfg.keepindividual = 'yes';

for s = 1:15
    subj=subs{s}
    clear data_*
    load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\' subj '\data'])

%     len1=ns_appendftdata(data_coq);  
%     len2=ns_appendftdata(data_lam,data_sof,data_mot,data_vel); 
%     len3=ns_appendftdata(data_vac,data_lap,data_can);  
%     len4=ns_appendftdata(data_gir,data_mou,data_fur,data_mix,data_rev,data_rol,data_bot);  
%     len5=ns_appendftdata(data_gor,data_tau,data_cha,data_cri,data_arm);  
%     len6=ns_appendftdata(data_ele,data_oui,data_sco,data_cam,data_ore);  
%     len7=ns_appendftdata(data_per,data_aut,data_gyr);  
%     len8=ns_appendftdata(data_fuc,data_asp,data_lav);  
%     len9=ns_appendftdata(data_hel);  

    len1=ns_appendftdata(data_coq,data_lam,data_sof,data_mot,data_vel,data_vac,data_lap,data_can);
%     len2=ns_appendftdata(data_gir,data_mou,data_fur,data_mix,data_rev,data_rol,data_bot);  
%     len3=ns_appendftdata(data_gor,data_tau,data_cha,data_cri,data_arm, data_ele,data_oui,data_sco,data_cam,data_ore);  
    len4=ns_appendftdata(data_per,data_aut,data_gyr,data_fuc,data_asp,data_lav,data_hel); 
    
    clear data_*
    
    dataavglen1=len1;
    dataavglen1=rmfield(dataavglen1,'trial');
    dataavg_loclen1{s} = dataavglen1;
    
%     dataavglen2=len2;
%     dataavglen2=rmfield(dataavglen2,'trial');
%     dataavg_loclen2{s} = dataavglen2;
%     
%     dataavglen3=len3;
%     dataavglen3=rmfield(dataavglen3,'trial');
%     dataavg_loclen3{s} = dataavglen3;
    
    dataavglen4=len4;
    dataavglen4=rmfield(dataavglen4,'trial');
    dataavg_loclen4{s} = dataavglen4;
    
%     dataavglen5=len5;
%     dataavglen5=rmfield(dataavglen5,'trial');
%     dataavg_loclen5{s} = dataavglen5;
%     
%     dataavglen6=len6;
%     dataavglen6=rmfield(dataavglen6,'trial');
%     dataavg_loclen6{s} = dataavglen6;
%     
%     dataavglen7=len7;
%     dataavglen7=rmfield(dataavglen7,'trial');
%     dataavg_loclen7{s} = dataavglen7;
%     
%     dataavglen8=len8;
%     dataavglen8=rmfield(dataavglen8,'trial');
%     dataavg_loclen8{s} = dataavglen8;
%     
%     dataavglen9=len9;
%     dataavglen9=rmfield(dataavglen9,'trial');
%     dataavg_loclen9{s} = dataavglen9;
    
    clear len*
    
end;

clear data_*  
clear len*
    
gav_len1=ft_timelockgrandaverage(cfg,dataavg_loclen1{:});
gav_len1.avg=squeeze(mean(gav_len1.individual,1));

% gav_len2=ft_timelockgrandaverage(cfg,dataavg_loclen2{:});
% gav_len2.avg=squeeze(mean(gav_len2.individual,1));
% 
% gav_len3=ft_timelockgrandaverage(cfg,dataavg_loclen3{:});
% gav_len3.avg=squeeze(mean(gav_len3.individual,1));

gav_len4=ft_timelockgrandaverage(cfg,dataavg_loclen4{:});
gav_len4.avg=squeeze(mean(gav_len4.individual,1));

% gav_len5=ft_timelockgrandaverage(cfg,dataavg_loclen5{:});
% gav_len5.avg=squeeze(mean(gav_len5.individual,1));
% 
% gav_len6=ft_timelockgrandaverage(cfg,dataavg_loclen6{:});
% gav_len6.avg=squeeze(mean(gav_len6.individual,1));
% 
% gav_len7=ft_timelockgrandaverage(cfg,dataavg_loclen7{:});
% gav_len7.avg=squeeze(mean(gav_len7.individual,1));
% 
% gav_len8=ft_timelockgrandaverage(cfg,dataavg_loclen8{:});
% gav_len8.avg=squeeze(mean(gav_len8.individual,1));
% 
% gav_len9=ft_timelockgrandaverage(cfg,dataavg_loclen9{:});
% gav_len9.avg=squeeze(mean(gav_len9.individual,1));

% save grand average clicks
cd C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\stats_nuove
save gave_len gav*;


%% ========================== SINGLE SUBJECTS ========================== %%
 
subs = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'}
for i = 1:15
    subj=subs{i}
    lat = [0 0.5]   
    clear data*
    load(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\' subj '\data'])
   
    len1=ns_appendftdata(data_coq,data_lam,data_sof,data_mot,data_vel,data_vac,data_lap,data_can);
%   len2=ns_appendftdata(data_gir,data_mou,data_fur,data_mix,data_rev,data_rol,data_bot);  
%   len3=ns_appendftdata(data_gor,data_tau,data_cha,data_cri,data_arm, data_ele,data_oui,data_sco,data_cam,data_ore);  
    len4=ns_appendftdata(data_per,data_aut,data_gyr,data_fuc,data_asp,data_lav,data_hel); 
    
    clear data*
    
    statreglen = fp_statindepregr_all(lat,len1,len4)
    
    save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\' subj '\stats_bin'],'stat*');
    clearvars -except i subs
end


probthr=0.2;
ns_statinfo_all(statreglen,probthr);

fp_plotsinglecluster_depregr(statreglen,3,1,0.01,len1,len2,len3,len4,len5,len6,len7,len8,len9) 


%% ========================== GROUP ANALYSES: general =========================== %%

load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\gave_len.mat');
lat = [0 0.5];
statreglen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9)
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items/group_stats_len.mat'],'stat*');
probthr=0.2;
ns_statinfo_all(statreglen,probthr);
fp_plotsinglecluster_depregr(statreglen,3,1,0.01,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9) 
fp_plotsinglecluster_depregr(statreglen,3,-1,0.01,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9) 


load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\stats_figure_grouped2\gave_len_groupped.mat');
lat = [0 0.5];
statreglen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4)
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\stats_figure_grouped2\group_stats_len.mat'],'stat*');
probthr=0.2;
ns_statinfo_all(statreglen,probthr);
fp_plotsinglecluster_depregr(statreglen,3,1,0.01,gav_len1,gav_len2,gav_len3,gav_len4) 


% provare come ttest non regressione
load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\stats_nuove\gave_len.mat');
lat = [0 0.5];
statlen = ns_wsstat(gav_len1,gav_len4,lat)
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\stats_nuove\group_stats_len.mat'],'stat*');
probthr=0.2;
ns_statinfo_all(statlen,probthr);
bn_plotsinglecluster(statlen,gav_len1,gav_len4,3,1,0.01);



%% ========================== GROUP ANALYSES: times =========================== %%

load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\gave_len.mat');

lat = [0.05 0.15];
statreglen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4,gav_len5,gav_len6,gav_len7,gav_len8,gav_len9)
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items/group_stats_len_tmp1.mat'],'stat*');
probthr=0.3;
ns_statinfo_all(statreglen,probthr);

lat = [0.05 0.15];
statreglen = fp_statdepregr_all(lat,gav_len1,gav_len2,gav_len3,gav_len4)
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\stats_figure_grouped2/group_stats_len_tmp1.mat'],'stat*');
probthr=0.2;
ns_statinfo_all(statreglen,probthr);

load('C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\stats_nuove\gave_len.mat');
lat = [0 0.15];
statreglen = fp_statdepregr_all(lat,gav_len1,gav_len4)
save(['C:\Users\valentina.borghesani\Desktop\SemDim\MEG\data\epochs_items\stats_nuove\group_stats_len.mat'],'stat*');
probthr=0.3;
ns_statinfo_all(statreglen,probthr);
fp_plotsinglecluster_depregr(statreglen,2,1,0.0,gav_len1,gav_len4) 


fp_plotsinglecluster_depregr(statreglen,2,-1,0,gav_len1,gav_len2,gav_len3,gav_len4) 

