function FigH=GenAlmostReallyWideScrFig(VisFlag)
% function FigH=GenAlmostReallyWideScrFig(VisFlag)

global CompID

if nargin<1 || isempty(VisFlag);        VisFlag='On';      end
if isnum(VisFlag) 
    if VisFlag==0;       VisFlag='Off';      else        VisFlag='On';           end
end

switch CompID
    case 'MattsLaptop'
        pos=[157         165        1358         621];
    case 'MattNeurospinLinux'
        pos=[251         126        1514         935];
    otherwise
        pos=[157         165        1200         600];
end


FigH=figure('Position',pos,'Visible',VisFlag); 