function ns_erf(sensors,varargin)
% function ns_erf(sensors,varargin)
% Plots ERF time courses at each sensor position in topographical representation using ft_multiplotER. 
% See help ft_multiplotER for more options.
% Input:
% sensors = 'all' for all sensors, 'mag' for magnetometers, 'grad' for gradiometers, 'grad1'('grad2') for gradiometers 1(2).
% varargin = averaged data from ns_ave using ft_timelockanalysis. Multiple
% datasets can be plotted simultaneously.
% 1st dataset is plotted in blue, 2nd in red, 3rd in green
%
% Example: ns_erf('grad',av1,av2);

% backward compatibility with old sensor label convention
if strcmp(varargin{1}.label{1},'0113')
    disp('Old label format: MEG suffix added for layout compatibility.');
    load /neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline/SensorClassification.mat
    for i=1:length(varargin)
        varargin{i}.label = All2;
    end;
end;
    
figure
cfg = [];
% cfg.showlabels = 'yes'; 
cfg.fontsize = 8; 
cfg.interactive = 'yes';
% cfg.graphcolor = 'rygbgyr';
switch lower(sensors)
    case{'all'}
        cfg.layout = 'neuromag306all.lay';
    case{'mag'}
        cfg.layout = 'neuromag306mag.lay';
    case{'grad'}
        cfg.layout = 'neuromag306planar.lay';
    case{'grad1'}
        cfg.layout = 'neuromag306all.lay';
        load /neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline/SensorClassification.mat
        for i=1:length(varargin)
            varargin{i} = ft_selectdata(varargin{i},'channel',Grad2_1);
        end;
    case{'grad2'}
        cfg.layout = 'neuromag306all.lay';
        load /neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline/SensorClassification.mat
        for i=1:length(varargin)
            varargin{i} = ft_selectdata(varargin{i},'channel',Grad2_2);
        end;
    case{'eeg'}
        cfg.layout = '/neurospin/meg/meg_tmp/MaskingErrorNoTP_Lucie_2010/GRAPH_FIELDTRIP_ANALYSIS/NMeeg_Standard.lay';
    otherwise
        error([sensors ' is an unknown sensor type. Options are: all, mag, grad.'])
end
ft_multiplotER(cfg, varargin{:});
