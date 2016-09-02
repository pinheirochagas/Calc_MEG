%PhaseTest.m

NAmp=.1;
zpad=1;
Fs=1000;

nits=1000;
MeasPhs=zeros(nits,1);
MeasAmp=MeasPhs;
HMeasPhs=MeasPhs;
HMeasAmp=MeasPhs;
for iit=1:nits
    if mod(iit,100)==0
        disp(['On iit: ' num2str(iit) ])
    end
    
    FFTUnitsTest
    MeasPhs(iit)=Ph;        %Ph already in degrees...
    MeasAmp(iit)=FFTAmp;
    MeasFreq(iit)=FFTFreq;
    
    HMeasPhs(iit)=HilbPh;   %Ph already in degrees...
    HMeasAmp(iit)=HilbAmp;
    HMeasFreq(iit)=HilbFreq;
end
%disp(['Mean Ph: ' num2str(mean(MeasPhs)) '; Var Ph: ' num2str(var(MeasPhs))]);
%disp(['Mean Ph: ' num2str(mean(MeasPhs)) '; Var Ph: ' num2str(var(MeasPhs))]);

figure
subplot(311)
hist(MeasPhs)
title(['Mean Ph: ' num2str(mean(MeasPhs)) '; Var Ph: ' num2str(var(MeasPhs))]);
subplot(312)
hist(MeasAmp)
title(['Mean Amp: ' num2str(mean(MeasAmp)) '; Var Amp: ' num2str(var(MeasAmp))]);
subplot(313)
hist(MeasFreq)
title(['Mean Freq: ' num2str(mean(MeasFreq)) '; Var Amp: ' num2str(var(MeasFreq))]);
xlabel(['NAmp: ' num2str(NAmp) ', zpad: ' num2str(zpad) ', Fs: ' num2str(Fs)])

figure
subplot(311)
hist(HMeasPhs)
title(['Hilb Mean Ph: ' num2str(mean(HMeasPhs)) '; Var Ph: ' num2str(var(HMeasPhs))]);
subplot(312)
hist(HMeasAmp)
title(['Hilb Mean Amp: ' num2str(mean(HMeasAmp)) '; Var Amp: ' num2str(var(HMeasAmp))]);
subplot(313)
hist(HMeasFreq)
title(['Hilb Mean Freq: ' num2str(mean(HMeasFreq)) '; Var Amp: ' num2str(var(HMeasFreq))]);
xlabel(['NAmp: ' num2str(NAmp) ', zpad: ' num2str(zpad) ', Fs: ' num2str(Fs)])

