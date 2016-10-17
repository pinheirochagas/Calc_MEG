function cmCols=myContColorVals(CVals,cmap,cmin,cmax)
% function cmCols=myContColorVals(CVals,cmap,cmin,cmax)
%
%   Started 070107 by MJN
%
%   Given colormap values in cmap, and numeric data in CVals, this will
%   give you an rgb value from cmap associated with each numeric value in 
%   the vector CVals in down each row of cmCols.
%
%   INPUTS: CVals-      The numeric values you want mapped onto your cmap.
%                           Right now this is assumed to a row or column
%                           vector.
%           cmap-       The rgb values of your cmap, usually obtained from
%                           myContHueColormap, or one of matlab's color 
%                           mappings. This contains each color's rgb value
%                           across each row of cmap.
%           cmin-       (Optional) the minimum numerical value associated
%                           with the "lowest" color on the cmap. Defaults 
%                           to the minimum of CVals.
%           cmax-       (Optional) the maximum numerical value associated
%                           with the "highest" color on the cmap. Defaults 
%                           to the maximum of CVals.
%
%   OUTPUTS: cmCols-    A 2D matrix (length(CVals) x 3) containg down each
%                           of its rows the rgb values associated with
%                           each CVals value.

if nargin<4 || isempty(cmax)        cmax=max(CVals);        end
if nargin<3 || isempty(cmin)        cmin=min(CVals);        end
cm_length=size(cmap,1);

for ic=1:length(CVals)
    cmind = min(fix((CVals(ic)-cmin)/(cmax-cmin)*cm_length)+1,cm_length);
    cmCols(ic,:)=cmap(cmind,:);
end
