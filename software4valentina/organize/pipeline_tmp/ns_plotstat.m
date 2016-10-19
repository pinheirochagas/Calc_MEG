function ns_plotstat(stat,av1,av2,lat,tshw)
% function ns_plotstat(stat,av1,av2,lat,tshw)
% Plots a series of topoplots with found clusters highlighted.
%
% Input:
%
% stat is computed for condition 1(2) from FT_TIMELOCKSTATISTICS
% av1(av2) = averaged dataset for condition 1(2) containing the averages
% only
% lat = temporal latency over which statistical analysis is computed (in seconds)
% (example: lat=[0 0.4])
% 
% tshw = time-smoothing half-width, in seconds, determines the half
% temporal window over which topographies are averaged around the latencies
% determined by cfg.lat (choose 0 for no smoothing)
%
% Marco Buiatti, INSERM Cognitive Neuroimaging Unit, Neurospin (2011).
%
% backward compatibility with old sensor label convention
if strcmp(av1.label{1},'0113')
    disp('Old label format: MEG suffix added for layout compatibility.');
    load /neurospin/meg/meg_tmp/tools_tmp/pipeline/SensorClassification.mat
    av1.label = All2;
    av2.label = All2;
end;

sensors={'mag','grad1','grad2'};

for s=1:length(sensors)
    % plot topography of the two conditions and of the difference with clusters
    % superposed, at times specified by cfg.lat (they must be within the time
    % interval used in the statistical analysis
    cfg             = [];
    cfg.layout      = 'neuromag306mag.lay';
    cfg.parameter   = 'avg';
    cfg.lat         = lat; 
    cfg.alpha       = 0.3; % threshold of cluster visualization
    cfg.tshw        = tshw;
    cfg.sensortype  = sensors{s};
    ns_clusterplot(cfg,stat{s},av1,av2)
end;
