function par = sc_par(n)
% function par = sc_par(n) where n is the subject number
% Specifies subject information for performing Maxfilter. 

%% set path %%
addpath '/neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline_tmp/'  % Neurospin pipeline scripts
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/neuromag_preproc/'    % local processing scripts

%% EXPERIMENT-SPECIFIC INFORMATION %%   
%% path to relevant directories (to be generated in advance) %%
% par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/';                  % Raw data path
% par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/';                   % Head position text file directory
% par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/';                  % SSS Data directory
par.mfdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/mf_scripts/';       % Maxfilter scripts directory

%% SUBJECT-SPECIFIC INFORMATION %%
switch n

    case 1
%         par.subj        = 's01'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '0123 1722 1723 1732 2412';                              
        par.badch{2}     = '1722 1723 1732 1933 2143 2412 2522';    
        par.badch{3}     = '0123 1722 1723 1732 1933 2412 2542';    
        par.badch{4}     = '0123 1722 1723 1732 1933 2412 2542';    
        par.badch{5}     = '1722 1723 1732 1831 2412 2542';    
        par.badch{6}     = '1722 1723 1732 2412';    
        par.badch{7}     = '0123 0722 0723 1722 1723 1732 1933 2412 2542';   
        par.badch{8}     = '1722 1723 1732 2412 2542';
        par.badch{9}     = '0123 1722 1723 1732 2412 2542';    
        par.badch{10}    = '0123 1722 1723 1732 2412 2542';    
        par.badch{11}    = '0123 1722 1723 1732 1933 2412 2542';    
        par.badch{12}    = '0123 1722 1723 1732 2412 2542';    
        par.badch{13}    = '0123 1722 1723 1732 2412 2542';   
        par.badch{14}    = '0123 1722 1723 1732 2412 2542';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s01/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s01/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s01/';                  % SSS Data directory


    case 2
%         par.subj        = 's02'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '0543 1722 1723 1732 2442';                              
        par.badch{2}     = '1722 1723 1732 2442';    
        par.badch{3}     = '0123 1722 1723 1732 2442';   
        par.badch{4}     = '0311 1722 1723 1732 2442';   
        par.badch{5}     = '0543 1722 1723 1732 2223 2442';  
        par.badch{6}     = '0311 1722 1723 1732 2211 2442';
        par.badch{7}     = '0123 1722 1723 1732 2442';   
        par.badch{8}     = '0123 1722 1723 1732 2442';   
        par.badch{9}     = '0543 1722 1723 1732 2223 2442';
        par.badch{10}    = '0543 1722 1723 1732 2442';   
        par.badch{11}    = '1722 1723 1732 2442';    
        par.badch{12}    = '1722 1723 1732 2442';  
        par.badch{13}    = '1722 1723 1732 2442'; 
        par.badch{14}    = '1722 1723 1732 2442';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s02/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s02/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s02/';                  % SSS Data directory

    case 3 
%         par.subj        = 's03'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0613';                              
        par.badch{2}     = '1722 1723 1732 2442 0613';    
        par.badch{3}     = '1722 1723 1732 2442 0613';   
        par.badch{4}     = '1722 1723 1732 2442';   
        par.badch{5}     = '1722 1723 1732 2442 1131 1441';  
        par.badch{6}     = '1722 1723 1732 2442 1131';
        par.badch{7}     = '1722 1723 1732 2442 1131 1831';   
        par.badch{8}     = '1722 1723 1732 2442 1131 1831';   
        par.badch{9}     = '1722 1723 1732 2442 1131 1831 0613';
        par.badch{10}    = '1722 1723 1732 2442 1131 1831';   
        par.badch{11}    = '1722 1723 1732 2442 0613 1911 1121';    
        par.badch{12}    = '1722 1723 1732 2442 1131';  
        par.badch{13}    = '1722 1723 1732 2442 1131'; 
        par.badch{14}    = '1722 1723 1732 2442 1131 1831';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s03/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s03/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s03/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)

    case 4
%         par.subj        = 's04'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 1421';                              
        par.badch{2}     = '1722 1723 1732 2442 ';    
        par.badch{3}     = '1722 1723 1732 2442';   
        par.badch{4}     = '1722 1723 1732 2442';   
        par.badch{5}     = '1722 1723 1732 2442 1422';  
        par.badch{6}     = '1722 1723 1732 2442 0613';
        par.badch{7}     = '1722 1723 1732 2442 0621';   
        par.badch{8}     = '1722 1723 1732 2442';   
        par.badch{9}     = '1722 1723 1732 2442';
        par.badch{10}    = '1722 1723 1732 2442 1421 1422';   
        par.badch{11}    = '1722 1723 1732 2442 1422';    
        par.badch{12}    = '1722 1723 1732 2442';  
        par.badch{13}    = '1722 1723 1732 2442'; 
        par.badch{14}    = '1722 1723 1732 2442 2213';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s04/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s04/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s04/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 5
