function data_ds=bn_resample(data)

for c=1:length(data)
cfg=[]; 
cfg.resamplefs=250; 
cfg.detrend='no';
data_ds{c} = ft_resampledata(cfg, data{c});
end;