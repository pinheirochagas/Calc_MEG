function [y1, y2]=GetYsForVertPlotLine(dat)

y1=min(dat);
y2=max(dat);
rng=y2-y1;
y1=y1-.05*rng;
y2=y2+.05*rng;