%         par.subj        = 's05'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 1731 1421 2423';                              
        par.badch{2}     = '1722 1723 1732 2442 1731 1421';    
        par.badch{3}     = '1722 1723 1732 2442 1731 1421';   
        par.badch{4}     = '1722 1723 1732 2442 1731 1421';   
        par.badch{5}     = '1722 1723 1732 2442 1731 1421';  
        par.badch{6}     = '1722 1723 1732 2442 1731 1421 2423';
        par.badch{7}     = '1722 1723 1732 2442 1731 1421';   
        par.badch{8}     = '1722 1723 1732 2442 1731 1421 1931';   
        par.badch{9}     = '1722 1723 1732 2442 1731 1421 1931';
        par.badch{10}    = '1722 1723 1732 2442 1421 1731 1931';   
        par.badch{11}    = '1722 1723 1732 2442 1731 1421';    
        par.badch{12}    = '1722 1723 1732 2442 1731 1421';  
        par.badch{13}    = '1722 1723 1732 2442 1731 1421'; 
        par.badch{14}    = '1722 1723 1732 2442';      
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s05/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s05/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s05/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 6
%         par.subj        = 's06'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 1331 2423 1921 1941';                              
        par.badch{2}     = '1722 1723 1732 2442 1331 2423 1331 2031';    
        par.badch{3}     = '1722 1723 1732 2442 1731 1743 2433 2423';   
        par.badch{4}     = '1722 1723 1732 2442 1831 2041 2433 2423';   
        par.badch{5}     = '1722 1723 1732 2442 1831 2041 2423 2433';  
        par.badch{6}     = '1722 1723 1732 2442 1721 2423 2433 1721';
        par.badch{7}     = '1722 1723 1732 2442 2423 2433';   
        par.badch{8}     = '1722 1723 1732 2442 2433 2423 0511';   
        par.badch{9}     = '1722 1723 1732 2442 2433 2423 1031';
        par.badch{10}    = '1722 1723 1732 2442 2433 2423 1222 1323';   
        par.badch{11}    = '1722 1723 1732 2442 2433 2423 1731';    
        par.badch{12}    = '1722 1723 1732 2442 2433 2423 1831 2041';  
        par.badch{13}    = '1722 1723 1732 2442 2433 2423'; 
        par.badch{14}    = '1722 1723 1732 2442 2433 2423';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s06/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s06/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s06/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 7
%         par.subj        = 's07'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 2423 2433 1131 1121';                              
        par.badch{2}     = '1722 1723 1732 2442 2423 2433 1131';    
        par.badch{3}     = '1722 1723 1732 2442 2423 2433 1131';   
        par.badch{4}     = '1722 1723 1732 2442 2423 2433 1131';   
        par.badch{5}     = '1722 1723 1732 2442 2423 2433';  
        par.badch{6}     = '1722 1723 1732 2442 2423 2433';
        par.badch{7}     = '1722 1723 1732 2442 2423 2433';   
        par.badch{8}     = '1722 1723 1732 2442 2423 2433 1131';   
        par.badch{9}     = '1722 1723 1732 2442 2423 2433 1131';
        par.badch{10}    = '1722 1723 1732 2442 2423 2433 1131';   
        par.badch{11}    = '1722 1723 1732 2442 2423 2433 1131';    
        par.badch{12}    = '1722 1723 1732 2442 2423 2433 1131';  
        par.badch{13}    = '1722 1723 1732 2442 2423 2433 1131'; 
        par.badch{14}    = '1722 1723 1732 2442 2423 2433 1131';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s07/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s07/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s07/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 8
%         par.subj        = 's08'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341';                              
        par.badch{2}     = '1722 1723 1732 2442';    
        par.badch{3}     = '1722 1723 1732 2442';   
        par.badch{4}     = '1722 1723 1732 2442 2422 2423';   
        par.badch{5}     = '1722 1723 1732 2442';  
        par.badch{6}     = '1722 1723 1732 2442';
        par.badch{7}     = '1722 1723 1732 2442';   
        par.badch{8}     = '1722 1723 1732 2442 2423 2433';   
        par.badch{9}     = '1722 1723 1732 2442';
        par.badch{10}    = '1722 1723 1732 2442';   
        par.badch{11}    = '1722 1723 1732 2442';    
        par.badch{12}    = '1722 1723 1732 2442';  
        par.badch{13}    = '1722 1723 1732 2442'; 
        par.badch{14}    = '1722 1723 1732 2442';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s08/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s08/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s08/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
 
     case 9 % 
