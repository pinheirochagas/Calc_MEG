function cmap=myContHueColormap(cm_length,hue,value,Smin,Smax)
% function cmap=myContHueColormap(cm_length,hue,value,Smin,Smax)
%
%   Started 070107 by MJN
%
%   Creates an rgb colormap from hsv colord of increasing saturation
%   associated with higher values holding hue and value constant
%
%   INPUTS: cm_length-  Length of the colormap- The color resolution, 
%                           i.e. the number of total colors in the cmap
%           hue-        Value from 0 to 1 to determine the color. Defaults
%                           to 0 (red). For reference, blue is about 0.6
%           value-      Value from 0 to 1 to determine the value, or \
%                           brightness. Defaults to .9
%           Smin-       Value from 0 to 1 to determine the value of the
%                           Saturation at the minimum point of the data. 
%                           Defaults to 0.
%           Smax-       Value from 0 to 1 to determine the value of the
%                           Saturation at the maximum point of the data. 
%                           Defaults to 1.
%
%           cmap-       The rgb values of your cmap, in a (cm_length x 3)
%                           matrix that contains each color's rgb value
%                           across each row of cmap.
%
%   Matlab defaults to a jet colormapping with dark blue for low values and 
%   dark red for high values. There are also many other interesting 
%   colormappings matlab provides. See the Matlab help pages for more info 
%   on other available matlab colormaps.

if nargin<5 |   isempty(Smax)   Smax=1; end
if nargin<4 |   isempty(Smin)   Smin=0; end
if nargin<3 |   isempty(value)  value=.9; end
if nargin<2 |   isempty(hue)    hue=0; end
if nargin<1 |   isempty(cm_length)   cm_length=64; end

S=linspace(Smin,Smax,cm_length);
cmap = hsv2rgb([hue*ones(cm_length,1) S' value*ones(cm_length,1)]);