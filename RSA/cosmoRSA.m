function cosmoRSA(subject, ds)

% InitDirsMEGcalc
InitDirsMEGcalc


% AVG data given the condition
ds=cosmo_average_samples(ds, 'repeats',1, 'split_by', {'stim'});

%sanity check
cosmo_check_dataset(ds);
fprintf('Dataset input:\n');
cosmo_disp(ds);

% Define targets and chunks
ds.sa.targets = (1:length(ds.sa.stim))'; % treats each trial as one 'condition'
ds.sa.chunks = (1:length(ds.sa.stim))'; % treats each trial as being independent
nbrhood=cosmo_interval_neighborhood(ds,'time','radius',10); % to calculate the correlations it looks at each timepoint separately

%% Run Magnitude Model
% set measure
load([rsa_result_dir 'stim_matrices/calc_RDM_matrices.mat'])

measure=@cosmo_target_dsm_corr_measure;
measure_args=struct();
measure_args.type='Spearman'; %correlation type between target and MEG dsms
measure_args.metric='Spearman'; %metric to use to compute MEG dsm
measure_args.center_data=true; %removes the mean pattern before correlating

%% Run RSA
RSA = [];
%% Single factor models
fieldnames_RDM = fieldnames(RDM);
for i = 1:length(fieldnames_RDM)
    disp(['processing RSA of ' (fieldnames_RDM{i})]);
    measure_args.target_dsm = RDM.(fieldnames_RDM{i});
    RSA.(fieldnames_RDM{i}) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
end

%% Results model regressing out operator 
disp('processing RSA of result_reg_operator');
measure_args.target_dsm = RDM.result_mag;
measure_args.regress_dsm = RDM.operator;
RSA.result_mag_reg_operator = cosmo_searchlight(ds,nbrhood,measure,measure_args);
measure_args = rmfield(measure_args,'regress_dsm');

%% Magnitude models regressing out visual models 
RDM_mag_vis = {'op1_mag', 'op1_vis', 'op2_mag', 'op2_vis', 'result_mag', 'result_vis'};
for i = 1:2:length(RDM_mag_vis)
    disp(['processing RSA of ' [RDM_mag_vis{i} '_reg_' RDM_mag_vis{i+1}]]);
    measure_args.target_dsm = RDM.(RDM_mag_vis{i});
    measure_args.regress_dsm = RDM.(RDM_mag_vis{i+1});
    RSA.([RDM_mag_vis{i} 'reg' RDM_mag_vis{i+1}]) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
    measure_args = rmfield(measure_args,'regress_dsm');
end

%% Visual models regressing out magnitude models 
RDM_mag_vis = {'op1_mag', 'op1_vis', 'op2_mag', 'op2_vis', 'result_mag', 'result_vis'};
for i = 2:2:length(RDM_mag_vis)
    disp(['processing RSA of ' [RDM_mag_vis{i} '_reg_' RDM_mag_vis{i-1}]]);
    measure_args.target_dsm = RDM.(RDM_mag_vis{i});
    measure_args.regress_dsm = RDM.(RDM_mag_vis{i-1});
    RSA.([RDM_mag_vis{i} 'reg' RDM_mag_vis{i-1}]) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
    measure_args = rmfield(measure_args,'regress_dsm');
end

%% Save
save([rsa_result_dir 'RSA_cosmo_' subject '.mat'], 'RSA')


end
