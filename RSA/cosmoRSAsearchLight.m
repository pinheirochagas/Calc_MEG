function cosmoRSAsearchLight(subject, ds, fq_range, spacesphere, timesphere, freqsphere)

% InitDirsMEGcalc
InitDirsMEGcalc

% %% Searchlight specs
% spacesphere   = 10; % 10 sensors in each sphere
% timesphere    = 2;  % should be 1*2+1=3 time-bin, each is 40 ms
% freqsphere    = 1;  % should be 1*2+1=3 frequency-bin, each is 1 Hz

%% AVG data given the condition
ds=cosmo_average_samples(ds, 'repeats',1, 'split_by', {'stim'});

%% sanity check
cosmo_check_dataset(ds);
fprintf('Dataset input:\n');
cosmo_disp(ds);

%% Define targets and chunks
ds.sa.targets = (1:length(ds.sa.stim))'; % treats each trial as one 'condition'
ds.sa.chunks = (1:length(ds.sa.stim))'; % treats each trial as being independent

%% Define searchlight
chan_type='meg_combined_from_planar';
freq_nbrhood=cosmo_interval_neighborhood(ds,'freq', 'radius',timesphere);
time_nbrhood=cosmo_interval_neighborhood(ds,'time', 'radius',freqsphere);

if isstr(spacesphere) == 1
    nbrhood=cosmo_cross_neighborhood(ds,{freq_nbrhood, time_nbrhood});
%     % Select channels of interest
%     [chantypes,~]=cosmo_meeg_chantype(ds);
%     % Select MEG planar combined channel
%     chan_type_of_interest='meg_planar';
%     chan_indices=find(cosmo_match(chantypes, chan_type_of_interest));
%     % define channel mask
%     chan_msk=cosmo_match(ds.fa.chan,chan_indices);
%     % slice the dataset
%     ds_chan=cosmo_slice(ds,chan_msk,2);
%     ds=cosmo_dim_prune(ds_chan); % to really remove channels
else
    chan_nbrhood=cosmo_meeg_chan_neighborhood(ds, 'count', spacesphere, 'chantype', chan_type);
    nbrhood=cosmo_cross_neighborhood(ds,{chan_nbrhood, freq_nbrhood, time_nbrhood});
end


%% Print some info
nbrhood_nfeatures=cellfun(@numel,nbrhood.neighbors);
% fprintf('Features have on average %.1f +/- %.1f neighbors\n', mean(nbrhood_nfeatures), std(nbrhood_nfeatures));

%% Only keep features with at least 10 neighbors
%(some have zero neighbors - in particular, those with low frequencies early or late in time)
center_ids=find(nbrhood_nfeatures>10);

%% Load matrices and define predictors
load([rsa_result_dir 'stim_matrices/calc_RDM_matrices.mat'])
predictors = {'operator', 'op1_mag', 'op1_vis', 'op2_mag', 'op2_vis', 'result_mag', 'result_vis'};

%% Define measures and argumnts
measure=@cosmo_target_dsm_corr_measure;
measure_args=struct();
measure_args.type='Spearman'; %correlation type between target and MEG dsms
measure_args.metric='Spearman'; %metric to use to compute MEG dsm % mahalanobis
measure_args.center_data=true; %removes the mean pattern before correlating

measure_args.glm_dsm = {RDM.(predictors{1}), RDM.(predictors{2}), RDM.(predictors{3}), RDM.(predictors{4}), RDM.(predictors{5}), RDM.(predictors{6}), RDM.(predictors{7})} ;

%% Run searchlight
tic
display(['Running RSA searchlight in subject ' subject])   
RSA.result_reg_everything = cosmo_searchlight(ds,nbrhood,measure,measure_args,'center_ids',center_ids);
RSA.predictors = predictors;
time_elapsed = toc;
display(['RSA searchlight in subject ' subject ' completed in ' num2str(time_elapsed) ' seconds'])   

%% Save
save([rsa_result_dir subject '_RSA_searchlight_all_DSM' '_ch' num2str(spacesphere)...
    '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere) '_' fq_range '_freq_spearman.mat'], 'RSA');

end
