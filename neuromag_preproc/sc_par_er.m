function par = sc_par_er(n) 
% function par = sc_par_er(n) where n is the subject number
% Specifies subject information for performing Maxfilter on the associated empty room data. 

%% set path %%
addpath '/neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline_tmp/'  % Neurospin pipeline scripts
addpath '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/neuromag_preproc/'    % local processing scripts

%% EXPERIMENT-SPECIFIC INFORMATION %%   
% path to relevant directories (to be generated in advance) %%
% par.rawdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/raw/';                  % Raw data path
% par.hpdir       = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/hp/';                   % Head position text file directory
% par.sssdir      = '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/sss/';                  % SSS Data directory
par.mfdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/mf_scripts/';       % Maxfilter scripts directory

%% SUBJECT-SPECIFIC INFORMATION %%
switch n 
    
    case 1
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's1ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 2223 2412 1743';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s01/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s01/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s01/';                  % SSS Data directory
        
    case 2
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's2ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0711 2223 2412 1743 0543';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s02/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s02/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s02/';                  % SSS Data directory

    case 3
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's3ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s03/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s03/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s03/'; 
        
    case 4
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's4ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 2223 2412 1743';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s04/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s04/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s04/';                  % SSS Data directory
        
    case 5
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's5ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 2223 2412 1743 1421';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s05/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s05/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s05/';                  % SSS Data directory

    case 6
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's6ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 2223 2412 1743 2031 1841 1323';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s06/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s06/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s06/'; 
        
    case 7
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's7ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 2223 2412 1743 2423 2021 1323 2521';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s07/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s07/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s07/';                  % SSS Data directory
        
    case 8
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's8ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 2223 2412 1743 1921';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s08/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s08/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s08/';                  % SSS Data directory

    case 9
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's9ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 2223 2412 1743 0941 0241';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s09/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s09/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s09/'; 
        
    case 10
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's10ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 2223 2412 1743 2433 1631 2221';      
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s10/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s10/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s10/';                  % SSS Data directory
        
    case 11
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's11ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 2223 2412 1732 1631 2221';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s11/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s11/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s11/';                  % SSS Data directory

    case 12
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's12ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 0711 2223 2412 1743 0543';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s12/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s12/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s12/'; 
        
    case 13
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's13ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 1813 2433';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s13/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s13/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s13/';                  % SSS Data directory
        
    case 14
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's14ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 2223 2412 1732 2438 1441 1921';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s14/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s14/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s14/';                  % SSS Data directory

    case 15
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's15ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 2641 1421';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s15/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s15/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s15/'; 
        
    case 16
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's16ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 2642 2433';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s16/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s16/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s16/';                  % SSS Data directory
        
    case 17
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's17ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 2642 2433';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s17/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s17/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s17/';                  % SSS Data directory

    case 18
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's18ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 1343 2433';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s18/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s18/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s18/'; 
        
    case 19
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's19ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 2412 2612 2433 0123';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s19/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s19/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s19/';                  % SSS Data directory
        
    case 21
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's21ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 2343 2232 2433';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s21/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s21/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s21/';                  % SSS Data directory

    case 22
        par.subj       = 'emptyroom'; % Subject name
        par.outfile    = 's22ER'; % name of output file
        par.badch      = '1722 1723 1732 2442 0341 0322 2432 2433';
        par.rawdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/raw/s22/';                  % Raw data path
        par.hpdir       = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/hp/s22/';                   % Head position text file directory
        par.sssdir      = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/sss/s22/'; 
        
    case 0
        par.subj       = ''; % Subject name
        par.outfile    = ''; % name of output file
        par.badch      = '';                              

    otherwise
        disp('Error: Incorrect subject number');
end

