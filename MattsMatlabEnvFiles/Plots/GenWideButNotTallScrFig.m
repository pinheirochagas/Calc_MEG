function FigH=GenWideButNotTallScrFig(VisFlag)
% function FigH=GenWideButNotTallScrFig(VisFlag)

global CompID

if nargin<1 || isempty(VisFlag);        VisFlag='On';      end
if isnum(VisFlag) 
    if VisFlag==0;       VisFlag='Off';      else        VisFlag='On';           end
end

switch CompID
    case 'MattsLaptop'
        pos=[123         451        1441         350];
    case 'MattNeurospinLinux'
        pos=[251         527        1518         534];        
    otherwise
        pos=[251         527        1000         400];
end


FigH=figure('Position',pos,'Visible',VisFlag); 