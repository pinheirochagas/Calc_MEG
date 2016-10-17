function FigH=GenReallyWideScrFig
% function FigH=GenReallyWideScrFig

global CompID

switch CompID
    case 'MattsLaptop'
        FigH=figure('Position',[96         112        1414         680]); 
    case 'MattNeurospinLinux'
        FigH=figure('Position',[142          81        1853         986]);      
    otherwise
        FigH=figure('Position',[142         81        1000         400]);
end

