function [rejcomp data] = wmp_decomposition(par, data)
% % first check if we are working on continuous data
% if length(data.trial)~=1
%     disp('Warning! This is not continuous file.');
% else
%     disp('Decomposing continuous file...');
% end

% first select

if par.decomposition.epochblink==1
    disp('Building blink trials');
    % remove beginning and end of recording because of subject's movements.
    param = [];
    sti = find(diff(data.STI{1})>0);
    begsample = sti(1)-4000;
    endsample = sti(end)+4000;
    begtime = data.time{1}(begsample);
    endtime = data.time{1}(endsample);
    param.latency = [begtime endtime];
    data_artifact = ft_selectdata_new(param, data);
    
    getartifact                     = [];
    getartifact.dataset             = cat(2,data_artifact.trial{1:end});   % concatenate all trials
    getartifact.Fs                  = 1000;
    getartifact.threshold           = 6; % usually 3
    getartifact.prestim             = 0.8;
    getartifact.poststim            = 0.8;
    getartifact.artefact            = 'EOGv';
    getartifact.sampleinfo          = data_artifact.sampleinfo;
    getartifact.label               = data_artifact.label;
    getartifact.grad                = data_artifact.grad;
    getartifact.trl                 = wmp_build_EOGtrials(getartifact);
    artifact                        = ft_redefinetrial(getartifact, data_artifact);
    artifact.ECGEOG                 =artifact.trial;
    idxEOGECG = [find(strcmp('EOG061', artifact.label)), ...
        find(strcmp('EOG062', artifact.label)), ...
        find(strcmp('ECG063', artifact.label))];
    for tmp=1:length(artifact.ECGEOG)
        artifact.ECGEOG{tmp}=artifact.ECGEOG{tmp}(idxEOGECG,:);
    end
elseif par.decomposition.epochblink==0
    if length(data.trial)==1
        disp('Decomposing on raw data');
        % remove beginning and end of recording because of subject's movements.
        param = [];
        sti = find(diff(data.STI{1})>0);
        begsample = sti(1)-4000;
        endsample = sti(end)+4000;
        begtime = data.time{1}(begsample);
        endtime = data.time{1}(endsample);
        param.latency = [begtime endtime];
        param.channel = {'MEG*', 'EEG*'};
        artifact = ft_selectdata_new(param, data);
        %     artifact = ft_preproc_resample(artifact, par.srate, 250, 'downsample');
        artifact.ECGEOG = data.ECGEOG;
        artifact.STI = data.STI;
        for tmp=1:length(artifact.ECGEOG)
            artifact.ECGEOG{tmp}=artifact.ECGEOG{tmp}(:,begsample:endsample);
            artifact.STI{tmp}=artifact.STI{tmp}(:,begsample:endsample);
        end
    elseif length(data.trial)>1
        disp('Decomposing on epoched data');
        artifact = data;
%         param            = [];
%         param.resamplefs = 250;
%         param.detrend    = 'no';
%         artifact           = ft_resampledata(param, artifact);
%         for cnttrl = 1:length(artifact.ECGEOG)
%             artifact.ECGEOG{cnttrl} = ft_preproc_resample(artifact.ECGEOG{cnttrl}, 1000, 250, 'downsample');
%         end
    end
end

% perform decomposition
load SensorClassification.mat
comp = [];
cfg               = [];
cfg.method        = par.decomposition.method;
cfg.numcomponent  = par.decomposition.comp_num;
channel           = [];
channel{1}        = Grad2_1;
channel{2}        = Grad2_2';
channel{3}        = Mag2;
% channel{4}        = EEG;
tmp=1;
tmp2=1;

for j=1:length(channel)%:-1:1
    cfg.channel     = channel{j};
    switch j
        case 1,
            chantype = 'grad1';
        case 2,
            chantype = 'grad2';
        case 3,
            chantype = 'mag';
        case 4,
            chantype = 'eeg';
    end
    comp{j} = wmp_decomposition_getCorr(par, artifact, channel{j}, par.decomposition.type_artifact, 1);
    title(chantype);
    if j==4; layout='EEG'; else layout='MEG'; end;
    wmp_componentbrowser(comp{j}, layout);
    
    % the original data can be reconstructed, excluding those components
    cfg = [];
    cfg.channel = channel{j};
    data_tmp{j} = ft_selectdata_new(cfg, data);
    
    cfg = [];
    cfg.component = str2num(input(['Index of components to reject for ' chantype ': '], 's'));
    rejcomp.(chantype) = length(cfg.component);   
    data_tmp{j} = ft_rejectcomponent(cfg, comp{j}, data_tmp{j});
end

% Combine the structures in a single structure, respecting the order of the
% sensors prior to decomposition.
j=1;
data.trial=[];
data.label=[];
for j=1:length(data_tmp{1}.trial)
    k=1;
    m=1;
    for k=1:102
        data.trial{j}(m,:)=data_tmp{1}.trial{j}(k,:);
        m=m+1;
        data.trial{j}(m,:)=data_tmp{2}.trial{j}(k,:);
        m=m+1;
        data.trial{j}(m,:)=data_tmp{3}.trial{j}(k,:);
        m=m+1;
    end
%     data.trial{j} = cat(1,data.trial{j}, data_tmp{4}.trial{j});
end

k=1;
m=1;
for k=1:102
    data.label{m}=data_tmp{1}.label{k};
    m=m+1;
    data.label{m}=data_tmp{2}.label{k};
    m=m+1;
    data.label{m}=data_tmp{3}.label{k};
    m=m+1;
end
% data.label = cat(1,data.label', data_tmp{4}.label);
close all
% data.label=data.label';


function wmp_componentbrowser(comp, layout)
load SensorClassification
cfg=[];
if strcmp(layout, 'EEG')
    cfg.layout = 'eeg_64_NM20884N.lay';
%     cfg.layout='easycap64ch-avg_seb.lay';
    comp.topolabel=EEG;
else
    cfg.layout='neuromag306mag.lay';
    comp.topolabel=Mag2;
end
Browser=ft_databrowser(cfg,comp); % Browse components