%         par.subj        = 's09'; % Subject name 
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 1723';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 2422 2413';    
        par.badch{3}     = '1722 1723 1732 2442 0341 2422 2423';   
        par.badch{4}     = '1722 1723 1732 2442 0341 2433 2423';   
        par.badch{5}     = '1722 1723 1732 2442 0341 1723';  
        par.badch{6}     = '1722 1723 1732 2442 0341';
        par.badch{7}     = '1722 1723 1732 2442 0341'; % rejected entire run?    
        par.badch{8}     = '1722 1723 1732 2442 0341 2422';   
        par.badch{9}    = '1722 1723 1732 2442 0341';
        par.badch{10}    = '1722 1723 1732 2442 0341';   
        par.badch{11}    = '1722 1723 1732 2442 0341 1723';    
        par.badch{12}    = '1722 1723 1732 2442 0341';  
        par.badch{13}    = '1722 1723 1732 2442 0341'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 2423';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s09/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s09/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s09/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
     
     case 10
%         par.subj        = 's10'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0911 0131 0341 0931';                              
        par.badch{2}     = '1722 1723 1732 2442 0131 0322 2433 0341 0931';    
        par.badch{3}     = '1722 1723 1732 2442 0131 0322 2433 1831';   
        par.badch{4}     = '1722 1723 1732 2442 0131 0322 2433 1831';
        par.badch{5}     = '1722 1723 1732 2442 0523 0322 2433';  
        par.badch{6}     = '1722 1723 1732 2442 0322 2433 0341';
        par.badch{7}     = '1722 1723 1732 2442 0322 2433 0341';   
        par.badch{8}     = '1722 1723 1732 2442 0322 2433 0341';   
        par.badch{9}     = '1722 1723 1732 2442 2433 0341';
        par.badch{10}    = '1722 1723 1732 2442 2231 2433 2542 0341';   
        par.badch{11}    = '1722 1723 1732 2442 0131 0322 2433 0341';    
        par.badch{12}    = '1722 1723 1732 2442 0322 0523 0341 1831';  
        par.badch{13}    = '1722 1723 1732 2442 0322 2433 0341'; 
        par.badch{14}    = '1722 1723 1732 2442 2433 2231 0341';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s10/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s10/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s10/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 11
