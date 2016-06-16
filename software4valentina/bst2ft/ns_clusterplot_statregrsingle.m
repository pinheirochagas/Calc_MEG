function ns_clusterplot_statregrsingle(cfg,stat,data1,data2,data3,data4,sensortype)
% function sd_clusterplot_statregr(cfg,stat,data1,data2,data3,data4) plots a series of topoplots from averaged data from condition 1 (first row, data1), 
% condition 2 (second row, data2), and the difference (third row,
% data1-data2) with significant statistical clusters highlighted, at
% latencies specified by cfg.lat and averaged over intervals specified by
% cfg.tshw. BE AWARE that highlighted clusters include ALL channels of that
% cluster in the specified time interval.
%
% ns_clusterplot is adapted to NS from the fieldtrip function FT_CLUSTERPLOT
% (help below).
% INPUT:
% cfg = parameter configuration. You need to specify the following fields:
% cfg.layout = plotting layout (typically 'neuromag306mag.lay')
% cfg.parameter = field of data to plot (typically 'avg')
% cfg.alpha = threshold of cluster visualization
% cfg.tshw = time-smoothing half-width, in seconds, determines the half
% temporal window over which topographies are averaged around the latencies
% determined by cfg.lat (choose 0 for no smoothing)
% cfg.lat = latency of topoplot series. Be careful!: latency and
% time-smoothing half-width must be chosen within stat.time extremes!
% cfg.sensortype  = MEG sensor type. Options are 'mag' (magnetometers),'grad1' (first set of gradiometers), 'grad2' (second set of gradiometers)('mag','grad1','grad2')
% cfg.zlim = amplitude limits. If not specified, cfg.zlim = max of the absolute
% value across all the time range.
% See FT_CLUSTERPLOT help below for further options
% stat = statistics structure from ft_timelockstatistics. See FT_CLUSTERPLOT help below
% data1(data2) = the averaged data from ft_timelockanalysis or
% ft_timelockgrandaverage from which stat has been computed.
%
% Example:
% cfg             = [];
% cfg.layout      = 'neuromag306mag.lay';
% cfg.parameter   = 'avg';
% cfg.lat         = [0.05:0.05:0.3];
% cfg.alpha       = 0.3; % threshold of cluster visualization
% cfg.tshw        = 0.02;
% cfg.sensortype  = 'mag';
% ns_clusterplot(cfg,stat,av1,av2)
%
% Marco Buiatti, INSERM Cognitive Neuroimaging Unit, Neurospin (2011).

%% Defining initial parameters for NS data %%

% select sensor type and labels
load('C:\Users\mbuiatti\Documents\FromOmega\software\pipeline_tmp\SensorClassification.mat');

cfg.sensortype=sensortype;
switch cfg.sensortype
    case 'mag'
        data1 = ft_selectdata(data1,'channel',Mag2);
        data2 = ft_selectdata(data2,'channel',Mag2);
        data3 = ft_selectdata(data3,'channel',Mag2);
        data4 = ft_selectdata(data4,'channel',Mag2);
        if length(stat)>1
            stat=stat{1};
        end;
    case 'grad1'
        data1 = ft_selectdata(data1,'channel',Grad2_1);
        data2 = ft_selectdata(data2,'channel',Grad2_1);
        data3 = ft_selectdata(data3,'channel',Grad2_1);
        data4 = ft_selectdata(data4,'channel',Grad2_1);
        if length(stat)>1
            stat=stat{2};
        end;
    case 'grad2'
        data1 = ft_selectdata(data1,'channel',Grad2_2);
        data2 = ft_selectdata(data2,'channel',Grad2_2);
        data3 = ft_selectdata(data3,'channel',Grad2_2);
        data4 = ft_selectdata(data4,'channel',Grad2_2);
        if length(stat)>1
            stat=stat{3};
        end;
    otherwise
        disp('Error: Incorrect channel selection!');
end;
% re-label channels for compatibility with layout
data1.label=Mag2;
data2.label=Mag2;
data3.label=Mag2;
data4.label=Mag2;

