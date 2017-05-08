%% decoding example using the scikit learn pipeline for Stan
cd('/media/DATA/Pro/Projects/Paris/Other/stan/example_gentime');
clear;

%% 1. Install scikit learn toolbox
% add Neuro-debian repesitory
% go to http://neuro.debian.net/
% > How to use this repository => select a release
% > inter terminal:
%       paste provided command (wget ...)
%       sudo apt-get update
%       sudo apt-get install python-sklearn

%% 1. quick examples
X               = randn(50,20,100);           % matrix of 200 trials by 300 channels by 100 time points)
y               = [ones(25,1);2*ones(25,1)];  % vector indicating trial class (i.e. labels)
X(y==1,:,50:100)= X(y==1,:,50:100) + .3;         % add information at time t=[5 10]
results         = jr_classify(X,y);         % decode across sensors at each time point
%results         = jr_classify_stats(results);   % summarize results within AUC
output          = squeeze(results.probas(1,:,:,1,1));

% this probas variable is the key output in most analyses: it corresponds
% to the predicted probability of each trial of being in each class at each
% training and testing time: 
% n_splits x n_trials x n_trainingTime x n_testingTime x n_classes
% 
% in the case of a traditional sliding window approach you thus only get
% 1 x n_trials x n_times x 1 x n_classes

results.auc     = colAUC(output, results.y);    % non parametric non-paired test
plot(squeeze(results.auc));                     % plot area under the curve

%% 2. Use larger sliding window
cfg = [];
cfg.wsize       = 10;                           % each sliding window's size is 10 time samples
results         = jr_classify(X,y,cfg);         % decode across sensors at each time point
output          = squeeze(results.probas(1,:,:,1,1));
results.auc     = colAUC(output, results.y);
plot(squeeze(results.auc));                     % plot area under the curve


%% 3. generalization across time
nsamples    = 50;
nchans      = 256;
ntrials     = 50;
% matrix of data
X           = zeros(ntrials,nchans,nsamples);
% /!\ matlab automatically squeezes matrices when the last dimension has
% only one column. At the moment, it is therefore necessary to have at
% least 2 time point / 2 datavector to be classified

% vector of class: (i.e. labels)
%    y==0: trials that will not be taken into account. 
%    y>0: trials that will be used in a traditional decoding method
%    y<0: trials that will be used in a generalization procedure (decode
%    pattern with y>0 and see whether this pattern generalizes to another
%    conditions).
y = [ones(ntrials/2,1); 2*ones(ntrials/2,1)];

%-- add differential information between t = [30 50] (i.e. chain of
%processing) on a fourth of the channels
for t = 10:20
    for chan = 1:4:nchans
        X(y==1,chan,t) = randn;
        X(y==2,chan,t) = randn;
    end
end
%-- add common information between t = [100:130] on a fourth of the channels
for chan = 1:4:nchans
    X(y==1,chan,20:50) = randn;
    X(y==2,chan,20:50) = randn;
end


%-- add gaussian noise
X = X + 3*randn(size(X));

cfg         = [];
cfg.n_folds = 10; % number of folds
cfg.fs      = .50; % percentage of feature selection
cfg.C       = 1;  % SVM criterion 
cfg.dims_tg = 0; % generalize across all time points
results         = jr_classify(X,y,cfg);         % decode across sensors at each time point
% now you want all train and testing time, which thus leads you to a larger
% output
output          = squeeze(results.probas(1,:,:,:,1));
results.auc     = colAUC(output, results.y);

imagesc(results.auc,[0 1]);
xlabel('generalize');ylabel('train');colorbar;
set(gca,'ydir','normal');

%% 4. you can selectively train at specific time points and generalize to all
% others like this
cfg.dims        = (2:4:50)'; % training time
cfg.dims_tg     = repmat(10:50,length(cfg.dims),1);% generalization time
results         = jr_classify(X,y,cfg);         % decode across sensors at each time point
output          = squeeze(results.probas(1,:,:,:,1));
results.auc     = colAUC(output, results.y);

imagesc(results.auc,[0 1]);
xlabel('generalize');ylabel('train');colorbar;
set(gca,'ydir','normal');


%% 5. generalize across categories
ntime = 100;
ntrial = 100;
nchan = 20;
X               = randn(ntrial,nchan,ntime);           % matrix of 200 trials by 300 channels by 100 time points)
y               = reshape(repmat(1:4,ntrials/4,1),1,[]); % vector indicating trial class (i.e. labels)
X(y==1 | y==3,:,50:100)= X(y==1 | y==3,:,50:100) + 1;     % add information at time t=[5 10]

classes = y;
classes(classes==3) = -1; % negative integers are used as prediction only, but not training categories
classes(classes==4) = -2; 

cfg = [];
cfg.save_allg = false; % each generalized trials is predicted n_fold time. You can keep all predictions, or just average them.
results         = jr_classify(X,classes);         % decode across sensors at each time point

% the genralized trials are in probasg:
clf;
subplot(2,1,1);hold on;
plot_eb(1:ntime,squeeze(results.probas(:,results.y==1,:,:,1)),[0 1 0]);
plot_eb(1:ntime,squeeze(results.probas(:,results.y==2,:,:,1)),[1 0 0]);
ylabel('predicted P(y==1)');xlabel('time');title('decoding')
subplot(2,1,2);hold on;
plot_eb(1:ntime,squeeze(results.probasg(:,results.yg==-1,:,:,1)),[0 1 .5]);
plot_eb(1:ntime,squeeze(results.probasg(:,results.yg==-2,:,:,1)),[1 0 .5]);
ylabel('predicted P(y==1)');xlabel('time');title('generalization')

%% Other stuff:
% - to gain time: 
%       + play with cfg.fs (feature selection), 
%       + only use half of the  channels and time points, 
%       + don't estimate probabilities (cfg.compute_probas=false, 
%           cfg.compute_predict = true or cfg.compute_distance = true)
% - for pipelines, you can save your data once on the hard drive, and 
%   only use pointers. I can do an example if you need this
% - if you have nested categories (e.g. face (male & female) versus house
%   (large and small), you can use cfg.y2 as an index of all categories that
%   the script will try to equally distribute across folds
% - to use regression, classification etc... ask me

%% good luck!
% JR

