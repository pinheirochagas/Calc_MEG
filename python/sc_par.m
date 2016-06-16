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

        
    otherwise
        disp('Error: Incorrect subject number');
end

par.run         = 1:length(par.runlabel);                                  % Number of runs
