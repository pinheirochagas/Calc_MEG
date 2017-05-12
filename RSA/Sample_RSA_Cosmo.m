%% Sample code for RSA in Cosmo
% Lina Teichmann
% May 2017
%**************************************************************************
% Add CosmoMVPA to path & clear variables before running
%**************************************************************************


nparticipants = 2;
for p = 1:nparticipants
    % load data
    T = readtable('NumericalFormat_MEG_3.txt','Delimiter','\t'); %behavioural
    load('2247_TG_Cosmofile.mat'); %MEG
    
    % only keep trials where no response was required
    trialstokeep=find(T.Var18==0);
    ds = cosmo_slice(ds,trialstokeep);
    
    % run PCA
    ds2=ds;
    ds2.samples=[];
    ds2.fa.time=[];
    ds2.fa.chan=[];
    fprintf('Computing pca')
    for t=1:length(ds.a.fdim.values{2})
        fprintf('.')
        maskidx = ds.fa.time==t;
        dat = ds.samples(:,maskidx);
        [~,datpca,~,~,explained] = pca(dat);
        datretain = datpca(:,cumsum(explained)<=99);
        ds2.samples = cat(2,ds2.samples,datretain);
        ds2.fa.time = [ds2.fa.time t*ones(1,size(datretain,2))];
        ds2.fa.chan = [ds2.fa.chan 1:size(datretain,2)];
    end
    fprintf('Done\n')
    ds=ds2;
    
    
    % Slice dataset according to format, location and magnitude  - this is
    % saved in ds.sa
    ds=cosmo_average_samples(ds, 'repeats',1, 'split_by', {'format','location','magnitude'});
    
    %sanity check
    cosmo_check_dataset(ds);
    fprintf('Dataset input:\n');
    cosmo_disp(ds);
    
    ds.sa.targets = (1:length(ds.sa.magnitude))'; % treats each trial as one 'condition'
    ds.sa.chunks = (1:length(ds.sa.magnitude))'; % treats each trial as being independent
    nbrhood=cosmo_interval_neighborhood(ds,'time','radius',1); % to calculate the correlations it looks at each timepoint separately
    
    
    %% Run Magnitude Model
    % set measure
    b = [0:5;1 0 1 2 3 4;2 1 0 1 2 3;3 2 1 0 1 2; 4 3 2 1 0 1; 5 4 3 2 1 0];
    target_dsm = repmat(b,8,8);
    
    measure=@cosmo_target_dsm_corr_measure;
    measure_args=struct();
    measure_args.target_dsm=target_dsm;
    
    
    measure_args.type='Spearman'; %correlation type between target and MEG dsms
    measure_args.metric='Spearman'; %metric to use to compute MEG dsm
    measure_args.center_data=true; %removes the mean pattern before correlating
    
    % run searchlight
    ds_rsm_binary=cosmo_searchlight(ds,nbrhood,measure,measure_args);
    
    save(['RSA_Sample_P',num2str(p)],'ds_rsm_binary');
    
end