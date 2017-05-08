
% Directory
datadir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/bst2ft_data-todelete_downsampled/';
dataRes = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/decoding/'

% Subjects, 
subj = {'s01', 's02'}; 

% Prelocate the size of the epochs
all_auc = zeros(851,851,length(subj));

for s=1:1%length(subj)  % loop across subjects

    % loading
       load([datadir subj{s} '/data'],'data_add')
       load([datadir subj{s} '/data'],'data_sub')
    
    Cond1 = data_add.trial;
    Cond2 = data_sub.trial;
    
    % set parameters
    cfg         = [];
    cfg.wsize   = 3;                      % each sliding window's size in time samples
    cfg.n_folds = 5;                      % number of cross-validation folds
    cfg.C       = 1;                      % SVM regularization parameter 
    cfg.dims_tg  = 0 ;                    % generalization time,  0 to generalize across all time points
    cfg.namey = 'AddSub';                 % classification names for outputs
    cfg.path = [dataRes subj{s} '/'];   % classification path for output
    % create this folder in advance
    
    % get X and y
    X = [Cond1; Cond2];
    y = [ones(size(Cond1(:,1,1)));2*ones(size(Cond2(:,1,1)))];    % vector indicating trial classes (aka labels, aka conditions)
    % run analysis
    tic
    results = jr_classify(X,y,cfg);  
    toc
    % compute area under the curve
    probas1 = squeeze(results.probas(1,:,:,:,1));
    results.auc = colAUC(probas1, results.y);
   
    save([dataRes subj{s} '/' 'AddSub' subj{s} '.mat'], 'results');
    % plot area under the curve (diagonal)
    figure(4242)
    plot(diag(results.auc)); 
    set(gca,'XTick',0:25:251)
    set(gca,'XTickLabel',[-200:100:801])
    % plot generalization matrix (all)
    figure(424242)
    imagesc(results.auc,[0 1]);
    xlabel('generalize');
    set(gca,'XTick',0:25:251)
    set(gca,'XTickLabel',[-200:100:801])
    ylabel('train');
    set(gca,'YTick',0:25.1:251)
    set(gca,'YTickLabel',[-200:100:801])
    colorbar;
    set(gca,'ydir','normal');
    print(figure(4242),'-dtiff', ['LeftVsright_' num2str(subj(s)) '_DiagDecoding.tiff'])
    print(figure(424242),'-dtiff', ['LeftVsright_' num2str(subj(s)) '_TimeGenMat.tiff'])
    
    all_auc(:,:,s) = results.auc;
    
end;  % ends loop across subjects 

% plot mean generalization matrix 
mean_auc = mean(all_auc,3);
figure(24)
imagesc(mean_auc,[0 1]);
xlabel('generalize');
set(gca,'XTick',0:25:251)
set(gca,'XTickLabel',[-200:100:801])
ylabel('train');
set(gca,'YTick',0:25.1:251)
set(gca,'YTickLabel',[-200:100:801])
colorbar;
set(gca,'ydir','normal');
figure(2424)
plot(diag(mean_auc)); 