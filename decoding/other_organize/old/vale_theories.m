%  n_trials x n_channels x ntimesample

%%  Embodied

% ==================================== Visual
nsamples    = 100;
nchans      = 306;
ntrials     = 100;
X           = zeros(ntrials,nchans,nsamples);
y           = [ones(ntrials/2,1); 2*ones(ntrials/2,1)];
%-- add differential information (i.e. chain of processing) 
for t = 35:50
    for chan = 1:10:nchans
        X(y==1,chan,t) = randn;
        X(y==2,chan,t) = randn;
    end
end
%-- add common information 
for chan = 1:10:nchans
    X(y==1,chan,35:45) = randn;
    X(y==2,chan,35:60) = randn;
end
%-- add gaussian noise
X = X + 3*randn(size(X));
cfg         = [];
cfg.n_folds = 5; % number of folds
cfg.C       = 1;  % SVM criterion 
cfg.dims_tg = 0; % generalize across all time points
results         = jr_classify(X,y,cfg);         % decode across sensors at each time point
output          = squeeze(results.probas(1,:,:,:,1));
results.auc     = colAUC(output, results.y);
figure(1)
imagesc(results.auc,[0 1]);
xlabel('test time (ms.)');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
ylabel('train time (ms.)');
set(gca,'YTick',0:10:100);
set(gca,'YTickLabel',[-200:100:801]);
colorbar;
set(gca,'ydir','normal');
axis square
set(gca,'ydir','normal');
figure(11)
plot(diag(results.auc));
xlabel('time (ms.)');
ylabel('AUC');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
axis square
grid on

% ==================================== Audio
nsamples    = 100;
nchans      = 306;
ntrials     = 100;
X           = zeros(ntrials,nchans,nsamples);
y           = [ones(ntrials/2,1); 2*ones(ntrials/2,1)];
%-- add differential information (i.e. chain of processing) 
for t = 40:55
    for chan = 1:10:nchans
        X(y==1,chan,t) = randn;
        X(y==2,chan,t) = randn;
    end
end
%-- add common information 
for chan = 1:10:nchans
    X(y==1,chan,40:50) = randn;
    X(y==2,chan,40:65) = randn;
end
%-- add gaussian noise
X = X + 3*randn(size(X));
cfg         = [];
cfg.n_folds = 5; % number of folds
cfg.C       = 1;  % SVM criterion 
cfg.dims_tg = 0; % generalize across all time points
results         = jr_classify(X,y,cfg);         % decode across sensors at each time point
output          = squeeze(results.probas(1,:,:,:,1));
results.auc     = colAUC(output, results.y);
figure(1)
imagesc(results.auc,[0 1]);
xlabel('test time (ms.)');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
ylabel('train time (ms.)');
set(gca,'YTick',0:10:100);
set(gca,'YTickLabel',[-200:100:801]);
colorbar;
set(gca,'ydir','normal');
axis square
set(gca,'ydir','normal');
figure(11)
plot(diag(results.auc));
xlabel('time (ms.)');
ylabel('AUC');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
axis square
grid on

% ==================================== SemCluster
nsamples    = 100;
nchans      = 306;
ntrials     = 100;
X           = zeros(ntrials,nchans,nsamples);
y           = [ones(ntrials/2,1); 2*ones(ntrials/2,1)];
%-- add differential information (i.e. chain of processing) 
for t = 60:90
    for chan = 1:10:nchans
        X(y==1,chan,t) = randn;
        X(y==2,chan,t) = randn;
    end
end
%-- add common information 
for chan = 1:10:nchans
    X(y==1,chan,60:90) = randn;
    X(y==2,chan,45:90) = randn;
end
%-- add gaussian noise
X = X + 3*randn(size(X));
cfg         = [];
cfg.n_folds = 5; % number of folds
cfg.C       = 1;  % SVM criterion 
cfg.dims_tg = 0; % generalize across all time points
results         = jr_classify(X,y,cfg);         % decode across sensors at each time point
output          = squeeze(results.probas(1,:,:,:,1));
results.auc     = colAUC(output, results.y);
figure(1)
imagesc(results.auc,[0 1]);
xlabel('test time (ms.)');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
ylabel('train time (ms.)');
set(gca,'YTick',0:10:100);
set(gca,'YTickLabel',[-200:100:801]);
colorbar;
set(gca,'ydir','normal');
axis square
set(gca,'ydir','normal');
figure(11)
plot(diag(results.auc));
xlabel('time (ms.)');
ylabel('AUC');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
axis square
grid on

