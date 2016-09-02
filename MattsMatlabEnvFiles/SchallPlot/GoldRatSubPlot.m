function axH=GoldRatSubPlot(nrows,ncols,thisplot,tallflag,HBTSpace,VBTSpace,CenVFlag,PlotSpcL,PlotSpcB,PlotSpcW,PlotSpcH)
%function axH=GoldRatSubPlot(nrows,ncols,thisplot,tallflag,HBTSpace,VBTSpace,CenVFlag,PlotSpcL,PlotSpcB,PlotSpcW,PlotSpcH)
%
% this will creates subplots on the current figure, with each subplot
% having sizes that correspond to teh golden ratio (~1.6)
%
%   NOTE: these subplots are added to teh current figure. It is recommended
%   to run GenPapSizeFig once before calling this function. 
% 
%   nrows:      Number of rows (same as Matlab command subplot)
%   ncols:      Number of columnss (same as Matlab command subplot)
%   thisplot:   The index number of the axis you wish to create 
%               (same as Matlab command subplot)
%   tallflag:   Set to 1 to make the height of each axis longer than the
%               width, or else the width will be longer than the height.
%               Defaults to 0 (a wide axis).
%               Set tallflag to 2 to produce 1 to 1 axis subplots...
%   CenVFlag:   set to 1 if you want the vertical position of the subplots
%               to be centered vertically on the figure.
%   Later inputs are if you want to specify the positions (in inches) on 
%   the figure that the subplots will be allowed to cover... inputs are
%   (respectively) left, bottom, width and height...

%all units in inches
if nargin<11 || isempty(PlotSpcH);   PlotSpcH=9;     end
if nargin<10 || isempty(PlotSpcW);   PlotSpcW=3.25-.5;     end      %The minus .5 is to allow for Horz space for the y-axis label... for 1 column width, do 3.25-.5 width, i.e. 2.75 inches
if nargin<9 || isempty(PlotSpcB);   PlotSpcB=2;     end
if nargin<8 || isempty(PlotSpcL);   PlotSpcL=0.75+.5;     end   %The minus .5 is to allow for Horz space for the y-axis label...
if nargin<7 || isempty(CenVFlag);   CenVFlag=1;     end
if nargin<6 || isempty(VBTSpace);   VBTSpace=.35;  end  %inches
if nargin<5 || isempty(HBTSpace);   HBTSpace=.325+.5;  end  %inches     %needs to be sufficient enough to allow space for y-axis labels... 
if nargin<4 || isempty(tallflag);   tallflag=0;     end
if nargin<3 || isempty(thisplot);   thisplot=1;     end
if nargin<2 || isempty(ncols);   ncols=3;     end
if nargin<1 || isempty(nrows);   nrows=1;     end

PlotSpcR=PlotSpcH+PlotSpcB;

AxW=(PlotSpcW-(ncols-1)*HBTSpace)/ncols;
AxL=( mymod(thisplot,ncols)-1 )*(AxW+HBTSpace)+PlotSpcL;
if AxL+AxW>PlotSpcR;        error(['Ax rightpoint ends at:' num2str(AxL+AxW) 'which extends past the plot space border of ' num2str(PlotSpcR)]);        end

switch tallflag
    case 2;    AxH=AxW;         case 1;    AxH=AxW*1.6;        case 0;        AxH=AxW/1.6;        
end
if CenVFlag
    PlotSpcH=nrows*(AxH+VBTSpace)-VBTSpace;
    %for some reason the size of the figure isn't 8.5 x 11, even though I
    %request it to be... so adjust for that to produce the proper locations of
    %the axes...
    curFPos=get(gcf,'Position');
    FH=curFPos(4);
    PlotSpcB=(FH-PlotSpcH)/2;
end
PlotSpcT=PlotSpcH+PlotSpcB;

%from here, given AxH and VBTSpace, we'll count downwards from PlotSpcT
AxB=PlotSpcT-( ( ceil(thisplot/ncols) )*(AxH+VBTSpace) )+VBTSpace;

if AxB+AxH>PlotSpcT;        error(['Ax top ends at:' num2str(AxB+AxH) 'which extends past the plot space border of ' num2str(PlotSpcT)]);        end
if AxB<PlotSpcB;        error(['Ax bot ends at:' num2str(AxB) 'which extends past the plot space border of ' num2str(PlotSpcB)]);        end

%assume a paper size Fig (8.5 x 11)
% AxW=AxW/8.5;
% AxL=AxL/8.5;
% AxB=AxB/11;
% AxH=AxH/11;

axH=axes('Units','inches','Position',[AxL AxB AxW AxH]);

box off
set(axH,'TickDir','out')
%set(axH,'Units','inches','Position',[AxL AxB AxW AxH])
%disp('wtf')
