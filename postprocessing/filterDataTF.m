function data = filterDataTF(data, conds)
%%
% Get the indices
conds_idx = selecCondsMegCalc(data.trialinfo, conds);
data.powspctrm = data.powspctrm(conds_idx,:,:,:);
data.trialinfo = structfun(@(x) x(conds_idx), data.trialinfo, 'UniformOutput', false);
end