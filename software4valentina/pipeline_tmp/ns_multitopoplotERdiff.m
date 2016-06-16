function ns_multitopoplotERdiff(ave1,ave2,tlim,tshw,zmax)
% function multi_topoplotER(data,tlim,zmax) plots topography of the three
% sensor types separately for a selection of time intervals 
% Input:
% davg = averaged data from ns_ave, format from ft_timelockanalysis
% tlim = time intervals within which ERFs are averaged. 
% Example: tlim = [0:0.1:0.3] for time intervals [0 0.1], [0.1 0.2] and [0.2 0.3] (in seconds);
% zmax = absolute amplitude limit (one for each sensor type (in order: mag,grad1,grad2)
%
% Marco Buiatti, INSERM U992 Cognitive Neuroimaging Unit (France), 2011.

load /neurospin/meg/meg_tmp/tools_tmp/Pipeline/pipeline/SensorClassification.mat
sensors={'mag','grad1','grad2'};

% backward compatibility with old sensor label convention
if strcmp(ave1.label{1},'0113')
    disp('Old label format: MEG suffix added for layout compatibility.');
    ave1.label = All2';
    ave2.label = All2';
end;


cfg = [];
cfg.layout = 'neuromag306mag.lay';
cfg.marker='off';
cfg.parameter   = 'avg';
nframes=length(tlim);

for s=1:3
    switch s
        case 1
            ave1loc = ft_selectdata(ave1,'channel',Mag2);
            ave2loc = ft_selectdata(ave2,'channel',Mag2);
        case 2
            ave1loc = ft_selectdata(ave1,'channel',Grad2_1);
            ave2loc = ft_selectdata(ave2,'channel',Grad2_1);
        case 3
            ave1loc = ft_selectdata(ave1,'channel',Grad2_2);
            ave2loc = ft_selectdata(ave2,'channel',Grad2_2);
    end;
    ave1loc.label=Mag2;
    ave2loc.label=Mag2;
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
    cfg.zlim=[-maxlim maxlim];
    
    figure
    for j=1:nframes
        cfg.xlim=[tlim(j)-tshw tlim(j)+tshw];
        subplot(3,nframes,j)
        cfg.comment = strcat(num2str(cfg.xlim(1)),'-',num2str(cfg.xlim(2)), ' s');
        cfg.commentpos = 'title';
        ft_topoplotER(cfg, ave1loc);
        subplot(3,nframes,nframes+j)
        cfg.comment='no';
        ft_topoplotER(cfg, ave2loc);
        subplot(3,nframes,2*nframes+j)
        ft_topoplotER(cfg, avediff);
    end;
    disp(['Sensor: ' sensors{s} '. 1st (2nd) line: condition 1(2). 3rd line: condition 1 - condition 2.']);
    disp(['Amplitude range: ' num2str(-maxlim) ' - ' num2str(maxlim)]);
end;