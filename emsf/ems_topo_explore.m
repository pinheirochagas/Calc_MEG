function h = ems_topo_explore(fh,mSF,plotfun,varargin)
%
% function h = ems_topo_explore(fh,mSF,@plotfun,[plotfun_params],...
%                               [taxis],[sensInd],[title])
%
% Parameters:
%   fh     : a figure handle of a figure with a time course already plotted
%   mSF    : a spatial filter set, output from e.g. ems_2cond_diff
%   @plotfun : function handle to a topo plotting function. This function
%              is assumed to take a column vector as its first parameter
%              (the topography), and then zero or more additional
%              parameters. The best thing to do is to write a simple
%              wrapper function that takes the paramters in this order, and
%              then calls your favorite topo plotting function with the
%              parameters ordered and organized to its liking.
%   [plotfun_params] :
%                a cell array with any other parameters you want to be
%                passed to the topo plotting function. Can be empty.
%   [taxis]    : a 2-element vector with the sampling rate and number of
%                seconds before zero in the epoch [SR, t0]. If this
%                parameter is not included then you will be prompted.
%   [sensInd]  : optional index of sensors to use for plotting, e.g. when
%                different sensor types are mixed in the same data matrix.
%                Defaults to all sensors if omitted or if [] passed in.
%   [title]    : a title for the resulting topo figure
%
% This function allows you to explore the topography of spatial filters
% output from the ems_2cond_diff or ems_ncond. Typically you will plot the
% time course of the difference between two conditions, using the output of
% ems_2cond_diff, take note of the figure handle, and then call
% ems_topo_explore with the figure handle as the first parameter. You click
% twice on the time course in the plot to delimit a time range over which
% to compute and inspect the mean spatial filter. A topographical plot will
% then appear in a new figure.
%
% You must specify your own topo-plotting function using the optional
% @plotfun argument (topo-plotting function). This should be a function
% handle to a function that takes a column vector (the topography) as its
% first argument. The plotfun_params argument is a cell array with any
% other parameters that you want to be passed to the plotting function. See
% function plotfun_wrapper.m for an example wrapper function that calls a
% topo plotting function.
% 
%

if nargin<3
    error('You must supply a topo plotting function.');
end

if length(varargin)>0 && ~isempty(varargin{1})
    if ~iscell(varargin{1})
        error('plotfun_params must be a cell array (can be empty if you want).')
    else
        plotfun_params = varargin{1};
    end
else
    plotfun_params = {};
end
if length(varargin)>1 && ~isempty(varargin{2})
    SR = varargin{2}(1);
    t0 = varargin{2}(2);
else
    SR = input('Sampling rate: '); %DATA.fsample;
    t0 = input('Time 0: '); %-DATA.time{1}(1);
end
if length(varargin)>2 && ~isempty(varargin{3})
    sensInd = varargin{3};
else
    sensInd = {[1:size(mSF,1)]};
end
if length(varargin)>3 && ~isempty(varargin{4})
    ttext = strrep(varargin{4},' ','_');
else
    ttext = [];
end

figure(fh)
[X,Y] = ginput(2);
S1 = round((X(1)+t0)*SR);
S2 = round((X(2)+t0)*SR);
sRange = [S1:S2];

h=figure;
if iscell(sensInd)
    nTopo = length(sensInd); % subset of sensors, e.g. magnetometers
else
    nTopo = 1;
    sensInd = {sensInd}; % put it into a cell
end
    
nRows = ceil(nTopo/3);
nCols = min(nTopo,3);

if nTopo>9
    warning(sprintf('Maximum of 9 sensor subsets are allowed.\nOnly first 9 will be displayed'))
end

for i=1:min(nTopo,9)
    subplot(nRows,nCols,i)
    plotfun(squeeze(mean(mSF(sensInd{i},sRange),2)),plotfun_params{:});
    title(sprintf('%4.3f : %4.3f',X(1),X(2)),'fontsize',10,'fontweight','bold')
    caxis auto
    cax(i,:) = caxis;
end

if nTopo > 1
    % set the color scale to be the same for all sub-plots
    if size(cax,1)>1
%         CAX = [min(cax(:,1),1) max(cax(:,2),1)];
        CAX = [min(cax(:,1)) max(cax(:,2))];
       
    else
        CAX=cax;
    end

    for i=1:min(nTopo,9)
        subplot(nRows,nCols,i)
        caxis(CAX)
    end
end

% if ~isempty(ttext)
%     fName_prefix = sprintf('%s_topo_%-2.3f:%-2.3f',ttext,X(1),X(2));
%     saveas(gcf,sprintf('%s.fig',fName_prefix),'fig');
%     print('-dtiff','-r300',sprintf('%s.tif',fName_prefix))
% end
    
    