%         par.subj        = 's11'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 1532 1411 2433';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 1532 1131 2433';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 1532 1411 2433';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 1532 1411 2433';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 1532 1411 2433';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 1532 1411 2433';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 1532 1411 2433'; % skip entire run? no, maxfilter corrects! 
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 1532 1411 2433';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 1532';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 1532 1411 2433';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 1532 1411 2433 2423 2511';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 1532 1411 2433';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 1532 1411 2433'; % skip entire run? no, maxfilter corrects! 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 1532 1411 2433';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s11/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s11/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s11/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 12
%         par.subj        = 's12'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 0721 2433 1233';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 0721 2031 2311 2433';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 0721 2433';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 0721 2433';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 0721 2433';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 0721'; % continuar daqui
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 0721';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 0721';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 0721';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 0721 2433';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 0721';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 0721';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 0721'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 0721';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s12/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s12/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s12/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 13 % RERUN maxfilter skiping the big jumps
%         par.subj        = 's13'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 0741 0241 1233 2433';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 2442 2433 0511';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 2433 0523 0241'; % big jumps - might have to discart this run. no, maxfilter corrects!     
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 2433 1233'; % big jumps - might have to discart this run. no, maxfilter corrects! 
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 2433 1213 1223 2423';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 2433 1223 0241';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 2433 2432 0241';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 2433 1031 ';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 2433 1223';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 1143 2433 2423 1742';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 0741 0511 2423 1223 2442';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 2442 2433 0241 0523'; % big jumps - might have to discart this run. no, maxfilter corrects!  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 2433 1043'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 1233 2433 1743';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s13/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s13/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s13/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 14
%         par.subj        = 's14'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 1921 2433 2621 2641';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 1921 2433 2621 2641 2431';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 1921 0211 0221 0241 1311';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 1921 2433 1433 1921 1223';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 1921 0211 0221 0241 1311 0711 0721 0731 1831';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 2433 1921 1421';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 1921 2433';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 1921 2433';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 1921 2433';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 1921 2433';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 1921 2433';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 1921 2433';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 1921 2433'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 1921 2433';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s14/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s14/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s14/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 15
%         par.subj        = 's15'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 0523 2433 1233';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 0523 2433 1233';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 0523 2433 1233';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 2433 1233';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 2433 1233';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 2433 1233';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 2433 1233 2423';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 2433 1233 2423';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 2433 1233';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 0523 2433';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 2433 0523';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 1233 2433 1831';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 2433'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 2433 ';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s15/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s15/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s15/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 16
%         par.subj        = 's07'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 2433 1233';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 2433 1233';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 2433 1233';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 2433 1233';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 2433 1233';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 2433 1233';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 2433 1311 0121 1031 0523 1233';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 2433 0523 1233';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 2433 0523 1233';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 2433 1233';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 2433 1233';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 2433 1233';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 2433 1233'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 2433 1233 0523';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s16/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s16/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s16/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 17
%         par.subj        = 's17'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 2433';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 2433 1233';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 2433';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 2433 1233';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 2433 0523';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 2433 0523';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 2433 0523';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 2433 0523';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 2433 1233';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 2433 1233';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 2433 0523'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 2433';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s17/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s17/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s17/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 18
%         par.subj        = 's18'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 0131 2433 2131';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 2433 1411 1233 0121';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 2433 1421 0621 1233';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 2433 1233';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 2433 1411';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 2433 1411 0121 1223';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 2433 1411 1233';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 2433 1411 1233';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 2433 1411 1233';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 2433 1411 1223';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 2433 1223';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 2433 1411';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 2433 1411 0531'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 2433 1411 1223 ';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s18/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s18/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s18/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 19
%         par.subj        = 's07'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 1233 2433 0523';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 1233 2433 0523'; % very noisy run specially around 155 ms   
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 2433 1233';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 1233 2433';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 2433';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 1233 2433';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 2433';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 2433';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 2433'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 2433';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s19/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s19/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s19/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 21
%         par.subj        = 's20'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 2433 2232 0541 1233';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 2433 2041 0241 0211 1631';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 2433 2233 1233 2232';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 2433 1233 2232';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 2433 0211 1233 2232';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 2433 1121 2442 2232 2611';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 1233 2433 2232 0241';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 0241 2433 0211 1121';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 2433 2041';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 2433 0541 2232';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 2433 2232';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 2433 2232 2041 2232'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 2232 2313 2041 1631';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s21/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s21/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s21/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
     case 22
%         par.subj        = 's22'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'calc1','calc2','calc3','calc4','calc5','calc6','calc7','calc8','calc9','calc10','vsa1','vsa2','vsa3','vsa4'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 2433 2442';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 2433 1233 2442';    
        par.badch{3}     = '1722 1723 1732 2442 0341 0322 2433 2442';   
        par.badch{4}     = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{5}     = '1722 1723 1732 2442 0341 0322 2433';  
        par.badch{6}     = '1722 1723 1732 2442 0341 0322 2433 1233';
        par.badch{7}     = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{8}     = '1722 1723 1732 2442 0341 0322 2433';   
        par.badch{9}     = '1722 1723 1732 2442 0341 0322 2433 0111';
        par.badch{10}    = '1722 1723 1732 2442 0341 0322 2433 0111';   
        par.badch{11}    = '1722 1723 1732 2442 0341 0322 2442 2433';    
        par.badch{12}    = '1722 1723 1732 2442 0341 0322 2433';  
        par.badch{13}    = '1722 1723 1732 2442 0341 0322 2433'; 
        par.badch{14}    = '1722 1723 1732 2442 0341 0322 2433 2442';   
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s22/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s22/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s22/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
        
     case 23
%         par.subj        = 's22'; % Subject name
        par.subj        = []; % Subject name
        par.runlabel    = {'dror1','dror2'}; % label of each run bad channels for each run
        par.badch{1}     = '1722 1723 1732 2442 0341 0322 2423 2443';                              
        par.badch{2}     = '1722 1723 1732 2442 0341 0322 2423 2443';    
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/dror/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/dror/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/dror/';                  % SSS Data directory
        mkdir(par.hpdir)
        mkdir(par.sssdir)
        
        
    otherwise
        disp('Error: Incorrect subject number');
end

par.run         = 1:length(par.runlabel);                                  % Number of runs
