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
fieldnamesRDM = fieldnames(RDM);

measure=@cosmo_target_dsm_corr_measure;
measure_args=struct();
measure_args.type='Spearman'; %correlation type between target and MEG dsms
measure_args.metric='Spearman'; %metric to use to compute MEG dsm
measure_args.center_data=true; %removes the mean pattern before correlating
measure_args.regress_dsm = RDM.operator;

RSA = [];
for i = 1:length(fieldnamesRDM)
    disp(['processing RSA of ' (fieldnamesRDM{i})]);
    if strcmp((fieldnamesRDM{i}), 'result') == 1
        measure_args.regress_dsm = RDM.operator;
        measure_args.target_dsm = RDM.(fieldnamesRDM{i});
        RSA.(fieldnamesRDM{i}) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
        measure_args = rmfield(measure_args,'regress_dsm');
    else
        measure_args.target_dsm = RDM.(fieldnamesRDM{i});
        RSA.(fieldnamesRDM{i}) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
    end
end

%% Save
save([rsa_result_dir 'RSA_cosmo_' subject '.mat'], 'RSA')


end