% generate data difference dataset
% data1b=ft_selectdata(data1,'toilim',[stat.time(1) stat.time(end)]);
% data4b=ft_selectdata(data4,'toilim',[stat.time(1) stat.time(end)]);

datadiff=ft_selectdata(data1,'toilim',[stat.time(1) stat.time(end)]);
ampldiff=1; % factor of multiplication for amplitude scale of erp difference relative to single erps.
datadiff.avg=stat.stat;
% datadiff.avg=data4b.avg-data1b.avg;

% define time window
srate=round(1/(data1.time(2)-data1.time(1)));
tshwp=round(cfg.tshw*srate);
ind_timewin=round(ns_lat2point(cfg.lat,1,srate,[stat.time(1) stat.time(end)],1));
timewin = stat.time(ind_timewin);
nframes = length(timewin);

% define amplitude range
if ~isfield(cfg, 'zlim')
    ind_timewin_data=round(ns_lat2point([cfg.lat(1) cfg.lat(end)],1,srate,[data1.time(1) data1.time(end)],1));
    data1loc=data1.avg(:,ind_timewin_data(1):ind_timewin_data(end));
    data2loc=data2.avg(:,ind_timewin_data(1):ind_timewin_data(end));
    data3loc=data3.avg(:,ind_timewin_data(1):ind_timewin_data(end));
    data4loc=data4.avg(:,ind_timewin_data(1):ind_timewin_data(end));
    maxlim=max(abs([data1loc(:); data2loc(:); data3loc(:); data4loc(:)]));
    maxlimstat=max(abs(stat.stat(:)));
%     maxlim=2*max(abs([data1loc(:); data2loc(:); data3loc(:); data4loc(:)]));
    cfg.zlim=[-maxlim maxlim];
end;

% After this point, the program uses the structure of ft_clusterplot,
% version 2011-11-02, so its help is posted here (but be aware that the
% program has been radically modified):

% FT_CLUSTERPLOT plots a series of topoplots with found clusters highlighted.
% stat is 2D or 1D data from FT_TIMELOCKSTATISTICS or FT_FREQSTATISTICS with 'cluster'
% as cfg.correctmc. 2D: stat from FT_TIMELOCKSTATISTICS not averaged over
% time, or stat from FT_FREQSTATISTICS averaged over frequency not averaged over
% time. 1D: averaged over time as well.
%
% Use as
%   ft_clusterplot(cfg,stat)
%
% Where the configuration options can be
%   cfg.alpha                     = number, highest cluster p-value to be plotted
%                                   max 0.3 (default = 0.05)
%   cfg.highlightseries           = 1x5 cell-array, highlight option series ('on','labels','numbers')
%                                   default {'on','on','on','on','on'} for p < [0.01 0.05 0.1 0.2 0.3]
%   cfg.highlightsymbolseries     = 1x5 vector, highlight marker symbol series
%                                   default ['*','x','+','o','.'] for p < [0.01 0.05 0.1 0.2 0.3]
%   cfg.highlightsizeseries       = 1x5 vector, highlight marker size series
%                                   default [6 6 6 6 6] for p < [0.01 0.05 0.1 0.2 0.3]
cfg.highlightsizeseries = [10 10 10 10 10];
%   cfg.highlightcolorpos         = color of highlight marker for positive clusters
%                                   default = [0 0 0]
%   cfg.highlightcolorneg         = color of highlight marker for negative clusters
%                                   default = [0 0 0]
%   cfg.saveaspng                 = string, filename of the output figures (default = 'no')
%
% It is also possible to specify other cfg options that apply to FT_TOPOPLOTTFR.
% You CANNOT specify cfg.xlim, any of the FT_TOPOPLOTTFR highlight
% options, cfg.comment and cfg.commentpos.
%
% To facilitate data-handling and distributed computing with the peer-to-peer
% module, this function has the following option:
%   cfg.inputfile   =  ...
% If you specify this option the input data will be read from a *.mat
% file on disk. This mat files should contain only a single variable named 'data',
% corresponding to the input structure.
%
% See also:
%   FT_TOPOPLOTTFR, FT_TOPOPLOTER, FT_SINGLEPLOTER

