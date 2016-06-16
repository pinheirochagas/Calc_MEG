function par = sc_par(n)
% function par = sc_par(n) where n is the subject number
% Specifies subject information for performing Maxfilter. 

%% set path %%
addpath '/neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline_tmp/'  % Neurospin pipeline scripts
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/scripts/neuromag_preproc/'    % local processing scripts

%% EXPERIMENT-SPECIFIC INFORMATION %%   
%% path to relevant directories (to be generated in advance) %%
% par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/';                  % Raw data path
% par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/';                   % Head position text file directory
% par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/';                  % SSS Data directory
par.mfdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/mf_scripts/';       % Maxfilter scripts directory

%% SUBJECT-SPECIFIC INFORMATION %%
switch n

    case 1
        par.subj        = 's01'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1211 2412 1732 1743';                              
        par.badch{2}    = '1211 2412 1732 1743';
        par.badch{3}    = '1211 2412 1732 1743';
        par.badch{4}    = '1211 2412 1732 1743';
        par.badch{5}    = '1211 2412 1732 1743';
        par.badch{6}    = '1211 2412 1732 1743';
        par.badch{7}    = '1211 2412 1732 1743';
        par.badch{8}    = '1211 2412 1732 1743';
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s01/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s01/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s01/';                  % SSS Data directory
        
    case 2
        par.subj        = 's02'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732';                              
        par.badch{2}    = '1743 2412 1732';  
        par.badch{3}    = '1743 2412 1732';  
        par.badch{4}    = '1743 2412 1732';  
        par.badch{5}    = '1743 2412 1732';  
        par.badch{6}    = '1743 2412 1732';  
        par.badch{7}    = '1743 2412 1732';  
        par.badch{8}    = '1743 2412 1732';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s02/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s02/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s02/';                  % SSS Data directory
        
   case 3
        par.subj        = 's03'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732';                              
        par.badch{2}    = '1743 2412 1732';   
        par.badch{3}    = '1743 2412 1732';   
        par.badch{4}    = '1743 2412 1732';   
        par.badch{5}    = '1743 2412 1732';    
        par.badch{6}    = '1743 2412 1732';   
        par.badch{7}    = '1743 2412 1732';     
        par.badch{8}    = '1743 2412 1732';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s03/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s03/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s03/';                  % SSS Data directory
        
  case 4
        par.subj        = 's04'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732';                              
        par.badch{2}    = '1743 2412 1732';   
        par.badch{3}    = '1743 2412 1732';   
        par.badch{4}    = '1743 2412 1732';   
        par.badch{5}    = '1743 2412 1732';    
        par.badch{6}    = '1743 2412 1732';   
        par.badch{7}    = '1743 2412 1732';     
        par.badch{8}    = '1743 2412 1732';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s04/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s04/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s04/';                  % SSS Data directory
  
  case 5
        par.subj        = 's05'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 1421';                              
        par.badch{2}    = '1743 2412 1732 1421';  
        par.badch{3}    = '1743 2412 1732 1421 0131';  
        par.badch{4}    = '1743 2412 1732 1421 0131';   
        par.badch{5}    = '1743 2412 1732 1421 2313';     
        par.badch{6}    = '1743 2412 1732 1421';  
        par.badch{7}    = '1743 2412 1732 1421';    
        par.badch{8}    = '1743 2412 1732 1421';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s05/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s05/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s05/';                  % SSS Data directory

  case 6
        par.subj        = 's06'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'};     % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732';                              
        par.badch{2}    = '1743 2412 1732';       
        par.badch{3}    = '1743 2412 1732';     
        par.badch{4}    = '1743 2412 1732';       
        par.badch{5}    = '1743 2412 1732';         
        par.badch{6}    = '1743 2412 1732';     
        par.badch{7}    = '1743 2412 1732';     
        par.badch{8}    = '1743 2412 1732';
        par.skip{1}     = [];
        par.skip{2}     = [];
        par.skip{3}     = [];
        par.skip{4}     = '141.8 497';
        par.skip{5}     = [];
        par.skip{6}     = [];
        par.skip{7}     = [];
        par.skip{8}     = [];
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s06/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s06/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s06/';                  % SSS Data directory
 
  case 7
        par.subj        = 's07'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 2233 2211';                              
        par.badch{2}    = '1743 2412 1732 2233 2211';  
        par.badch{3}    = '1743 2412 1732';  
        par.badch{4}    = '1743 2412 1732';   
        par.badch{5}    = '1743 2412 1732';     
        par.badch{6}    = '1743 2412 1732';  
        par.badch{7}    = '1743 2412 1732';    
        par.badch{8}    = '1743 2412 1732';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s07/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s07/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s07/';                  % SSS Data directory
   
    case 8
        par.subj        = 's08'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 1323 1421';                              
        par.badch{2}    = '1743 2412 1732 1323';  
        par.badch{3}    = '1743 2412 1732 1323';  
        par.badch{4}    = '1743 2412 1732 1323';   
        par.badch{5}    = '1743 2412 1732 1323';     
        par.badch{6}    = '1743 2412 1732';  
        par.badch{7}    = '1743 2412 1732 1421';    
        par.badch{8}    = '1743 2412 1732 1323 1421 0121';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s08/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s08/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s08/';                  % SSS Data directory   
   
    case 13
        par.subj        = 's13'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 1343 0741 2622 1011 2041 1311';                              
        par.badch{2}    = '1743 2412 1732';  
        par.badch{3}    = '1743 2412 1732 1311';  
        par.badch{4}    = '1743 2412 1732';   
        par.badch{5}    = '1743 2412 1732';     
        par.badch{6}    = '1743 2412 1732 1311 1921';  
        par.badch{7}    = '1743 2412 1732';    
        par.badch{8}    = '1743 2412 1732';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s13/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s13/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s13/';                  % SSS Data directory       
     
   case 15
        par.subj        = 's15'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732';                              
        par.badch{2}    = '1743 2412 1732';  
        par.badch{3}    = '1743 2412 1732 1421';  
        par.badch{4}    = '1743 2412 1732 1421';   
        par.badch{5}    = '1743 2412 1732 1421';     
        par.badch{6}    = '1743 2412 1732 1421 0513';  
        par.badch{7}    = '1743 2412 1732 0513';    
        par.badch{8}    = '1743 2412 1732';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s15/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s15/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s15/';                  % SSS Data directory     
        par.tss = 1     % SSS = 0, tSSS = 1   

   case 16
        par.subj        = 's16'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 2232';                              
        par.badch{2}    = '1743 2412 1732 2232 1933';  
        par.badch{3}    = '1743 2412 1732 2232 1933 1923';  
        par.badch{4}    = '1743 2412 1732 2232';   
        par.badch{5}    = '1743 2412 1732 2232 1933';     
        par.badch{6}    = '1743 2412 1732 2232';  
        par.badch{7}    = '1743 2412 1732 2232';    
        par.badch{8}    = '1743 2412 1732 2232';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s16/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s16/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s16/';                  % SSS Data directory 

   case 18
        par.subj        = 's18'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 2442';                              
        par.badch{2}    = '1743 2412 1732 2442';  
        par.badch{3}    = '1743 2412 1732 2442';  
        par.badch{4}    = '1743 2412 1732';  
        par.badch{5}    = '1743 2412 1732 2442 2132';     
        par.badch{6}    = '1743 2412 1732';  
        par.badch{7}    = '1743 2412 1732';      
        par.badch{8}    = '1743 2412 1732 2442';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s18/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s18/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s18/';                  % SSS Data directory 
 
   case 19
        par.subj        = 's19'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 2231';                              
        par.badch{2}    = '1743 2412 1732 2231 1921';  
        par.badch{3}    = '1743 2412 1732';  
        par.badch{4}    = '1743 2412 1732 1011';  
        par.badch{5}    = '1743 2412 1732 2343';     
        par.badch{6}    = '1743 2412 1732 2343';  
        par.badch{7}    = '1743 2412 1732 2343';      
        par.badch{8}    = '1743 2412 1732 2343';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s19/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s19/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s19/';                  % SSS Data directory         

  case 14
        par.subj        = 's14'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 2442 1822';                              
        par.badch{2}    = '1743 2412 1732 2442 1822 1823 1821';  
        par.badch{3}    = '1743 2412 1732 2442 1822';  
        par.badch{4}    = '1743 2412 1732 2442';  
        par.badch{5}    = '1743 2412 1732 2442 1822 1823 1821';     
        par.badch{6}    = '1743 2412 1732 1823 1821';  
        par.badch{7}    = '1743 2412 1732 2442';      
        par.badch{8}    = '1743 2412 1732 1822 0621';  
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s14/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s14/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s14/';                  % SSS Data directory         

  case 17
        par.subj        = 's17'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 1742';                              
        par.badch{2}    = '1743 2412 1732 1742 0213 0212 0211';        
        par.badch{3}    = '1743 2412 1732 1742 0213 0212 0211';        
        par.badch{4}    = '1743 2412 1732 1742 0213 0212 0211';      
        par.badch{5}    = '1743 2412 1732 1742 0213 0212 0211';        
        par.badch{6}    = '1743 2412 1732 1742 0213 0212 0211';       
        par.badch{7}    = '1743 2412 1732 1742';             
        par.badch{8}    = '1743 2412 1732 1742';          
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s17/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s17/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s17/';                  % SSS Data directory         
        
  case 10
        par.subj        = 's10'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 1131 2641';                              
        par.badch{2}    = '1743 2412 1732 1131 2211';         
        par.badch{3}    = '1743 2412 1732 1131 2641';          
        par.badch{4}    = '1743 2412 1732 1131';     
        par.badch{5}    = '1743 2412 1732 1131 2641';          
        par.badch{6}    = '1743 2412 1732 1131 2641';       
        par.badch{7}    = '1743 2412 1732 1131 2641 2211 2043';          
        par.badch{8}    = '1743 2412 1732 1131 2641 2211';      
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s10/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s10/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s10/';                  % SSS Data directory         
        
  case 12
        par.subj        = 's12'; % Subject name
        par.runlabel    = {'r1_raw','r2_raw','r3_raw','r4_raw','r5_raw','r6_raw','r7_raw','r8_raw'}; % label of each run bad channels for each run
        par.badch{1}    = '1743 2412 1732 1921 2043 2442 2343 0131';                                
        par.badch{2}    = '1743 2412 1732 2442 2343';           
        par.badch{3}    = '1743 2412 1732 2442 2343 1731 1923 2043';        
        par.badch{4}    = '1743 2412 1732 2442 2343 2043 1731';     
        par.badch{5}    = '1743 2412 1732 1731 2442 2043 2343';           
        par.badch{6}    = '1743 2412 1732 1731 2442 2043 1121'; 
        par.badch{7}    = '1743 2412 1732 0121 1942 2442 1343';          
        par.badch{8}    = '1743 2412 1732 0121 1942 2442 1733';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/s12/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/s12/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/s12/';                  % SSS Data directory         
                
        
    otherwise
        disp('Error: Incorrect subject number');
end

par.run         = 1:length(par.runlabel);                                  % Number of runs
