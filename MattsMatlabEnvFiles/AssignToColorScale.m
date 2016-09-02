function [RGBout, CLim] = AssignToColorScale(vals,colormap,CLim,cmapRes)
% function RGBout = AssignToColorScale(vals,colormap,cLim,cmapRes)
%     
% map the vals included to a color based on linear scale with ref points at the cLims  
%
% colormap can be a string definining the color map, or an n x 3 array of a pre-defined colormap       

if nargin<4 || isempty(cmapRes);       cmapRes=2000;     end 
if nargin<3 || isempty(CLim);   CLim=[min(vals) max(vals)];     end
if nargin<2 || isempty(colormap);       colormap='jet';     end 

if isstr(colormap)
    eval(['cmap=' colormap '(cmapRes);']);
else
    cmap=colormap;
    cmapRes=size(cmap,1);
end

% map the vals to a color based on linear scale with ref points at the cLims
nElecs=length(vals);
rng=diff(CLim);
colornumbers=round( (vals-CLim(1))/rng * (cmapRes-1) )+1;

RGBout=cmap(colornumbers,:);