%% ABSTRACT

% ==================================== SemCluster
nsamples    = 100;
nchans      = 306;
ntrials     = 100;
X           = zeros(ntrials,nchans,nsamples);
y           = [ones(ntrials/2,1); 2*ones(ntrials/2,1)];
%-- add differential information (i.e. chain of processing) 
for t = 35:90
    for chan = 1:10:nchans
        X(y==1,chan,t) = randn;
        X(y==2,chan,t) = randn;
    end
end
%-- add common information 
for chan = 1:10:nchans
    X(y==1,chan,35:45) = randn;
    X(y==2,chan,35:90) = randn;
end
%-- add gaussian noise
X = X + 3*randn(size(X));
cfg         = [];
cfg.n_folds = 5; % number of folds
cfg.C       = 1;  % SVM criterion 
cfg.dims_tg = 0; % generalize across all time points
results         = jr_classify(X,y,cfg);         % decode across sensors at each time point
output          = squeeze(results.probas(1,:,:,:,1));
results.auc     = colAUC(output, results.y);
figure(1)
imagesc(results.auc,[0 1]);
xlabel('test time (ms.)');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
ylabel('train time (ms.)');
set(gca,'YTick',0:10:100);
set(gca,'YTickLabel',[-200:100:801]);
colorbar;
set(gca,'ydir','normal');
axis square
set(gca,'ydir','normal');
figure(11)
plot(diag(results.auc));
xlabel('time (ms.)');
ylabel('AUC');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
axis square
grid on

% ==================================== Visual
nsamples    = 100;
nchans      = 306;
ntrials     = 100;
X           = zeros(ntrials,nchans,nsamples);
y           = [ones(ntrials/2,1); 2*ones(ntrials/2,1)];
%-- add differential information (i.e. chain of processing) 
for t = 65:80
    for chan = 1:10:nchans
        X(y==1,chan,t) = randn;
        X(y==2,chan,t) = randn;
    end
end
%-- add common information 
for chan = 1:10:nchans
    X(y==1,chan,60:80) = randn;
    X(y==2,chan,70:80) = randn;
end
%-- add gaussian noise
X = X + 3*randn(size(X));
cfg         = [];
cfg.n_folds = 5; % number of folds
cfg.C       = 1;  % SVM criterion 
cfg.dims_tg = 0; % generalize across all time points
results         = jr_classify(X,y,cfg);         % decode across sensors at each time point
output          = squeeze(results.probas(1,:,:,:,1));
results.auc     = colAUC(output, results.y);
figure(1)
imagesc(results.auc,[0 1]);
xlabel('test time (ms.)');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
ylabel('train time (ms.)');
set(gca,'YTick',0:10:100);
set(gca,'YTickLabel',[-200:100:801]);
colorbar;
set(gca,'ydir','normal');
axis square
set(gca,'ydir','normal');
figure(11)
plot(diag(results.auc));
xlabel('time (ms.)');
ylabel('AUC');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
axis square
grid on

% ==================================== Audio
nsamples    = 100;
nchans      = 306;
ntrials     = 100;
X           = zeros(ntrials,nchans,nsamples);
y           = [ones(ntrials/2,1); 2*ones(ntrials/2,1)];
%-- add differential information (i.e. chain of processing) 
for t = 75:90
    for chan = 1:10:nchans
        X(y==1,chan,t) = randn;
        X(y==2,chan,t) = randn;
    end
end
%-- add common information 
for chan = 1:10:nchans
    X(y==1,chan,70:90) = randn;
    X(y==2,chan,80:90) = randn;
end
%-- add gaussian noise
X = X + 3*randn(size(X));
cfg         = [];
cfg.n_folds = 5; % number of folds
cfg.C       = 1;  % SVM criterion 
cfg.dims_tg = 0; % generalize across all time points
results         = jr_classify(X,y,cfg);         % decode across sensors at each time point
output          = squeeze(results.probas(1,:,:,:,1));
results.auc     = colAUC(output, results.y);
figure(1)
imagesc(results.auc,[0 1]);
xlabel('test time (ms.)');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
ylabel('train time (ms.)');
set(gca,'YTick',0:10:100);
set(gca,'YTickLabel',[-200:100:801]);
colorbar;
set(gca,'ydir','normal');
axis square
set(gca,'ydir','normal');
figure(11)
plot(diag(results.auc));
xlabel('time (ms.)');
ylabel('AUC');
set(gca,'XTick',0:10:100);
set(gca,'XTickLabel',[-200:100:801]);
axis square
grid on
