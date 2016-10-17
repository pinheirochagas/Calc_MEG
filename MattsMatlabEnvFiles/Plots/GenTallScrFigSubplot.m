%GenTallScrFigSubplot.m
%
% A script file involving GenTallScrFig to create subplots on the TallScrFig
% and create another such Fig if necessary. 
%
% This is expected to be used in a loop where one is not sure how many
% plots one wants to make.
%
% This relies on the vars iplot, nrow, ncol and nplot being in the
% workspace ... also added ifig later

iplot=iplot+1;
if iplot==1 
    ifig=ifig+1;
    FigH(ifig)=GenTallScrFig;
end
curah=subplot(nrow,ncol,iplot);
if iplot==nplot;        iplot=0;        end     %reset iplot if this is the last plot of the figure