% Copyright (C) 2007, Ingrid Nieuwenhuis, F.C. Donders Centre
%
% This file is part of FieldTrip, see http://www.ru.nl/neuroimaging/fieldtrip
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%
% $Id: ft_clusterplot.m 4658 2011-11-02 19:49:23Z roboos $

revision = '$Id: ft_clusterplot.m 4658 2011-11-02 19:49:23Z roboos $';

% do the general setup of the function
ft_defaults
ft_preamble help
ft_preamble callinfo
ft_preamble trackconfig
ft_preamble loadvar stat

% check if the given data is appropriate
if isfield(stat,'freq') && length(stat.freq) > 1
    error('stat contains multiple frequencies which is not allowed because it should be averaged over frequencies')
end

% check if the input cfg is valid for this function
cfg = ft_checkconfig(cfg, 'renamed',     {'hlmarkerseries',       'highlightsymbolseries'});
cfg = ft_checkconfig(cfg, 'renamed',     {'hlmarkersizeseries',   'highlightsizeseries'});
cfg = ft_checkconfig(cfg, 'renamed',     {'hlcolorpos',           'highlightcolorpos'});
cfg = ft_checkconfig(cfg, 'renamed',     {'hlcolorneg',           'highlightcolorneg'});
cfg = ft_checkconfig(cfg, 'deprecated',  {'hllinewidthseries'});
cfg = ft_checkconfig(cfg, 'renamed',     {'zparam', 'parameter'});
cfg = ft_checkconfig(cfg, 'deprecated',  {'xparam', 'yparam'});

% added several forbidden options
cfg = ft_checkconfig(cfg, 'forbidden',  {'highlight'});
cfg = ft_checkconfig(cfg, 'forbidden',  {'highlightchannel'});
cfg = ft_checkconfig(cfg, 'forbidden',  {'highlightsymbol'});
cfg = ft_checkconfig(cfg, 'forbidden',  {'highlightcolor'});
cfg = ft_checkconfig(cfg, 'forbidden',  {'highlightsize'});
cfg = ft_checkconfig(cfg, 'forbidden',  {'highlightfontsize'});
cfg = ft_checkconfig(cfg, 'forbidden',  {'xlim'});
cfg = ft_checkconfig(cfg, 'forbidden',  {'comment'});
cfg = ft_checkconfig(cfg, 'forbidden',  {'commentpos'});

% set the defaults
if ~isfield(cfg,'alpha'),                  cfg.alpha = 0.05;                                    end;
if ~isfield(cfg,'highlightseries'),        cfg.highlightseries = {'on','on','on','on','on'};    end;
if ~isfield(cfg,'highlightsymbolseries'),  cfg.highlightsymbolseries = ['*','x','+','o','.'];   end;
if ~isfield(cfg,'highlightsizeseries'),    cfg.highlightsizeseries = [6 6 6 6 6];               end;
if ~isfield(cfg,'hllinewidthseries'),      cfg.hllinewidthseries = [1 1 1 1 1];                 end;
if ~isfield(cfg,'highlightcolorpos'),      cfg.highlightcolorpos = [0 0 0];                     end;
if ~isfield(cfg,'highlightcolorneg'),      cfg.highlightcolorneg = [0 0 0];                     end;
if ~isfield(cfg,'parameter'),              cfg.parameter = 'parameter';                         end;
if ~isfield(cfg,'saveaspng'),              cfg.saveaspng = 'no';                                end;

% error if cfg.highlightseries is not a cell, for possible confusion with cfg-options
if ~iscell(cfg.highlightseries)
    error('cfg.highlightseries should be a cell-array of strings')
end

