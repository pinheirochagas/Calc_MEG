function searchlight_ft_allsub = cosmoSearchLight(sub_name, conds, fq_range, spacesphere, timesphere, freqsphere, nchunks)
%% Function to run a searchlight based LDA on sensors, time and frequency

%% Initialize dirs
InitDirsMEGcalc

%% Get CoSMoMVPA
cd(cosmo_mvpa_dir)
cosmo_set_path()

% %% Searchlight specs
% spacesphere   = 10; % 10 sensors in each sphere
% timesphere    = 2;  % should be 1*2+1=3 time-bin, each is 40 ms
% freqsphere    = 1;  % should be 1*2+1=3 frequency-bin, each is 1 Hz
% nchunks=5;          % for cross-validation

%% Initialize variables
Allsub_samples = [];

%% Loop across subjects
for subi = 1:length(sub_name) % loop across subjects
    tic     
    % Load data
    display(['Loading TFA data of subject ' sub_name{subi}])
    load([tfa_data_dir, sub_name{subi} '_TFA_' fq_range '.mat']);
    
    % Baseline correct in case of high frequencies
    if strcmp(fq_range,'high') == 1
        cfg = [];
        cfg.baseline = [-0.2 -0.02];
        cfg.baselinetype = 'db';
        TFRbaseline = ft_freqbaseline(cfg, TFR);
        TFRbaseline.cumtapcnt = TFR.cumtapcnt;
        TFR = TFRbaseline;
    else
    end
    
    % Define conditions  
    display(['Selecting trials for ' conds])
    [conds_idx, labels] = selecCondsMegCalc(trialinfo, conds);
%     labels = repmat([2 3 4 5],1,5)';
    
    % Filter trials
    TFR.powspctrm = TFR.powspctrm(conds_idx,:,:,:);
    TFR.cumtapcnt = TFR.cumtapcnt(conds_idx,:);

