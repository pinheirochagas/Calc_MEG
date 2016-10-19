function ns_multitopoplotERdiff(ave1,ave2,tlim,tshw,zmax)
% function multi_topoplotER(data,tlim,zmax) plots topography of the three
% sensor types separately for a selection of time intervals 
% Input:
% davg = averaged data from ns_ave, format from ft_timelockanalysis
% tlim = time intervals within which ERFs are averaged. 
% Example: tlim = [0:0.1:0.3] for time intervals [0 0.1], [0.1 0.2] and [0.2 0.3] (in seconds);
% zmax = absolute amplitude limit (one for each sensor type (in order: mag,grad1,grad2)
%
% Marco Buiatti, 2011-2015.

sensors={'mag','grad1','grad2'};

cfg = [];
cfg.layout = 'neuromag306mag.lay';
cfg.marker='off';
cfg.parameter   = 'avg';
nframes=length(tlim);

ave1.dimord='chan_time';
ave2.dimord='chan_time';

for s=1:3
    switch s
        case 1
            ave1loc = ft_selectdata(ave1,'channel',ave1.typelabel.Mag2);
            ave2loc = ft_selectdata(ave2,'channel',ave1.typelabel.Mag2);
        case 2
            ave1loc = ft_selectdata(ave1,'channel',ave1.typelabel.Grad2_1);
            ave2loc = ft_selectdata(ave2,'channel',ave1.typelabel.Grad2_1);
        case 3
            ave1loc = ft_selectdata(ave1,'channel',ave1.typelabel.Grad2_2);
            ave2loc = ft_selectdata(ave2,'channel',ave1.typelabel.Grad2_2);
    end;
    ave1loc.label=ave1.typelabel.Mag2;
    ave2loc.label=ave1.typelabel.Mag2;
    avediff=ave1loc;
    avediff.avg=ave1loc.avg-ave2loc.avg;
    
    % define amplitude range
    if isempty(zmax)
        srate=round(1/(ave1.time(2)-ave1.time(1)));
        ind_tlim=round(ns_lat2point([tlim(1)-tshw tlim(end)+tshw],1,srate,[ave1.time(1) ave1.time(end)],1));
        ave1locz=ave1loc.avg(:,ind_tlim(1):ind_tlim(end));
        ave2locz=ave2loc.avg(:,ind_tlim(1):ind_tlim(end));
        maxlim=max(max(abs(ave1locz(:))),max(abs(ave2locz(:))));
    else maxlim=zmax(s);
    end
    
    
    figure
    for j=1:nframes
        cfg.zlim=[-maxlim maxlim];
        cfg.xlim=[tlim(j)-tshw tlim(j)+tshw];
        subplot(3,nframes,j)
        cfg.comment = strcat(num2str(cfg.xlim(1)),'-',num2str(cfg.xlim(2)), ' s');
        cfg.commentpos = 'title';
        ft_topoplotER(cfg, ave1loc);
        subplot(3,nframes,nframes+j)
        cfg.comment='no';
        ft_topoplotER(cfg, ave2loc);
        subplot(3,nframes,2*nframes+j)
        cfg.zlim=0.5*[-maxlim maxlim];
        ft_topoplotER(cfg, avediff);
    end;
    disp(['Sensor: ' sensors{s} '. 1st (2nd) line: condition 1(2). 3rd line: condition 1 - condition 2.']);
    disp(['Amplitude range: ' num2str(-maxlim) ' - ' num2str(maxlim)]);
end;