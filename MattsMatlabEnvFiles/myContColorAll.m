function [cmCols,cmap]=myContColorAll(cm_length,hue,value,Smin,Smax,CVals,RndDig,useLogCols,titstr,axflag);
%   function    [cmCols,cmap]=myContColorAll(cm_length,hue,value,Smin,Smax,CVals,RndDig,useLogCols,axflag);
%
%   Started 070107 by MJN
%
%   Calls: myContHueColormap, myContColorVals, and myContColorbar in
%   succession. The colorbar is created automatically by this program, but 
%   you have to assign the values in cmCols (outputted by this function) to
%   each line or item in your
%   plot on your own.
%
%   See helps on the individual functions if you need an explanation of
%   the inputs and outputs.

if nargin<10 |   isempty(axflag)  axflag=gca;  end
if nargin<10 titstr='';  end
if nargin<8 |   isempty(useLogCols)  useLogCols=0;  end
if nargin<7 |   isempty(RndDig)  RndDig=-1;  end

if nargin<5 |   isempty(Smax)   Smax=1; end
if nargin<4 |   isempty(Smin)   Smin=0; end
if nargin<3 |   isempty(value)  value=.9; end
if nargin<2 |   isempty(hue)    hue=0; end
if nargin<1 |   isempty(cm_length)   cm_length=64; end

cmap=myContHueColormap(cm_length,hue,value,Smin,Smax);
cmCols=myContColorVals(CVals,cmap);
myContColorbar(CVals,cmap,RndDig,useLogCols,titstr,axflag);