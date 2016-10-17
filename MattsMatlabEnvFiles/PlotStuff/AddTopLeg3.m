function [h1 h2 h3 h4] =AddTopLeg3(legstr)
% function AddTopLeg3(legstr)
%
% Started 080412 by MJN. Adds a Top Legend to the current figure, using the string input as legstr, 
% currently assumed to be a 2x1 cell array of strings. This was originally
% designed for the RaceModelCheckFig, called by PlotRMCheckFig.
%
% It will also creat four subplots (a 2x2 design- with each subplot taking up the same space) and return their handles

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
h1=axes('position',[0.13 0.56 0.33 0.33]);
h2=axes('position',[0.575 0.56 0.33 0.33]);
h3=axes('position',[0.13 0.10 0.33 0.33]);
h4=axes('position',[0.575 0.10 0.33 0.33]);



