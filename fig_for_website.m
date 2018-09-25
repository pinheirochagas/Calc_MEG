AddPathsMEGcalc
InitDirsMEGcalc


data_all = reshape(data.trial)



data_trials = permute(cell2mat(arrayfun(@(x)permute(x{:},[1 3 2]),data.trial,'UniformOutput',false)), [2 1 3]);


data_trials_avg = squeeze(mean(data_trials,1));

plot(data_trials_avg', 'Color', 'k')



sub_name_all = {'s03','s04','s05','s06','s07','s08','s09','s10','s11','s12','s13','s14','s15','s16','s17','s18','s19','s21','s22'};

%% Check individual subjects data
data_trials_all = [];
for i = 1:length(sub_name_all)
    disp(['loading subject ' sub_name_all{i}])
    load([data_dir sub_name_all{i} '_vsa.mat'])
    data_trials = permute(cell2mat(arrayfun(@(x)permute(x{:},[1 3 2]),data.trial,'UniformOutput',false)), [2 1 3]);
    data_trials_all(i,:,:) = squeeze(mean(data_trials,1));
end

data_trials_all_avg = squeeze(mean(data_trials_all,1));
data_trials_all_avg = data_trials_all_avg([1:3:306 2:3:306],:);
plot(data_trials_all_avg(1:100,:)', 'Color', 'k')
save2pdf('figwebsite.pdf',gcf, 600) 