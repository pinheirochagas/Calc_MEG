function myContColorbar(CVals,cmap,RndDig,useLogCols,titstr,axflag)
%   function [cmCols,cmin,cmax]=myContColorbar(CVals,cmap,RndDig,useLogCols,titstr,axflag)
%   
%   Started 070107 by MJN
%
%   INPUTS: CVals-      The values for the YTicks on the Colorbar
%           cmap-       The rgb values of your cmap, usually obtained from
%                           myContHueColormap, or one of matlab's color 
%                           mappings. This contains each color's rgb value
%                           across each row of cmap. Defaults to jet(64)
% Note: if not using jet cmap, you DO have to call colormap(cmap) for each
% axis, not just once, for all ensuing axes and figures!
%
%               RndDig-     The RndDig for myRoundForDisp for the YTicks.
%                       Defaults to -1
%               useLogcols- Defaults to 0. If set to 1 this assumes the
%                   values for CVals are really the base 10 logarithm of
%                   the actual CVals, and 10.^CVals is printed as the
%                   YTicks  
%                       Note- RndDig right now is automatically ste to 0 if
%                       useLogCols is on.
%               titstr- Title you want added above the colorbar. Defaults
%                   to no title. Suggestion: make the title's breif, as 
%                   colorbars are typically thin. 
%               axflag-     The handle for the axis you want the colorbar
%                   added to. DEFAULTS to the current axis

if nargin>=6    && ~isempty(axflag)  axis(axflag);  end
if nargin<5 titstr='';  end
if nargin<4 |   isempty(useLogCols)  useLogCols=0;  end
if nargin<3 |   isempty(RndDig)  RndDig=-1;  end
if nargin<2 |   isempty(cmap)  cmap=jet(64);  end

cmin=min(CVals);
cmax=max(CVals);

caxis([cmin cmax]);     %importantly: this acts on the axis with data on it- not the colorbar itself...
colormap(cmap)
cbh=colorbar;
set(cbh,'YLim',[cmin cmax])
tmpCVals=sort(CVals);
if ~useLogCols
    tmpCVals(end)=myRoundForDisp(tmpCVals(end),RndDig,-1);
    if length(tmpCVals)>2      tmpCVals(2:end-1)=myRoundForDisp(tmpCVals(2:end-1),RndDig,0);  end
    tmpCVals(1)=myRoundForDisp(tmpCVals(1),RndDig,1);
end
set(cbh,'YTick',tmpCVals)
%set(cbh,'YTickLabel',{'A','B','C','D','E'})
if useLogCols
    [tmp,tmpCVallabs]=myRoundForDisp(10.^tmpCVals,0);
    set(cbh,'YTickLabel',tmpCVallabs)
end
if ~isempty(titstr) title(cbh,titstr);  end 