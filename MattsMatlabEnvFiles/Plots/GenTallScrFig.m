function FigH=GenTallScrFig(VisFlag)
% function FigH=GenTallScrFig(VisFlag)
%
% We need to set VisFlag when we're cretaing the figure if we don't want it
% to capture the focus of the user with this fiugre   

global CompID

if nargin<1 || isempty(VisFlag);        VisFlag='On';      end
if isnum(VisFlag) 
    if VisFlag==0
        VisFlag='Off';
    else
        VisFlag='On';
    end
end


try switch CompID
    case 'MattsLaptop';
        pos=[59    60   582   740];
    otherwise
        pos=[35    47   758   876];
    end
catch
    pos=[35    47   758   876];
end

    
FigH=figure('Position',pos,'Visible',VisFlag); 