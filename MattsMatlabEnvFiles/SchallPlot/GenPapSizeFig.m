function FigH=GenPapSizeFig
% function FigH=GenPapSizeFig
%
% A simple function to create a blank figure of the size 8.5 x 11 inches. 

FigH=figure('Units','inches');
set(FigH,'Position',[.25 .25 8.5 11]);