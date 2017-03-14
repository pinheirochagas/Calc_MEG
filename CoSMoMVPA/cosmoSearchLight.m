%% Searchlight 

% Searchlight in space(sensors) x time x frequencies


% define channel type of neighbors [from documentation/examples]:
        % 'meg_combined_from_planar' = input are planar channels but the output has combined-planar channels
        % e.g.  get neighbors with radius of .1 for
                % planar neuromag306 channels, but with the center labels
                % the set of combined planar channels
                % (there are 8 channels in the .neighblabel fields, because
                %  there are two planar channels per combined channel)
                    %  nbrhood=cosmo_meeg_chan_neighborhood(ds,...
                    %  'chantype','meg_combined_from_planar','radius',.1);

        % 'meg_axial'   = to use the magnetometers, use 'meg_axial'
        
        % 'meg_planar'  = ?
        % e.g.
               % get neighbors at 4 neighboring sensor location for
               % planar neuromag306 channels:
                   % nbrhood=cosmo_meeg_chan_neighborhood(ds,...
                   % 'chantype','meg_planar','count',4);

        % 'eeg'
        % 'all'                      = use all channel types associated with lab
        
        % 'all_combined'             = use 'meg_combined_from_planar' with all other channel types in ds except for 'meg_planar'.
        % e.g.  Here the axial channels only have axial neighbors, and the planar
                % channels only have planar neighbors. With 7 timepoints and 10
                % neighboring channels, the meg_axial channels all have 70 axial
                % neighbors while the meg_planar_combined channels all have
                % 140 neighbors based on the planar channel pairs in the original dataset
                    %  nbrhood=cosmo_meeg_chan_neighborhood(ds,...
                    %  'chantype','all_combined','count',10);


%% set up

% need cosmo
cd /volatile/CoSMoMVPA-master/mvpa
cosmo_set_path
% set configuration
config=cosmo_config();
% need fieldtrip
addpath '/neurospin/meg/meg_tmp/Semdim_Valentina_2014/software4valentina/fieldtrip_latest' 
ft_defaults  
cd /neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/results_TFA/COSMO/Results
clc;

%% searchlight for each subject

data_path     = '/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/cosmo_searchligth/';
subnips       = {'S01','S02','S03','S04','S05','S06','S07','S08','S13','S14','S15','S16','S17','S18','S19'};
contrast      = 'sound';   % 'cat', 'sound', 'video'
spacesphere   = 10; % 10 sensors in each sphere
timesphere    = 1;  % should be 1*2+1=3 time-bin, each is 40 ms
freqsphere    = 1;  % should be 1*2+1=3 frequency-bin, each is 1 Hz

Allsub_samples = [];

