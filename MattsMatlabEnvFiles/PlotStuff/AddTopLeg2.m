function [h1] =AddTopLeg2(legstr)
% function AddTopLeg2(legstr)
%
% Started 080412 by MJN. Adds a Top Legend to the current figure, using the string input as legstr, 
% currently assumed to be a 2x1 cell array of strings. This was originally
% designed for the RaceModelCheckFig, called by PlotRMCheckFig.
%
% Unlike AddTopLeg1, this will have only one subplot axis and return its handle

%add top Legend
LegHeight=.07;
HBrdrSpace=.06;
VBrdrSpace=.01;
StartVPos=.25;
%VSpc=.4;
MainLax=axes('position',[HBrdrSpace  1-VBrdrSpace-LegHeight  1-2*HBrdrSpace  LegHeight]);%,'Visible','off');

th=text(.5,StartVPos+.5,legstr{1},'HorizontalAlignment','center');
th2=text(.5,StartVPos,legstr{2},'HorizontalAlignment','center');

set(th,'FontSize',14,'FontWeight','bold')
set(th2,'FontSize',14,'FontWeight','bold')
axis(MainLax,[0 1 0 1])
set(MainLax,'YTick',[],'XTick',[])
box on

%this assumes the units on the current figure are normalized
h1=axes('position',[0.13 0.10 0.775 0.75]);
