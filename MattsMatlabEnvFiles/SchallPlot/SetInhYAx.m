function SetInhYAx
% SetInhAx 
%
% Sets the y-axis of the current axes to be that of an Inh Fxn the way Jeff
% likes it- i.e. the limits are imposed to be 0 to 1, and the tick labels 
% for 0 and 1 are changed to 1.0 and 0.0
%
% written by MJN on 071230


axvals=axis;
axvals(3:4)=[0 1];
axis(axvals);
set(gca,'YTick',[0 .25 .5 .75 1])

%tmp=get(gca,'YTickLabel');
%tmp(1,2:3)='.0';
%tmp(end,2:3)='.0';
%set(gca,'YTickLabel',tmp);

set(gca,'YTickLabel',{'0.0','','0.5','','1.0'});