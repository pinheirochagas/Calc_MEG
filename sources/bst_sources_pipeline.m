%% Pipeline for source analyses
InitDirsMEGcalc
AddPathsMEGcalc
%% subjects list
subjects = {'s01','s02','s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15','s16','s17','s18','s19','s21','s22'};
subjects = {'s01', 's03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15','s16','s17','s18','s19','s21','s22'};

%% Add a reference channel in the global
% addRefChannelBSTfolder(subjects)

%% Import conditions to brainstorm
cond_lab = {'add'};
op_lab = {'op1_3'};
    
bstImportRecordings(subjects, cond_lab, op_lab)


%% Average conditions
% Put all them together: 

cond_lab = {'add', 'sub', 'addsub'};
op_lab = {'opall', 'op1_3', 'op1_4', 'op1_5', 'op1_6', 'op2_0', 'op2_1', 'op2_2', 'op2_3', 'cRes_3', 'cRes_4', 'cRes_5', 'cRes_6'};
op_lab = {'opall'};

count = 1;
for condi = 1:length(cond_lab)
    for opi = 1:length(op_lab)
        params.cond_lab = cond_lab{condi};
        params.op_lab = op_lab{opi};
        
        % Set condition
        conditions{count} = [params.cond_lab '_' params.op_lab]; 
        count = count+1;
    end
end
    
% % 
% cd(bst_sfw_dir)
% brainstorm nogui;

% btsAVGtrialsByCond(subjects, conditions)

%% Projection to group with spatial smoothing
source_z_sm_group(subjects(1),conditions,'dSPM')

source_z_sm_group(subjects,{'addsub_opall'},'MN')

source_z_sm_group(subjects,{'sub_opall'},'dSPM')

