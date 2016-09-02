%PlotAdHocSineWave.m

%one cycle assumed
tend=4000;
t=1:tend;
peakX=2275;
Amp=(92- -396)/2;
DC=-154;

plot( DC + Amp*cos( 2*pi* (t-peakX)/tend ) ,'m')