%% Loop across subjects
for subi = 1 : length(subnips) % loop across subjects
        
    % Load data
    data_fn=fullfile(data_path,['Data/' subnips{subi} '_' contrast '_low.mat']);
    data_tf=load(data_fn);
    
    % Select conditions
    
    % Run time-frequency analysis
    
    % convert to cosmomvpa struct
    ds_tf=cosmo_meeg_dataset(data_tf.TFAallcond);
    
    % set the target (conditions' labels)
    ds_tf.sa.targets=ds_tf.sa.trialinfo(:,1); 

    % set the chunks (independent measurements) = for an meeg dataset, 
    % if each trial can be assumed to be independent, the chunks can be set to
    % (1:N),where N is the number of samples(i.e. N=size(ds.samples,1) for a dataset struct ds
    ds_tf.sa.chunks=(1:size(ds_tf.samples,1))';
    
    % just to check everything is ok
    cosmo_check_dataset(ds_tf);
    
    % get rid of features with at least one NaN value across samples
    fa_nan_mask=sum(isnan(ds_tf.samples),1)>0;
    fprintf('%d / %d features have NaN\n', ...
            sum(fa_nan_mask), numel(fa_nan_mask));
    ds_tf=cosmo_slice(ds_tf, ~fa_nan_mask, 2);

    fprintf('The input has feature dimensions %s\n', ...
                cosmo_strjoin(ds_tf.a.fdim.labels,', '));
            
    % set chunks for crossvalidation, 5 random
    nchunks=5;
    ds_tf.sa.chunks=cosmo_chunkize(ds_tf, nchunks);
    
    
   
    chan_type='meg_combined_from_planar';
    
    % how many sensors
    chan_count= spacesphere;
    % how many time bins  
    time_radius=timesphere;
    % how many frequency bins  
    freq_radius=freqsphere;

    % define the neighborhood for each dimensions
    chan_nbrhood=cosmo_meeg_chan_neighborhood(ds_tf, 'count', chan_count, ...
                                                    'chantype', chan_type);
    freq_nbrhood=cosmo_interval_neighborhood(ds_tf,'freq',...
                                                'radius',freq_radius);
    time_nbrhood=cosmo_interval_neighborhood(ds_tf,'time',...
                                                'radius',time_radius);


    % cross neighborhoods for chan-time-freq searchlight
    nbrhood=cosmo_cross_neighborhood(ds_tf,{chan_nbrhood,...
                                            freq_nbrhood,...
                                            time_nbrhood});
                                        
    % print some info
    nbrhood_nfeatures=cellfun(@numel,nbrhood.neighbors);
    fprintf('Features have on average %.1f +/- %.1f neighbors\n', ...
                mean(nbrhood_nfeatures), std(nbrhood_nfeatures));
            
    % only keep features with at least 10 neighbors 
    %(some have zero neighbors - in particular, those with low frequencies early or late in time)
    center_ids=find(nbrhood_nfeatures>10);

    % measure to be computed  [alternative = cosmo_correlation_measure]
    measure=@cosmo_crossvalidation_measure;

    % when using a classifier, do not use 'half' but the number of chunks to leave out for testing
    measure_args=struct();
    partitions=cosmo_nchoosek_partitioner(ds_tf,1);
    bal_partitions=cosmo_balance_partitions(partitions,ds_tf);   % balance classes
    measure_args.partitions=bal_partitions;

    % which classifier  [cosmo_classify_lda (fair default option?); 
                        % cosmo_classify_libsvm (= LIBSVM toolbox is required);  
                        % cosmo_classify_matlabsvm (= SVM training did not converge);
                        % cosmo_classify_naive_bayes (takes forever?)]
    measure_args.classifier=@cosmo_classify_lda;

    % run the searchlight and save results
    sl_tf_ds=cosmo_searchlight(ds_tf,nbrhood,measure,measure_args,...
                               'center_ids',center_ids,'nproc',2);
                           
    save([data_path 'searchlight_addsub_s15.mat'], 'sl_tf_ds');
    
    
%     save([data_path '/Results/' contrast '_' subnips{subi} '_lda_ch' num2str(spacesphere)...
%         '_tbin' num2str(timesphere) '_frbin' num2str(freq_radius) '.mat'], 'sl_tf_ds');
    
    % convert to fieldtrip and save results
    all_ft=cosmo_map2meeg(sl_tf_ds);    
    
    
    save([data_path, 'searchlight_addsub_s15_ft.mat'], 'all_ft');

    
%     save([data_path '/Results/FT_' contrast '_' subnips{subi} '_lda_ch' num2str(spacesphere)...
%         '_tbin' num2str(timesphere) '_frbin' num2str(freq_radius) '.mat'], 'all_ft');    
    
    % store all subjs
    Allsub_samples = [Allsub_samples; sl_tf_ds.samples];
    
    clearvars -EXCEPT data_path subnips  contrast  spacesphere  timesphere  freqsphere  Allsub_samples  subi 
    
end

    
%% average across subjects 

Allsub_samples = [];
for subi = 1 : length(subnips) % loop across subjects
    load(['/neurospin/meg/meg_tmp/Semdim_Valentina_2014/data/results_TFA/COSMO/Results/sound_' subnips{subi} '_lda_ch10_tbin1_frbin1.mat'])
    Allsub_samples = [Allsub_samples; sl_tf_ds.samples];
end

MeanSub = mean(Allsub_samples);
tmp = sl_tf_ds;
tmp.samples = MeanSub;
save([data_path '/Results/Average_' contrast '_lda_ch' num2str(spacesphere)...
    '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere) '.mat'], 'tmp');
    
% convert to fieldtrip and save results
tmp2=cosmo_map2meeg(tmp);
save([data_path '/Results/FT_Average_' contrast '_lda_ch' num2str(spacesphere)...
    '_tbin' num2str(timesphere) '_frbin' num2str(freqsphere) '.mat'], 'tmp2');
