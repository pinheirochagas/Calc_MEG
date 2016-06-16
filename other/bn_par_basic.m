function par = bn_par_basic(n)
% function par = ns_par_basic(n) where n is the subject number
% Specifies subject information, trigger definition and trial function. 
% 
% Parameters here refer to the experiment 'PipelineTest' as an example. 

%% set path %%
addpath '/neurospin/local/mne/share'     % MNE (needed to read and import fif data in fieldtrip) 
addpath '/neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline_tmp/'  % Neurospin pipeline scripts
addpath '/neurospin/meg/meg_tmp/BilatNum_Marco_2010/analysis/ft/'    % local processing scripts
% addpath '/neurospin/meg/meg_tmp/tools_tmp/FieldTrip/fieldtrip_testedversion/fieldtrip/' % most recent fieldtrip version tested with this pipeline
% ft_defaults                                           % sets fieldtrip defaults and configures the minimal required path settings 

%% EXPERIMENT-SPECIFIC INFORMATION %%   
%% path to relevant directories (to be generated in advance) %%
par.rawdir      = '/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/raw/';                  % Raw data path
par.hpdir       = '/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/hp/';                   % Head position text file directory
par.sssdir      = '/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/sss/';                  % SSS Data directory
par.mfdir       = '/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/sss/mf_scripts/';       % Maxfilter scripts directory
% par.ftdir       = '/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/ft/';                   % fieldtrip data directory
% par.avdir       = '/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/ft/ave/'; % fieldtrip average data
% par.statdir     = '/neurospin/meg/meg_tmp/BilatNum_Marco_2010/data/ft/stats/'; % fieldtrip cluster stats

%% SUBJECT-SPECIFIC INFORMATION %%
switch n

    case 2
        par.subj        = 's02'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '2041 2643';                              
        par.badch{2}    = '2041 2643';
        par.badch{3}    = '2041 2643';
        par.badch{4}    = '2041 2643';
        par.badch{5}    = '2041 2643';
        par.badch{6}    = '2041 2643 0541';
        par.badch{7}    = '2041 2643 0541';
        par.badch{8}    = '2031 2041 2643 0541';

    case 3
        par.subj        = 's03'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '1713 2033 2041 2043';                              
        par.badch{2}    = '1333 2043';
        par.badch{3}    = '1333 1421 1811 2033 2043';
        par.badch{4}    = '1333 2033 2041 2043 2421';
        par.badch{5}    = '1333 2033 2421';
        par.badch{6}    = '1411 2033 2641';
        par.badch{7}    = '1411 2033';
        par.badch{8}    = '1522 2033 2641';

    case 4
        par.subj        = 's04'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '';                              
        par.badch{2}    = '';
        par.badch{3}    = '';
        par.badch{4}    = '';
        par.badch{5}    = '';
        par.badch{6}    = '';
        par.badch{7}    = '';
        par.badch{8}    = '';
        
    case 5
        par.subj        = 's05'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '1233 1722 1723 1743';                              
        par.badch{2}    = '1233 1722 1723 1743';
        par.badch{3}    = '1233 1722 1723 1743';
        par.badch{4}    = '1233 1722 1723 1743';
        par.badch{5}    = '1233 1722 1723 1743';
        par.badch{6}    = '1233 1722 1723 1743';
        par.badch{7}    = '1233 1722 1723 1743';
        par.badch{8}    = '1233 1722 1723 1743';
        
    case 6
        par.subj        = 's06'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '2231 2443';
        par.badch{2}    = '2641 2443';
        par.badch{3}    = '2443';
        par.badch{4}    = '2443';
        par.badch{5}    = '2641 2443';
        par.badch{6}    = '2443';
        par.badch{7}    = '2443';
        par.badch{8}    = '2443';

    case 8
        par.subj        = 's08'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '0513 0731 0241 1443 2633 2443 1743';
        par.badch{2}    = '0513 1743 2443';
        par.badch{3}    = '1731 1522 1743 2443';
        par.badch{4}    = '0131 2543 1743 2443';
        par.badch{5}    = '2543 1743 2443';
        par.badch{6}    = '2543 1743 2443';
        par.badch{7}    = '2543 1743 2443';
        par.badch{8}    = '2543 1743 2443';

    case 9
        par.subj        = 's09'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '1722 1723';                              
        par.badch{2}    = '1722 1723';
        par.badch{3}    = '1722 1723';
        par.badch{4}    = '1722 1723';
        par.badch{5}    = '1722 1723';
        par.badch{6}    = '1722 1723';
        par.badch{7}    = '1722 1723';
        par.badch{8}    = '1722 1723';

    case 300 % empty room data for subject s03
        par.subj        = 'Er_s03'; % Subject name
        par.runlabel    = {''}; % label of each run bad channels for each run
        par.badch{1}    = '2033 2421 2641';                              

    case 10
        par.subj        = 's10'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '1731';                              
        par.badch{2}    = '1731';
        par.badch{3}    = '1731';
        par.badch{4}    = '1731';
        par.badch{5}    = '1731';
        par.badch{6}    = '1731 1831';
        par.badch{7}    = '1721';
        par.badch{8}    = '';
 
    case 11
        par.subj        = 's11'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '1722 1723 2443';                              
        par.badch{2}    = '0741 1722 1723 2443';
        par.badch{3}    = '1722 1723 2443';
        par.badch{4}    = '1722 1723 2443';
        par.badch{5}    = '1722 1723 2443';
        par.badch{6}    = '1722 1723 2443';
        par.badch{7}    = '1722 1723 2443';
        par.badch{8}    = '1722 1723 2443';
        
    case 12
        par.subj        = 's12'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '0211 2313 1211 1722 1723 2443';                              
        par.badch{2}    = '0211 2313 1211 1722 1723 2443';
        par.badch{3}    = '2313 1722 1723 2443';
        par.badch{4}    = '2313 1722 1723 2443';
        par.badch{5}    = '2313 1722 1723 2443';
        par.badch{6}    = '2313 1722 1723 2443';
        par.badch{7}    = '2313 1722 1723 2443';
        par.badch{8}    = '2313 1722 1723 2443';

    case 13
        par.subj        = 's13'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '2533';                              
        par.badch{2}    = '';
        par.badch{3}    = '';
        par.badch{4}    = '';
        par.badch{5}    = '';
        par.badch{6}    = '';
        par.badch{7}    = '';
        par.badch{8}    = '';
        
     case 14
        par.subj        = 's14'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '1712 1722 1723 2443';                              
        par.badch{2}    = '1712 1722 1723 2443';
        par.badch{3}    = '1722 1723 2443';
        par.badch{4}    = '1722 1723 2443';
        par.badch{5}    = '1722 1723 2443';
        par.badch{6}    = '1722 1723 2443';
        par.badch{7}    = '1722 1723 2443';
        par.badch{8}    = '1722 1723 2443';
        
     case 15
        par.subj        = 's15'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '0543 1211 1643 1722 1723';                              
        par.badch{2}    = '0543 1211 1643 1722 1723';
        par.badch{3}    = '0543 1211 2211 2233 1643 1722 1723';
        par.badch{4}    = '0543 1211 2233 1643 1722 1723';
        par.badch{5}    = '0543 1211 2233 1643 1722 1723';
        par.badch{6}    = '0543 1211 2233 1643 1722 1723';
        par.badch{7}    = '0543 1211 2233 1643 1722 1723';
        par.badch{8}    = '0543 1211 2233 1643 1722 1723';
 %     case 16
