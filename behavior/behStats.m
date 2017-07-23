function [group, ind] = behStats(beh_data)

deviant = unique(beh_data{1}(:,9));
for i = 1:length(beh_data)
    for ii = 1:length(deviant)
        RT = beh_data{i}(:,10);
        avg_deviant{i}(ii,1) = nanmean(RT(beh_data{i}(:,9) == deviant(ii)));
    end    
end
avg_deviant_cat = horzcat(avg_deviant{:});
mean_deviant = mean(avg_deviant_cat,2);
sem_deviant = sem(avg_deviant_cat,2);

[p,tbl,stats] = anova1(avg_deviant_cat', [], 'off');
group.p = p;
group.tbl = tbl;
group.stats = stats;

% Indivisual analysis
for i = 1:length(beh_data)
    deviant_comb = nan(160,5);
    for ii = 1:length(deviant)
        RT = beh_data{i}(:,10);
        RT_filter = RT(beh_data{i}(:,9) == deviant(ii));
        deviant_comb(1:length(RT_filter), ii) = RT_filter;
        [p_i(i),tbl_i{i},stats_i{i}] = anova1(deviant_comb, [], 'off');
    end    
end
ind.p = p_i;
ind.tbl = tbl_i;
ind.stats = stats_i;

end

