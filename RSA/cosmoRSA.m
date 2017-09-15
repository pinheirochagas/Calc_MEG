function cosmoRSA(subject, ds, timesphere, operation, single_or_mr)

%% HAVE TO SELECT CHANNEL TYPES, because MAG AND GRAD are not in the same scale! 
% Or maybe not an issue for RSA? 

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
nbrhood=cosmo_interval_neighborhood(ds,'time','radius',timesphere); % to calculate the correlations it looks at each timepoint separately

%% Load matrices
% set measure
load([rsa_result_dir 'stim_matrices/calc_RDM_matrices.mat'])
%load([rsa_result_dir 'stim_matrices/calc_RDM_matrices_cres_3456.mat'])

%% run RSA
measure_args=struct();
measure=@cosmo_target_dsm_corr_measure;

measure_args.type='Spearman'; %correlation type between target and MEG dsms
measure_args.metric='Spearman'; %metric to use to compute MEG dsm % mahalanobis
measure_args.center_data=true; %removes the mean pattern before correlating


%% Multiple regression
if strcmp(single_or_mr, 'mr') == 1
    % Results model regressing out everything else
    if strcmp(operation, 'calc') == 1
        predictors = {'operator', 'op1_mag', 'op1_vis', 'op2_mag', 'op2_vis', 'result_mag', 'result_vis'};
        measure_args.glm_dsm = {RDM.(predictors{1}), RDM.(predictors{2}), RDM.(predictors{3}), RDM.(predictors{4}), RDM.(predictors{5}), RDM.(predictors{6}), RDM.(predictors{7})} ;
    elseif strcmp(operation, 'add') == 1
        predictors = {'addsub_op1_vis', 'addsub_op1_mag', 'addsub_op2_vis', 'addsub_op2_mag', 'add_result_vis', 'add_result_mag'};
        measure_args.glm_dsm = {RDM.(predictors{1}), RDM.(predictors{2}), RDM.(predictors{3}), RDM.(predictors{4}), RDM.(predictors{5}), RDM.(predictors{6})} ;
    elseif strcmp(operation, 'sub') == 1
        predictors = {'addsub_op1_vis', 'addsub_op1_mag', 'addsub_op2_vis', 'addsub_op2_mag', 'sub_result_vis', 'sub_result_mag'};
        measure_args.glm_dsm = {RDM.(predictors{1}), RDM.(predictors{2}), RDM.(predictors{3}), RDM.(predictors{4}), RDM.(predictors{5}), RDM.(predictors{6})} ;
    elseif strcmp(operation, 'calc_noZero') == 1
        predictors = {'operator_noZero', 'op1_mag_noZero', 'op1_vis_noZero', 'op2_mag_noZero', 'op2_vis_noZero', 'result_mag_noZero', 'result_vis_noZero'};
        measure_args.glm_dsm = {RDM.(predictors{1}), RDM.(predictors{2}), RDM.(predictors{3}), RDM.(predictors{4}), RDM.(predictors{5}), RDM.(predictors{6}), RDM.(predictors{7})} ;
    end
    disp('processing RSA');
    RSA.result_reg_everything = cosmo_searchlight(ds,nbrhood,measure,measure_args);
    RSA.predictors = predictors;
    % Save
    save([rsa_result_dir 'RSA_all_DSM_mr_' operation '_tbin' num2str(timesphere) '_' subject '.mat'], 'RSA')
    
%% Single regressions
else
    measure_args=struct();
    measure_args.type='Spearman'; %correlation type between target and MEG dsms
    measure_args.metric='Spearman'; %metric to use to compute MEG dsm % mahalanobis
    measure_args.center_data=true; %removes the mean pattern before correlating
    