%         par.subj        = 's16'; % Subject name
%         par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
%         par.badch{1}    = '1722 1723 2023 2432 1623 1211';                              
%         par.badch{2}    = '1722 1723 2432 1623 1211 1942';
%         par.badch{3}    = '1722 1723 2432 1623 1211';
%         par.badch{4}    = '1722 1723 2432 1623 1211';
%         par.badch{5}    = '1722 1723 2432 1623 1211';
%         par.badch{6}    = '1722 1723 2432 1623 1211';
%         par.badch{7}    = '1722 1723 2432 1623 1211';
%         par.badch{8}    = '1722 1723 2432 1623 1211';
%     

    case 16
        par.subj        = 's16'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7'}; % label of each run bad channels for each run
        par.badch{1}    = '1722 1723 2023 2432 1623 1211';                              
        par.badch{2}    = '1722 1723 2432 1623 1211 1942';
        par.badch{3}    = '1722 1723 2432 1623 1211';
        par.badch{4}    = '1722 1723 2432 1623 1211';
        par.badch{5}    = '1722 1723 2432 1623 1211';
        par.badch{6}    = '1722 1723 2432 1623 1211';
        par.badch{7}    = '1722 1723 2432 1623 1211';
        
    case 17
        par.subj        = 's17'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '';                              
        par.badch{2}    = '';
        par.badch{3}    = '';
        par.badch{4}    = '';
        par.badch{5}    = '';
        par.badch{6}    = '';
        par.badch{7}    = '';
        par.badch{8}    = '';
    
    case 18
        par.subj        = 's18'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '0821';                              
        par.badch{2}    = '0821';
        par.badch{3}    = '0821';
        par.badch{4}    = '0821';
        par.badch{5}    = '0821';
        par.badch{6}    = '0821';
        par.badch{7}    = '0821';
        par.badch{8}    = '0821';

    case 19
        par.subj        = 's19'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '0821 1422';                              
        par.badch{2}    = '0821';
        par.badch{3}    = '0821 2133';
        par.badch{4}    = '0821';
        par.badch{5}    = '';
        par.badch{6}    = '';
        par.badch{7}    = '';
        par.badch{8}    = '2133';

    case 20
        par.subj        = 's20'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '1211';                              
        par.badch{2}    = '1211';
        par.badch{3}    = '1211';
        par.badch{4}    = '1211';
        par.badch{5}    = '1211';
        par.badch{6}    = '1211';
        par.badch{7}    = '1211';
        par.badch{8}    = '1211';
 
    case 21
        par.subj        = 's21'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '1211 2421 2133';                              
        par.badch{2}    = '1211 2421 2133';
        par.badch{3}    = '1211 2421';
        par.badch{4}    = '1211 2421';
        par.badch{5}    = '1211 2421';
        par.badch{6}    = '1211 2421 2133';
        par.badch{7}    = '1211 2421';
        par.badch{8}    = '1211 2421';

    case 22
        par.subj        = 's22'; % Subject name
        par.runlabel    = {'r1','r2','r3','r4','r5','r6','r7','r8'}; % label of each run bad channels for each run
        par.badch{1}    = '1211 1231';                              
        par.badch{2}    = '1211 1231 2133 2421';
        par.badch{3}    = '1211 1231';
        par.badch{4}    = '1211 1231';
        par.badch{5}    = '1211 2041';
        par.badch{6}    = '1211 2133';
        par.badch{7}    = '1211';
        par.badch{8}    = '1211';
       
        % ...here you can add as many subjects as you want %
    otherwise
        disp('Error: Incorrect subject number');
end

par.run         = 1:length(par.runlabel);                                  % Number of runs
