function FigH=GenTallScrFig2
% function FigH=GenTallScrFig2
%
%  this was created to have a 3x1 layout of approximatelt square subplots, filling up the screen   

global CompID

switch CompID
    case 'MattNeurospinLinux'
        FigH=figure('Position',[160          16         475        1062]);
    otherwise
        %the intention is to change this later    
        FigH=figure('Position',[160          16         475        1062]);
end