%     %% Single factor models
%     predictors = {'operator', 'op1_mag', 'op1_vis', 'op2_mag', 'op2_vis', 'result_mag', 'result_vis'};
%     % Run RSA
%     RSA = [];
%     for i = 1:length(predictors)
%         disp(['processing RSA of ' (predictors{i})]);
%         measure_args.target_dsm = RDM.(predictors{i});
%         RSA.(predictors{i}) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
%     end
%     
%     %% Magnitude models regressing out visual models
%     measure_args=struct();
%     measure_args.type='Spearman'; %correlation type between target and MEG dsms
%     measure_args.metric='Spearman'; %metric to use to compute MEG dsm % mahalanobis
%     measure_args.center_data=true; %removes the mean pattern before correlating
%     
%     RDM_mag_vis = {'op1_mag', 'op1_vis', 'op2_mag', 'op2_vis', 'result_mag', 'result_vis'};
%     for i = 1:2:length(RDM_mag_vis)
%         disp(['processing RSA of ' [RDM_mag_vis{i} '_reg_' RDM_mag_vis{i+1}]]);
%         measure_args.target_dsm = RDM.(RDM_mag_vis{i});
%         measure_args.regress_dsm = RDM.(RDM_mag_vis{i+1});
%         RSA.([RDM_mag_vis{i} 'reg' RDM_mag_vis{i+1}]) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
%         measure_args = rmfield(measure_args,'regress_dsm');
%     end
%     
%     %% Visual models regressing out magnitude models
%     measure_args=struct();
%     measure_args.type='Spearman'; %correlation type between target and MEG dsms
%     measure_args.metric='Spearman'; %metric to use to compute MEG dsm % mahalanobis
%     measure_args.center_data=true; %removes the mean pattern before correlating
%     
%     for i = 2:2:length(RDM_mag_vis)
%         disp(['processing RSA of ' [RDM_mag_vis{i} '_reg_' RDM_mag_vis{i-1}]]);
%         measure_args.target_dsm = RDM.(RDM_mag_vis{i});
%         measure_args.regress_dsm = RDM.(RDM_mag_vis{i-1});
%         RSA.([RDM_mag_vis{i} 'reg' RDM_mag_vis{i-1}]) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
%         measure_args = rmfield(measure_args,'regress_dsm');
%     end
%     
%     %% Results model regressing out operator
%     measure_args=struct();
%     measure_args.type='Spearman'; %correlation type between target and MEG dsms
%     measure_args.metric='Spearman'; %metric to use to compute MEG dsm % mahalanobis
%     measure_args.center_data=true; %removes the mean pattern before correlating
%     
%     disp('processing RSA of result_reg_operator');
%     measure_args.target_dsm = RDM.result_mag;
%     measure_args.regress_dsm = RDM.operator;
%     RSA.result_mag_reg_operator = cosmo_searchlight(ds,nbrhood,measure,measure_args);
%     measure_args = rmfield(measure_args,'regress_dsm');
%     
    %% Operator model regressing out results magnitude
    measure_args=struct();
    measure_args.type='Spearman'; %correlation type between target and MEG dsms
    measure_args.metric='Spearman'; %metric to use to compute MEG dsm % mahalanobis
    measure_args.center_data=true; %removes the mean pattern before correlating
    
    disp('processing RSA of operator_reg_result_mag');
    measure_args.target_dsm = RDM.operator;
    measure_args.regress_dsm = RDM.result_mag;
    RSA.operator_reg_result_mag = cosmo_searchlight(ds,nbrhood,measure,measure_args);
    measure_args = rmfield(measure_args,'regress_dsm');
    
    %% Save
    save([rsa_result_dir 'RSA_all_DSM_' operation '_tbin' num2str(timesphere) '_' subject '_operator_reg_result.mat'], 'RSA')

%     save([rsa_result_dir 'RSA_all_DSM_' operation '_tbin' num2str(timesphere) '_' subject '.mat'], 'RSA')
end





end


% measure_args = rmfield(measure_args,'regress_dsm');

% 
% %% Visual models jaccart regressing out magnitude models 
% RDM_mag_vis = {'op1_mag', 'op1_vis_jc', 'op2_mag', 'op2_vis_jc', 'result_mag', 'result_vis_jc'};
% for i = 2:2:length(RDM_mag_vis)
%     disp(['processing RSA of ' [RDM_mag_vis{i} '_reg_' RDM_mag_vis{i-1}]]);
%     measure_args.target_dsm = RDM.(RDM_mag_vis{i});
%     measure_args.regress_dsm = RDM.(RDM_mag_vis{i-1});
%     RSA.([RDM_mag_vis{i} '_reg_' RDM_mag_vis{i-1} '_jc'] ) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
%     measure_args = rmfield(measure_args,'regress_dsm');
% end

%%
% measure=@cosmo_target_dsm_corr_measure;
% measure_args=struct();
% measure_args.type='Spearman'; %correlation type between target and MEG dsms
% measure_args.metric='Spearman'; %metric to use to compute MEG dsm
% measure_args.center_data=true; %removes the mean pattern before correlating

% measure=@cosmo_target_dsm_corr_measure;
% measure_args=struct();
% measure_args.type='Spearman'; %correlation type between target and MEG dsms
% measure_args.metric='Spearman'; %metric to use to compute MEG dsm
% measure_args.center_data=true; %removes the mean pattern before correlating