% set additional options for topoplotting
if isfield(cfg, 'marker'),                cfgtopo.marker         = cfg.marker ;         end
if ~isfield(cfg,'marker'),                cfgtopo.marker         = 'off';               end
if isfield(cfg, 'markersymbol'),          cfgtopo.markersymbol   = cfg.markersymbol;    end
if isfield(cfg, 'markercolor'),           cfgtopo.markercolor    = cfg.markercolor;     end
if isfield(cfg, 'markersize'),            cfgtopo.markersize     = cfg.markersize;      end
if isfield(cfg, 'markerfontsize'),        cfgtopo.markerfontsize = cfg.markerfontsize;  end
if isfield(cfg, 'style'),                 cfgtopo.style          = cfg.style ;          end
if isfield(cfg, 'gridscale'),             cfgtopo.gridscale      = cfg.gridscale;       end
if isfield(cfg, 'interplimits'),          cfgtopo.interplimits   = cfg.interplimits;    end
if isfield(cfg, 'interpolation'),         cfgtopo.interpolation  = cfg.interpolation;   end
if isfield(cfg, 'contournum'),            cfgtopo.contournum     = cfg.contournum;      end
if isfield(cfg, 'colorbar'),              cfgtopo.colorbar       = cfg.colorbar;        end
if isfield(cfg, 'shading'),               cfgtopo.shading        = cfg.shading';        end
if isfield(cfg, 'zlim'),                  cfgtopo.zlim           = cfg.zlim;            end

cfgtopo.parameter = cfg.parameter;

% prepare the layout, this only has to be done once
cfgtopo.layout = ft_prepare_layout(cfg, stat);

% find significant clusters
sigpos = [];
signeg = [];
haspos = isfield(stat,'posclusters');
hasneg = isfield(stat,'negclusters');

if haspos == 0 && hasneg == 0
    fprintf('%s\n','no significant clusters in data, plotting data without clusters.')
    % make plots without any cluster
    figure;
    for frame=1:nframes
        cfgtopo.xlim = [stat.time(ind_timewin(frame)-tshwp) stat.time(ind_timewin(frame)+tshwp)];
        cfgtopo.highlightchannel = [];
        cfgtopo.comment = strcat(num2str(stat.time(ind_timewin(frame)-tshwp)),' - ',num2str(stat.time(ind_timewin(frame)+tshwp)), ' s');
        cfgtopo.commentpos = 'title';
%         subplot(5,nframes,frame);
%         ft_topoplotTFR(cfgtopo, data1);
        cfgtopo.comment='no';
        cfgtopo.highlightchannel = [];
        ft_topoplotTFR(cfgtopo, datadiff);
    end
