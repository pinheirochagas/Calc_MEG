%GenMultFigTallScrFigSubplot.m
%
% Begun on 100110 by MJN. Modified from GenTallScrFigSubPlot to allow
% tracking of multiple figures for different plot types that are not
% necessarily all added in a row.
%
% This relies on the vars iFig, Fighands, iplot, nrow, ncol and nplot being in the
% workspace. iFig is a scalar denoting the current figure number, Fighands
% is a 1 x nFigs vector of Fighands, iplot is a 1xnFig vector of subplot
% indicdes per Fig, while nrow, ncol, and nplot are scalars (the form of
% each fig is assumed to be the same for each fig)
%
% A script file involving GenTallScrFig to create subplots on the TallScrFig
% and create another such Fig if necessary. 
%
% This is expected to be used in a loop where one is not sure how many
% plots one wants to make.

iplot(iFig)=iplot(iFig)+1;
if iplot(iFig)==1    
    Fighands(iFig)=GenTallScrFig;
else
    figure(Fighands(iFig));
end
curah=subplot(nrow,ncol,iplot(iFig));
if iplot(iFig)==nplot;        iplot(iFig)=0;        end     %reset iplot if this is the last plot of the figure