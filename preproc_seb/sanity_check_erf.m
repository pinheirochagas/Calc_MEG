

B1 = cell2mat(arrayfun(@(t)permute(t{:},[3 1 2]),data2,'UniformOutput',false));
B2= permute(B1,[2 1 3]);

B2 = data3.trial=permute(data2,[3 1 2]);



permute(data2,[3 1 2])

data2 = data.trial(data.trialinfo.operator == 1)
data.time(data.trialinfo.operator == 1)


data_left_click.grad


addpath(genpath('/neurospin/meg/meg_tmp/WMP_Ojeda_2013/fieldtrip/'))
rmpath(genpath('/neurospin/meg/meg_tmp/WMP_Ojeda_2013/fieldtrip/'))

rmpath(genpath('/neurospin/unicog/protocols/intracranial/fieldtrip'))


%% Average , save original and average
addpath('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/preproc_seb/')
load('SensorClassification.mat')
cfg             = [];
data.Avg     = ft_timelockanalysis(cfg, data);
data.par = par;



cfg.parameter = 'avg';
cfg.layout = 'neuromag306all.lay';
cfg.channel = 'all';
cfg.ylim = [-9.44e-12 8.08e-12];

ft_multiplotER(cfg, data)



cfg = [];
cfg.trials    = find(data.trialinfo.respSide == -1);
data_left     = ft_redefinetrial(cfg, data);
 
cfg.trials    = find(data.trialinfo.respSide == 1);
data_right    = ft_redefinetrial(cfg, data);
%%
tlk = ft_timelockanalysis([],data_right);
tlkl = ft_timelockanalysis([],data_left);

%%
cfg = []; 
cfg.fontsize = 6; 
cfg.layout = 'neuromag306mag.lay';
cfg.xlim = [0 0.650]; 
figure;
subplot(2,2,1);ft_topoplotER(cfg, tlk);
 subplot(2,2,2);ft_topoplotER(cfg, tlkl);

cfg.channel = {'MEG0431'}
cfg.xlim    = [-.2 1];
subplot(2,2,2);ft_singleplotER(cfg,tlk);