else
    if haspos
        for iPos = 1:length(stat.posclusters)
            sigpos(iPos) = stat.posclusters(iPos).prob < cfg.alpha;
        end
    end
    if hasneg
        for iNeg = 1:length(stat.negclusters)
            signeg(iNeg) = stat.negclusters(iNeg).prob < cfg.alpha;
        end
    end
    sigpos = find(sigpos == 1);
    signeg = find(signeg == 1);
    Nsigpos = length(sigpos);
    Nsigneg = length(signeg);
    Nsigall = Nsigpos + Nsigneg;
    
    if Nsigall == 0
        fprintf('%s\n','no clusters present with a p-value lower than the specified alpha, plotting data without clusters.')
        % make plots without any cluster
        figure;
        for frame=1:nframes
            cfgtopo.xlim = [stat.time(ind_timewin(frame)-tshwp) stat.time(ind_timewin(frame)+tshwp)];
            cfgtopo.highlightchannel = [];
            cfgtopo.comment = strcat(num2str(stat.time(ind_timewin(frame)-tshwp)),' - ',num2str(stat.time(ind_timewin(frame)+tshwp)), ' s');
            cfgtopo.commentpos = 'title';
            cfgtopo.comment='no';
            cfgtopo.highlightchannel = [];
            ft_topoplotTFR(cfgtopo, datadiff);
        end
        
    else
        
        % make clusterslabel matrix per significant cluster
        posCLM = squeeze(stat.posclusterslabelmat);
        sigposCLM = zeros(size(posCLM));
        probpos = [];
        for iPos = 1:length(sigpos)
            sigposCLM(:,:,iPos) = (posCLM == sigpos(iPos));
            probpos(iPos) = stat.posclusters(iPos).prob;
            hlsignpos(iPos) = prob2hlsign(probpos(iPos), cfg.highlightsymbolseries);
        end
        
        negCLM = squeeze(stat.negclusterslabelmat);
        signegCLM = zeros(size(negCLM));
        probneg = [];
        for iNeg = 1:length(signeg)
            signegCLM(:,:,iNeg) = (negCLM == signeg(iNeg));
            probneg(iNeg) = stat.negclusters(iNeg).prob;
            hlsignneg(iNeg) = prob2hlsign(probneg(iNeg), cfg.highlightsymbolseries);
        end
        
        fprintf('%s%i%s%g%s\n','There are ',Nsigall,' clusters smaller than alpha (',cfg.alpha,')')
        
        % setup highlight options for all clusters and make comment for 1D data
        compos = [];
        comneg = [];
        for iPos = 1:length(sigpos)
            if stat.posclusters(sigpos(iPos)).prob < 0.01
                cfgtopo.highlight{iPos}         = cfg.highlightseries{1};
                cfgtopo.highlightsymbol{iPos}   = cfg.highlightsymbolseries(1);
                cfgtopo.highlightsize{iPos}     = cfg.highlightsizeseries(1);
            elseif stat.posclusters(sigpos(iPos)).prob < 0.05
                cfgtopo.highlight{iPos}         = cfg.highlightseries{2};
                cfgtopo.highlightsymbol{iPos}   = cfg.highlightsymbolseries(2);
                cfgtopo.highlightsize{iPos}     = cfg.highlightsizeseries(2);
            elseif stat.posclusters(sigpos(iPos)).prob < 0.1
                cfgtopo.highlight{iPos}         = cfg.highlightseries{3};
                cfgtopo.highlightsymbol{iPos}   = cfg.highlightsymbolseries(3);
                cfgtopo.highlightsize{iPos}     = cfg.highlightsizeseries(3);
            elseif stat.posclusters(sigpos(iPos)).prob < 0.2
                cfgtopo.highlight{iPos}         = cfg.highlightseries{4};
                cfgtopo.highlightsymbol{iPos}   = cfg.highlightsymbolseries(4);
                cfgtopo.highlightsize{iPos}     = cfg.highlightsizeseries(4);
            elseif stat.posclusters(sigpos(iPos)).prob < 0.3
                cfgtopo.highlight{iPos}         = cfg.highlightseries{5};
                cfgtopo.highlightsymbol{iPos}   = cfg.highlightsymbolseries(5);
                cfgtopo.highlightsize{iPos}     = cfg.highlightsizeseries(5);
            end
            cfgtopo.highlightcolor{iPos}        = cfg.highlightcolorpos;
            compos = strcat(compos,cfgtopo.highlightsymbol{iPos}, 'p=',num2str(probpos(iPos)),' '); % make comment, only used for 1D data
        end
        
        for iNeg = 1:length(signeg)
            if stat.negclusters(signeg(iNeg)).prob < 0.01
                cfgtopo.highlight{length(sigpos)+iNeg}         = cfg.highlightseries{1};
                cfgtopo.highlightsymbol{length(sigpos)+iNeg}   = cfg.highlightsymbolseries(1);
                cfgtopo.highlightsize{length(sigpos)+iNeg}     = cfg.highlightsizeseries(1);
            elseif stat.negclusters(signeg(iNeg)).prob < 0.05
                cfgtopo.highlight{length(sigpos)+iNeg}         = cfg.highlightseries{2};
                cfgtopo.highlightsymbol{length(sigpos)+iNeg}   = cfg.highlightsymbolseries(2);
                cfgtopo.highlightsize{length(sigpos)+iNeg}     = cfg.highlightsizeseries(2);
            elseif stat.negclusters(signeg(iNeg)).prob < 0.1
                cfgtopo.highlight{length(sigpos)+iNeg}         = cfg.highlightseries{3};
                cfgtopo.highlightsymbol{length(sigpos)+iNeg}   = cfg.highlightsymbolseries(3);
                cfgtopo.highlightsize{length(sigpos)+iNeg}     = cfg.highlightsizeseries(3);
            elseif stat.negclusters(signeg(iNeg)).prob < 0.2
                cfgtopo.highlight{length(sigpos)+iNeg}         = cfg.highlightseries{4};
                cfgtopo.highlightsymbol{length(sigpos)+iNeg}   = cfg.highlightsymbolseries(4);
                cfgtopo.highlightsize{length(sigpos)+iNeg}     = cfg.highlightsizeseries(4);
            elseif stat.negclusters(signeg(iNeg)).prob < 0.3
                cfgtopo.highlight{length(sigpos)+iNeg}         = cfg.highlightseries{5};
                cfgtopo.highlightsymbol{length(sigpos)+iNeg}   = cfg.highlightsymbolseries(5);
                cfgtopo.highlightsize{length(sigpos)+iNeg}     = cfg.highlightsizeseries(5);
            end
            cfgtopo.highlightcolor{length(sigpos)+iNeg}        = cfg.highlightcolorneg;
            comneg = strcat(comneg,cfgtopo.highlightsymbol{length(sigpos)+iNeg}, 'p=',num2str(probneg(iNeg)),' '); % make comment, only used for 1D data
        end
        
        % put channel indexes in list. Include ALL channels of clusters in
        % selected time interval.
        for frame = 1:nframes
            for iPos = 1:length(sigpos)
                [posch,dum]=find(sigposCLM(:,ind_timewin(frame)-tshwp:ind_timewin(frame)+tshwp,iPos) == 1);
                list{frame}{iPos} =unique(posch);
            end
            for iNeg = 1:length(signeg)
                [negch,dum]=find(signegCLM(:,ind_timewin(frame)-tshwp:ind_timewin(frame)+tshwp,iNeg) == 1);
                list{frame}{length(sigpos)+iNeg} =unique(negch);
            end
        end
        
        % make plots
        figure;
        for frame=1:nframes
            cfgtopo.xlim = [stat.time(ind_timewin(frame)-tshwp) stat.time(ind_timewin(frame)+tshwp)];
            % cfgtopo.xlim = [stat.time(ind_timewin_min+PlN-1) stat.time(ind_timewin_min+PlN-1)];
            cfgtopo.highlightchannel = [];
            cfgtopo.comment = strcat(num2str(stat.time(ind_timewin(frame)-tshwp)),' - ',num2str(stat.time(ind_timewin(frame)+tshwp)), ' s');
            cfgtopo.commentpos = 'title';
            cfgtopo.comment='no';
            cfgtopo.highlightchannel = list{frame};
subplot(1,5,1);
ft_topoplotTFR(cfgtopo, data1);
subplot(1,5,2);
ft_topoplotTFR(cfgtopo, data2);
subplot(1,5,3);
ft_topoplotTFR(cfgtopo, data3);
subplot(1,5,4);
ft_topoplotTFR(cfgtopo, data4);
subplot(1,5,5);
cfgtopo.zlim=[-maxlimstat maxlimstat];
            ft_topoplotTFR(cfgtopo, datadiff);            
        end
        
        if isequal(cfg.saveaspng,'no');
        else
            filename = strcat(cfg.saveaspng, '_fig', num2str(iPl));
            print(gcf,'-dpng',filename);
        end
    end
end


% do the general cleanup and bookkeeping at the end of the function
ft_postamble trackconfig
ft_postamble callinfo
ft_postamble previous stat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sign = prob2hlsign(prob, hlsign)
if prob < 0.01
    sign = hlsign(1);
elseif prob < 0.05
    sign = hlsign(2);
elseif prob < 0.1
    sign = hlsign(3);
elseif prob < 0.2
    sign = hlsign(4);
elseif prob < 0.3
    sign = hlsign(5);
end

