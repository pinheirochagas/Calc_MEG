function ns_multitopoplotER(ave,tlim,tshw,zmax)
% function multi_topoplotER(ave,tlim,tshw,zmax) plots topography of the three
% sensor types separately for a selection of temporal windows
% Input:
% ave = averaged data from ns_ave, format from ft_timelockanalysis
% tlim = center of temporal windows within which ERFs are averaged. 
% tshw = half-width of the temporal window (set to zero for topography at single time bin) 
% Example: tlim = [0.05:0.05:0.3] and tshw = 0.025 -> temporal windows: [0.025 0.075], [0.075 0.125],...,[0.275 0.325] (in seconds);
% zmax = absolute amplitude limit (one for each sensor type, in order:
% mag,grad1,grad2). Leave empty for 'maxmin'.
%
% Marco Buiatti, 2011-2015.

sensors={'mag','grad1','grad2'};

cfg = [];
% choose magnetometer layout, as it is the same for all three sensor types
cfg.layout = 'neuromag306mag.lay';
% do not show markers to make figures clearer
cfg.marker='off';
cfg.parameter   = 'avg';
nframes=length(tlim);

ave.dimord='chan_time';

figure
for s=1:3
    % select sensor type (labels in SensorClassification.mat)
    switch s
        case 1
            aveloc = ft_selectdata(ave,'channel',ave.typelabel.Mag2);
        case 2
            aveloc = ft_selectdata(ave,'channel',ave.typelabel.Grad2_1);
        case 3
            aveloc = ft_selectdata(ave,'channel',ave.typelabel.Grad2_2);
    end;
    
    aveloc.label=ave.typelabel.Mag2;
    
    % define amplitude range
    if isempty(zmax)
        srate=round(1/(ave.time(2)-ave.time(1)));
        ind_tlim=round(ns_lat2point([tlim(1)-tshw tlim(end)+tshw],1,srate,[ave.time(1) ave.time(end)],1));
        avelocz=aveloc.avg(:,ind_tlim(1):ind_tlim(end));
        maxlim=max(abs(avelocz(:)));
    else maxlim=zmax(s);
    end
    cfg.zlim=[-maxlim maxlim];
    
    for j=1:nframes
        cfg.xlim=[tlim(j)-tshw tlim(j)+tshw];
        subplot(3,nframes,j+nframes*(s-1))
        if s==1
            cfg.comment = strcat(num2str(cfg.xlim(1)),'-',num2str(cfg.xlim(2)), ' s');
            cfg.commentpos = 'title';
        else
            cfg.comment='no';
        end;
        ft_topoplotER(cfg, aveloc);
    end;
    disp(['Line ' num2str(s) ': Sensor: ' sensors{s}]);
    disp(['Amplitude range: ' num2str(-maxlim) ' - ' num2str(maxlim)]);
end;