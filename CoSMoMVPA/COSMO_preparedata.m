%% Prepare data for COSMO Searchlight

addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/fieldtrip_latest'
ft_defaults  

% ========================================  Category
tools={'_TFA_asp';'_TFA_lav';'_TFA_arm';'_TFA_sof';'_TFA_mix';'_TFA_rev';'_TFA_ore';'_TFA_fuc';...
       '_TFA_hel';'_TFA_mot';'_TFA_vel';'_TFA_can';'_TFA_aut';'_TFA_gyr';'_TFA_rol';'_TFA_bot'};  
   
animals ={'_TFA_gor';'_TFA_ele';'_TFA_gir';'_TFA_lam';'_TFA_oui';'_TFA_per';'_TFA_sco';'_TFA_cam';...
      '_TFA_vac';'_TFA_mou';'_TFA_tau';'_TFA_cha';'_TFA_cri';'_TFA_coq';'_TFA_fur';'_TFA_lap'}; 
                      
  % ========================================  Audio
sound={'_TFA_gor';'_TFA_ele';'_TFA_oui';'_TFA_per';'_TFA_vac';'_TFA_mou';'_TFA_cri';'_TFA_coq';...
       '_TFA_asp';'_TFA_lav';'_TFA_mix';'_TFA_rev';'_TFA_hel';'_TFA_mot';'_TFA_aut';'_TFA_gyr'};  

nosound={'_TFA_gir';'_TFA_lam';'_TFA_sco';'_TFA_cam';'_TFA_tau';'_TFA_cha';'_TFA_fur';'_TFA_lap';...
        '_TFA_arm';'_TFA_sof';'_TFA_ore';'_TFA_fuc';'_TFA_vel';'_TFA_can';'_TFA_rol';'_TFA_bot'}; 

    % ========================================  Video
big={'_TFA_gor';'_TFA_ele';'_TFA_gir';'_TFA_lam';'_TFA_vac';'_TFA_mou';'_TFA_tau';'_TFA_cha';...
    '_TFA_asp';'_TFA_lav';'_TFA_arm';'_TFA_sof';'_TFA_hel';'_TFA_mot';'_TFA_vel';'_TFA_can'};  

small={'_TFA_oui';'_TFA_per';'_TFA_sco';'_TFA_cam';'_TFA_cri';'_TFA_coq';'_TFA_fur';'_TFA_lap';...
      '_TFA_mix';'_TFA_rev';'_TFA_ore';'_TFA_fuc';'_TFA_aut';'_TFA_gyr';'_TFA_rol';'_TFA_bot'};  

% parameters
params = [];
%params.subnips = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'};
params.subnips = {'S13','S14','S15','S16','S17','S18','S19'};
%params.folder = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/results_TFA/COI_singletrials_low/';
%params.folder = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/results_TFA/COI_singletrials_high/';
params.folder = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/results_TFA/optionB/COI_singletrials_low_highresolution/';
params.res_path = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/results_TFA/COSMO/Data_HR';
params.cond1 = animals;                                   %  words belonging to cond1
params.cond2 = tools;                                 %  words belonging to cond2

%Load important variables
load('/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/pipeline_tmp/SensorClassification.mat');

%Loop over all subjects to load data and baseline correct it
for subi = 1 : length(params.subnips)
          
     TFA_allcond = [];
     trialinfo = [];
%     cfg = [];
%     cfg.baseline = [-0.8 -0.2];
%     cfg.baselinetype = 'relchange';
    
   for c = 1 : length(params.cond1)+length(params.cond2); % loop across words
         
        if c < 17
            tmp = load([params.folder params.subnips{subi} char(params.cond1(c))], 'freq');  
            TFA_allcond = vertcat(TFA_allcond,tmp.freq.powspctrm);
            trialinfo = vertcat(trialinfo,ones(size(tmp.freq.powspctrm,1),1));
        else
            tmp = load([params.folder params.subnips{subi} char(params.cond2(c-16))], 'freq');  
            TFA_allcond = vertcat(TFA_allcond,tmp.freq.powspctrm);
            trialinfo = vertcat(trialinfo,ones(size(tmp.freq.powspctrm,1),1)*2);
        end
        
    end   % loop across words
    
    TFAallcond = tmp.freq;
    TFAallcond.powspctrm = TFA_allcond;
    TFAallcond.trialinfo = trialinfo;
%   FinalTFA_TFA_allcond_BS = ft_freqbaseline(cfg, FinalTFA_cond1);   % baseline correct

    save([params.res_path '/' params.subnips{subi} '_cat.mat'], 'TFAallcond','-v7.3');

end   % loop across subjects