%     TFR.powspctrm = TFR.powspctrm(1:20,:,:,1:3);
%     TFR.time = TFR.time(1:3);
%     TFR.cumtapcnt = TFR.cumtapcnt(1:20,:);
    
    % Convert to cosmomvpa struct
    display('Converting data to cosmo mvpa data structure')
    ds_tf=cosmo_meeg_dataset(TFR);
    
    % Set the target (conditions' labels)
    ds_tf.sa.targets = labels;
    ds_tf.sa = rmfield(ds_tf.sa, 'cumtapcnt');
    
    % set the chunks (independent measurements) = for an meeg dataset, 
    % if each trial can be assumed to be independent, the chunks can be set to
    % (1:N),where N is the number of samples(i.e. N=size(ds.samples,1) for a dataset struct ds
    ds_tf.sa.chunks=(1:size(ds_tf.samples,1))';
    
    % Just to check everything is ok
    cosmo_check_dataset(ds_tf);
    
    % Get rid of features with at least one NaN value across samples
    fa_nan_mask=sum(isnan(ds_tf.samples),1)>0;
    fprintf('%d / %d features have NaN\n', sum(fa_nan_mask), numel(fa_nan_mask));
    ds_tf=cosmo_slice(ds_tf, ~fa_nan_mask, 2);
    fprintf('The input has feature dimensions %s\n', cosmo_strjoin(ds_tf.a.fdim.labels,', '));
            
    % set chunks for crossvalidation, 5 random
    ds_tf.sa.chunks=cosmo_chunkize(ds_tf, nchunks);
    
    % Define channel type
    chan_type='meg_combined_from_planar';
 
    % Define the neighborhood for each dimensions
    display('Define the neighborhood for each dimensions')
    chan_nbrhood=cosmo_meeg_chan_neighborhood(ds_tf, 'count', spacesphere, 'chantype', chan_type);
    freq_nbrhood=cosmo_interval_neighborhood(ds_tf,'freq', 'radius',timesphere);
    time_nbrhood=cosmo_interval_neighborhood(ds_tf,'time', 'radius',freqsphere);

    % Cross neighborhoods for chan-time-freq searchlight
    display('Cross neighborhoods for chan-time-freq searchlight')
    nbrhood=cosmo_cross_neighborhood(ds_tf,{chan_nbrhood, freq_nbrhood, time_nbrhood});                                  
   
    % Print some info
    nbrhood_nfeatures=cellfun(@numel,nbrhood.neighbors);
    fprintf('Features have on average %.1f +/- %.1f neighbors\n', mean(nbrhood_nfeatures), std(nbrhood_nfeatures));
            
    % Only keep features with at least 10 neighbors 
    %(some have zero neighbors - in particular, those with low frequencies early or late in time)
    center_ids=find(nbrhood_nfeatures>10);

    % Measure to be computed  [alternative = cosmo_correlation_measure]
    measure=@cosmo_crossvalidation_measure;

    % When using a classifier, do not use 'half' but the number of chunks to leave out for testing
    measure_args=struct();
    partitions=cosmo_nchoosek_partitioner(ds_tf,1);
    bal_partitions=cosmo_balance_partitions(partitions,ds_tf);   % balance classes
    measure_args.partitions=bal_partitions;

    % Which classifier  [cosmo_classify_lda (fair default option?); 
                        % cosmo_classify_libsvm (= LIBSVM toolbox is required);  
                        % cosmo_classify_matlabsvm (= SVM training did not converge);
                        % cosmo_classify_naive_bayes (takes forever?)]
    measure_args.classifier=@cosmo_classify_lda;

    % Run the searchlight
    display(['Running searchligth on ', conds, ' in subject ', sub_name{subi}, ' using ' fq_range, ...
        ' frequencies and space sphere of ', num2str(spacesphere), ', time bins of ', num2str(timesphere), ...
        ' and frequency bins of ', num2str(freqsphere)])
    %sl_tf_ds=cosmo_searchlight(ds_tf,nbrhood,measure,measure_args, 'center_ids',center_ids,'nproc',2);
    sl_tf_ds=cosmo_searchlight(ds_tf,nbrhood,measure,measure_args, 'center_ids',center_ids);
    display('Done!')   
          
    %% Save
    % Cosmo format
    display(['Saving searchlight results for subject ' sub_name{subi} ' in cosmo format'])   
    save([searchlight_result_dir 'searchlight_cosmo_', conds '_' sub_name{subi}...
        '_lda_ch' num2str(spacesphere) '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere), '_' fq_range '_freq.mat'], 'sl_tf_ds');
       
    % Convert to fieldtrip and save
    display(['Converting and saving searchlight results for subject ' sub_name{subi} ' in fieldtrip format'])   
    all_ft = cosmo_map2meeg(sl_tf_ds);    
    save([searchlight_result_dir 'searchlight_ft_', conds '_' sub_name{subi}...
        '_lda_ch' num2str(spacesphere) '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere), '_' fq_range '_freq.mat'], 'all_ft');
                
    
    %% Store all subjs
    Allsub_samples = [Allsub_samples; sl_tf_ds.samples];
    time_elapsed = toc;
    display(['Searchlight of ' conds ' in subject ' sub_name{subi} ' completed in ' num2str(time_elapsed) ' seconds'])   

   
    %% Clean
    clearvars -EXCEPT subi searchlight_result_dir tfa_data_dir sub_name conds fq_range spacesphere timesphere freqsphere nchunks Allsub_samples sl_tf_ds

end
display(['Searchlight of ' conds ' in all subjects completed!'])   

    
%% Average across subjects 
display('Saving searchlight group results in cosmo format')   
MeanSub = mean(Allsub_samples); % Average samples
searchlight_cosmo_allsub = sl_tf_ds; % Add 
searchlight_cosmo_allsub.samples = MeanSub;
save([searchlight_result_dir 'searchlight_cosmo_allsub_' conds '_lda_ch' num2str(spacesphere)...
    '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere) '_' fq_range '_freq.mat'], 'searchlight_cosmo_allsub');
    
% convert to fieldtrip and save results
display('Saving searchlight group results in fieldtrip format')   
searchlight_ft_allsub = cosmo_map2meeg(searchlight_cosmo_allsub);
save([searchlight_result_dir 'searchlight_ft_allsub_' conds '_lda_ch' num2str(spacesphere)...
    '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere) '_' fq_range '_freq.mat'], 'searchlight_ft_allsub');

end