% %% Run RSA
% RSA = [];
% %% Single factor models
% fieldnames_RDM = fieldnames(RDM);
% for i = 1:length(fieldnames_RDM)
%     disp(['processing RSA of ' (fieldnames_RDM{i})]);
%     measure_args.target_dsm = RDM.(fieldnames_RDM{i});
%     RSA.(fieldnames_RDM{i}) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
% end

% %% Single factor models
% fieldnames_RDM = {'op1_vis_jc', 'op2_vis_jc', 'result_vis_jc'};
% for i = 1:length(fieldnames_RDM)
%     disp(['processing RSA of ' (fieldnames_RDM{i})]);
%     measure_args.target_dsm = RDM.(fieldnames_RDM{i});
%     RSA.(fieldnames_RDM{i}) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
% end

% 
% %% Results model regressing out operator 
% disp('processing RSA of result_reg_operator');
% measure_args.target_dsm = RDM.result_mag;
% measure_args.regress_dsm = RDM.operator;
% RSA.result_mag_reg_operator = cosmo_searchlight(ds,nbrhood,measure,measure_args);
% measure_args = rmfield(measure_args,'regress_dsm');
% 
% %% Magnitude models regressing out visual models 
% RDM_mag_vis = {'op1_mag', 'op1_vis', 'op2_mag', 'op2_vis', 'result_mag', 'result_vis'};
% for i = 1:2:length(RDM_mag_vis)
%     disp(['processing RSA of ' [RDM_mag_vis{i} '_reg_' RDM_mag_vis{i+1}]]);
%     measure_args.target_dsm = RDM.(RDM_mag_vis{i});
%     measure_args.regress_dsm = RDM.(RDM_mag_vis{i+1});
%     RSA.([RDM_mag_vis{i} 'reg' RDM_mag_vis{i+1}]) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
%     measure_args = rmfield(measure_args,'regress_dsm');
% end

%% Magnitude models regressing out visual models jaccart
% RDM_mag_vis = {'op1_mag', 'op1_vis_jc', 'op2_mag', 'op2_vis_jc', 'result_mag', 'result_vis_jc'};
% for i = 1:2:length(RDM_mag_vis)
%     disp(['processing RSA of ' [RDM_mag_vis{i} '_reg_' RDM_mag_vis{i+1}]]);
%     measure_args.target_dsm = RDM.(RDM_mag_vis{i});
%     measure_args.regress_dsm = RDM.(RDM_mag_vis{i+1});
%     RSA.([RDM_mag_vis{i} '_reg_' RDM_mag_vis{i+1} '_jc']) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
%     measure_args = rmfield(measure_args,'regress_dsm');
% end

% %% Visual models regressing out magnitude models 
% RDM_mag_vis = {'op1_mag', 'op1_vis', 'op2_mag', 'op2_vis', 'result_mag', 'result_vis'};
% for i = 2:2:length(RDM_mag_vis)
%     disp(['processing RSA of ' [RDM_mag_vis{i} '_reg_' RDM_mag_vis{i-1}]]);
%     measure_args.target_dsm = RDM.(RDM_mag_vis{i});
%     measure_args.regress_dsm = RDM.(RDM_mag_vis{i-1});
%     RSA.([RDM_mag_vis{i} 'reg' RDM_mag_vis{i-1}]) = cosmo_searchlight(ds,nbrhood,measure,measure_args);
%     measure_args = rmfield(measure_args,'regress_dsm');
% end

% %% Results model regressing out operator 
% disp('processing RSA of result_reg_operator');
% measure_args.target_dsm = RDM.result_mag;
% measure_args.regress_dsm = RDM.operator;
% RSA.result_mag_reg_operator = cosmo_searchlight(ds,nbrhood,measure,measure_args);
% measure_args = rmfield(measure_args,'regress_dsm');

% 
% 
% %% Select channels
% [chantypes,~]=cosmo_meeg_chantype(ds);
% % Select MEG planar combined channel
% chan_type_of_interest='meg_axial';
% chan_indices=find(cosmo_match(chantypes, chan_type_of_interest));
% % define channel mask
% chan_msk=cosmo_match(ds.fa.chan,chan_indices);
% % slice the dataset
% ds_chan=cosmo_slice(ds,chan_msk,2);
% ds=cosmo_dim_prune(ds_chan); % to really remove channels
% %%