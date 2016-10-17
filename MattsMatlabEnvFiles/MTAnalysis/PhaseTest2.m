%PhaseTest2.m
% This won't plot the histograms for a given configuration, but rather it
% is meant to plut a summary graph across combinations. 

writeflag=1;
ZCols=[.93 .75 .5 0]; %1 for every zpad value
nits=1000; %# of iterations per configuration

NVals=[.1 .2 .3 .4 .5];
ZVals=[1 4 10 20];
FsVals=[1000 20000];

nN=length(NVals);
nZ=length(ZVals);
nFs=length(FsVals);

% HAllPhs=zeros(nN,nFs);
% HAllAmp=HAllPhs;
% HAllFreq=HAllPhs;
% 
% % FFTAllPhs=zeros(nN,nZ,nFs);
% % FFTAllAmp=FFTAllPhs;
% % FFTAllFreq=FFTAllPhs;
% 
% for iN=1:nN
%     for iFs=1:nFs
%         for iZ=1:1%nZ
%             NAmp=NVals(iN);
%             zpad=ZVals(iZ);
%             Fs=FsVals(iFs);
%             if iZ==1     HilbCheck=1;   else    HilbCheck=0;    end
% 
%             for iit=1:nits
%                 if mod(iit,100)==0
%                     disp(['On iit: ' num2str(iit) ])
%                 end
% 
%                 FFTUnitsTest
%                 Phs(iit)=Ph;        %Ph already in degrees...
%                 Amp(iit)=FFTAmp;
%                 MeasFreq(iit)=FFTFreq;
%                 
% %                 FFTAllPhs(iN,iZ,iFs)=FFTAllPhs(iN,iZ,iFs)+Ph;
% %                 FFTAllAmp(iN,iZ,iFs)=FFTAllAmp(iN,iZ,iFs)+FFTAmp;
% %                 FFTAllFreq(iN,iZ,iFs)=FFTAllFreq(iN,iZ,iFs)+FFTFreq;
% 
%                 if iZ==1
%                     HAllPhs(iN,iFs)=HAllPhs(iN,iFs)+HilbPh;
%                     HAllAmp(iN,iFs)=HAllAmp(iN,iFs)+HilbAmp;
%                     HAllFreq(iN,iFs)=HAllFreq(iN,iFs)+HilbFreq;
%                 end
%             end
% %             FFTAllPhs(iN,iZ,iFs)=FFTAllPhs(iN,iZ,iFs)/nits;
% %             FFTAllAmp(iN,iZ,iFs)=FFTAllAmp(iN,iZ,iFs)/nits;
% %             FFTAllFreq(iN,iZ,iFs)=FFTAllFreq(iN,iZ,iFs)/nits;
% 
%             if iZ==1
%                 HAllPhs(iN,iFs)=HAllPhs(iN,iFs)/nits;
%                 HAllAmp(iN,iFs)=HAllAmp(iN,iFs)/nits;
%                 HAllFreq(iN,iFs)=HAllFreq(iN,iFs)/nits;
%             end
%             
%         end
%     end
% end

for iFs=1:nFs
    figure
    
    cax=subplot(311);
    plot(NVals,abs(HAllPhs(:,iFs)),'ko--','LineWidth',2);
    hold on    
    for iZ=1:nZ
        plot(NVals,abs(FFTAllPhs(:,iZ,iFs)),'o-','Color',[repmat(ZCols(iZ),1,3)],'LineWidth',2)
        %plot(NVals,FFTAllPhs(:,iZ,iFs),'Color',mycolors(iZ+1),'LineWidth',2)
    end
    set(cax,'TickDir','out')
    ylabel('Phase (deg)')
    xlabel('Noise Ratio')
    title(['Fs: ' num2str(FsVals(iFs))])
    
    
    cax=subplot(312);
    plot(NVals,HAllAmp(:,iFs),'ko--','LineWidth',2);
    hold on    
    for iZ=1:nZ
        plot(NVals,FFTAllAmp(:,iZ,iFs),'o-','Color',[repmat(ZCols(iZ),1,3)],'LineWidth',2)
        
    end
    set(cax,'TickDir','out')
    ylabel('Amp (Norm)')
    xlabel('Noise Ratio')
    
    cax=subplot(313);
    plot(NVals,HAllFreq(:,iFs),'ko--','LineWidth',2);
    hold on    
    for iZ=1:nZ
        plot(NVals,FFTAllFreq(:,iZ,iFs),'o-','Color',[repmat(ZCols(iZ),1,3)],'LineWidth',2)
    end
    set(cax,'TickDir','out')
    ylabel('Freq (Hz)')
    xlabel('Noise Ratio')
end


if writeflag
    save 'C:\Documents and Settings\Erik\Desktop\ImpSub\SupMethFigs\FFTSimData' FFTAll* HAll*
end