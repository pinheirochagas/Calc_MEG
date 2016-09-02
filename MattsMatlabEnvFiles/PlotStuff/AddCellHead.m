%AddCellHead.m
%
% I decided to run this as a script, not a function. It uses CurSpk,
% assumed to be pre-loaded into the workspace.
%
% function AddCellHead(monkey,day,TaskLab,hemstr,elec,unit,AP,ML,depth)
% function AddCellHead(monkey,day,TaskLab,chbr,elec,unit)
%
% Adds a header to the current figure which shows
% basic information about the cell in CurSpk. This only sets up the header 
% and no other axes.
%
% Started 080721 by MJN. 

day=CurSpk.day;
chbr=CurSpk.chbr;
if ~isfield(ElecInfo,'ChbrRef');    ElecInfo.ChbrRef='LR';      end
hemstr=ElecInfo.ChbrRef(chbr);    %will be L or R indicating which Hem
elec=CurSpk.elec;
unit=CurSpk.unit;
AP=CurSpk.AP;
ML=CurSpk.ML;
depth=CurSpk.depth;
IQual=CurSpk.IsoQual;

legstr{1}=[monkey ' ' day '     Task:' TaskLab '  Hem:' hemstr '  Elec:' num2str(elec) '  Unit:' num2str(unit) '  ML:' num2str(ML) '  AP:' num2str(AP) '  Depth: ' num2str(depth) '  IsoQual: ' num2str(IQual)];

%add Header... vals are for the figure overall
TopLegHeight=.022;
if printflag && ~CrazyPrintValsFlag;        HBrdrSpace=.023;        else        HBrdrSpace=.015;        end
VBrdrSpace=.012;
StartVPos=.5;  %for text
%VSpc=.4;

MainLax=axes('position',[HBrdrSpace  1-VBrdrSpace-TopLegHeight  1-2*HBrdrSpace  TopLegHeight]);%,'Visible','off');
th=text(.5,StartVPos, legstr{1},'HorizontalAlignment','center');
if printflag && CrazyPrintValsFlag       set(th,'FontSize',26,'FontWeight','bold');  %proper print font size would be 12 if things worked correctly with PaperPosition...
elseif printflag && ~CrazyPrintValsFlag     set(th,'FontSize',12,'FontWeight','bold');  %matlab doesn't seem to want to print this if it thinks the upper extent of it goes off the page... so we have to go with a font size of 12 and not 14
else        set(th,'FontSize',14,'FontWeight','bold');
end
axis(MainLax,[0 1 0 1])
set(MainLax,'YTick',[],'XTick',[])
box on