function th=plotCDF(Data,plotopts,RGB,LW,setAxProps)
%function plotCDF(Data,plotopts,RGB,LW,setAxProps)
%
% RGB: Color RGB value
% LW: valuee of the LineWidth you wish to set
% setAxProps:   set to 1 to set the Yaxes properties to those preferred on
%               CDF. (Typically only needs to be once per axes) Defaults to
%               1.
%
% Will add the CDF for all the data points in DATA input in,
% using plotopts. This assumes DATA is a vector, and adds the plot to the
% current axes.
%
% This is really just a one-liner program, the only reason I write a
% program for this is so I don't have to remember how to do it.
%
%   This is written now to ignore NaN's...

if nargin<5 || isempty(setAxProps);     setAxProps=1;       end
if nargin<4;         LW=[];          end
if nargin<3;         RGB=[];         end
if nargin<2;         plotopts='';    end
Data=Data(~isnan(Data));

if isempty(RGB)
    if isempty(LW)
        th=plot(sort(Data),(1:length(Data))./length(Data),plotopts);
    else
        th=plot(sort(Data),(1:length(Data))./length(Data),plotopts,'LineWidth',LW);
    end
else
    if isempty(LW)
        th=plot(sort(Data),(1:length(Data))./length(Data),plotopts,'Color',RGB);
    else
        th=plot(sort(Data),(1:length(Data))./length(Data),plotopts,'Color',RGB,'LineWidth',LW);
    end
end

%adjust properties of current axes
if setAxProps
    box off
    set(gca,'YTick',[0 .25 .5 .75 1],'YTickLabel',{'0%','','50%','','100%'},'TickDir','out')
end