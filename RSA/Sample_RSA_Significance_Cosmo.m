%% Sample code for Significance Tessting for RSA in Cosmo
% Lina Teichmann
% May 2017
%**************************************************************************
% Add CosmoMVPA to path & clear variables before running
%**************************************************************************



ds_stacked_RSA = cosmo_stack(RSA_all);
nparticipants = size(ds_stacked_RSA.samples,1);


%% RSA: significance testing - monte-carlo-cluster corrected for multiple comparisons
ds_stacked_RSA.sa.targets = ones(nparticipants,1);
ds_stacked_RSA.sa.chunks=(1:nparticipants)';

neighborhood = cosmo_cluster_neighborhood(ds_stacked_RSA); 
opt = struct();
opt.niter = 10000;
opt.h0_mean=0;
opt.null=[];

tfce_ds = cosmo_montecarlo_cluster_stat(ds_stacked_RSA,neighborhood,opt);
significant_timepoints_RSA_Sample_Magnitude=tfce_ds.samples>1.6449; % one-tailed: we are only interested what is above chance. 
timevect=ds_stacked_RSA.a.fdim.values{1};


%% Plot results
colormap('lines')
colours = colormap;
f=figure(2);clf;
set(f,'Position',[100,10,695,430],'PaperPositionMode','auto')
f.Resize='off';

% chance
plot(ds_stacked_RSA.a.fdim.values{1},mean(ds_stacked_RSA.samples)*0,'k--')
ylim([-0.2 0.2]);
hold on
% result
o=shadedErrorBar(timevect,mean(ds_stacked_RSA.samples),std(ds_stacked_RSA.samples)/sqrt(nparticipants));hold on
o.mainLine.Color = colours(5,:);
o.patch.FaceColor = colours(5,:);
o.patch.FaceAlpha = 0.15;
o.edge(1).Color = colours(5,:);
o.edge(2).Color = colours(5,:);

plot(timevect(significant_timepoints_RSA_Sample_Magnitude),0*timevect(significant_timepoints_RSA_Sample_Magnitude)-0.130,'.','MarkerSize',3,'Color', o.mainLine.Color)

