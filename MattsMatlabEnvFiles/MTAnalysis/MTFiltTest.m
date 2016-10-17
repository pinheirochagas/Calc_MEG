%MTFiltTest.m

MatlabCheck=1;
plotsigflag=1;
timespeccheck=1;

Fs = 1024;
sigf=75;%Freq of sinusoid in Hz
d=1; %sec

P=1;  %The P you use to investigate the data later
xph=0;
zpad=4;
sigf2=75;
sigf2Amp=5;
xph2=0;

zoomWRat=2.4;

t = 0:1/Fs:d;
t=t(1:end-1);

%x=randn(1,d*Fs);
%x=ones(1,d*Fs);
x=sigf2Amp*sin(2*pi*t*sigf2+xph2*pi/2);

filtd=d;
filtP=5;
filtK=1;
y=mtfilter(x,[filtd,filtP,2*filtP-1],Fs,sigf);
y=[zeros(1,length(y)) y];
W=filtP/filtd

y=y+.00*randn(1,length(y));

if plotsigflag
    figure
    subplot(3,1,1);
    ay=abs(y);
    dist=max(ay)-min(ay);
    plot(ay)
    title(['abs of signal of MT filtered noise. W: ' num2str(W) ';   cenf: ' num2str(sigf) ' Hz']);
    xlabel('sample #');
    axis([0 Fs*d*2 min(ay)-.01*dist max(ay)+.01*dist])
    
    subplot(3,1,2);
    ry=real(y);
    dist=max(ry)-min(ry);
    plot(ry)
    title(['real part of MT filtered noise. W: ' num2str(W) ';   cenf: ' num2str(sigf) ' Hz']);
    xlabel('sample #');
    axis([0 Fs*d*2 min(ry)-.01*dist max(ry)+.01*dist])
    
    subplot(3,1,3);
    iy=imag(y);
    dist=max(iy)-min(iy);
    plot(iy)
    title(['imag part of MT filtered noise. W: ' num2str(W) ';   cenf: ' num2str(sigf) ' Hz']);
    xlabel('sample #');
    if dist>0    axis([0 Fs*d*2 min(iy)-.01*dist max(iy)+.01*dist]);  end
end

NFFT= zpad*2^(nextpow2(length(x)));
%NFFT=1024*16;

if MatlabCheck
    %zoomflag=1; 
    [Pxx,fMatlab]=pmtm(y,{P},NFFT,Fs);
    
    dfMatlab=fMatlab(2)-fMatlab(1);
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    %[spec,F]=LFPSpec(x,tapers,Fs, d, 500,0);
%     BandWidthLimInd4(1)=find(fMatlab>sigf-W,1,'first');
%     BandWidthLimInd4(2)=find(fMatlab<sigf+W,1,'last');
%     BandwidthEn4=sum(Pxx(BandWidthLimInd4(1):BandWidthLimInd4(2)))*dfMatlab;
%     WholeSpecEn4=sum(Pxx)*dfMatlab;    
%     if dispflag     disp(['Matlab Total Power from ' num2str(sigf-W) ' to ' num2str(sigf+W) ' Hz is: ' num2str(BandwidthEn4)]);     end
%     if dispflag     disp(['Matlab Total Power of whole signal is: ' num2str(WholeSpecEn4)]);        end
%     ConcRat4=BandwidthEn4/WholeSpecEn4;
%     if dispflag     disp(['Concentration Ratio4: ' num2str(ConcRat4)]);     end

    figure
    subplot(2,1,1)
    plot(fMatlab,Pxx,'-x');
    title(['Matlab MT Power Spectrum of MT filtered noise. W: ' num2str(W) ';   cenf: ' num2str(sigf) ' Hz']);
    xlabel('Frequency (Hz)');
    ylabel('Power');

    subplot(2,1,2)
    plot(fMatlab,Pxx,'-x');
    title(['Zoomed Matlab MT Power Spectrum of MT filtered noise. W: ' num2str(W) ';   cenf: ' num2str(sigf) ' Hz']);
    xlabel('Frequency (Hz)');
    ylabel('Power');
    %if zoomflag 
    axis([sigf-W*zoomWRat sigf+W*zoomWRat -.01*max(Pxx) max(Pxx)*1.05]);     %end
end

if timespeccheck
    windur=.2;
    dn=.01;
    
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    [spec{3},fspec{3}]= LFPSpec(y,[windur,P*1/windur],Fs, dn, Fs/2, 1, -d*1000, zpad);
    
    W=P*1/windur
    
    %W=30;
    
    BWLimInd1(1)=find(fspec{3}>sigf-W,1,'first');
    BWLimInd1(2)=find(fspec{3}<sigf+W,1,'last');
    dfspec=fspec{3}(2)-fspec{3}(1);
    BandwidthEn2=sum(spec{3}(:,BWLimInd1(1):BWLimInd1(2)),2)*dfspec;
    WholeSpecEn2=sum(spec{3},2)*dfspec;
    %if dispflag disp(['MT Total Power from ' num2str(sigf-W) ' to ' num2str(sigf+W) ' Hz is: ' num2str(BandwidthEn2)]);     end
    %if dispflag disp(['MT Total Power of whole signal is: ' num2str(WholeSpecEn2)]);        end
    ConcRat3=BandwidthEn2./WholeSpecEn2;
    %if dispflag disp(['Concentration Ratio2: ' num2str(ConcRat2)]);     end
    figure
    plot(ConcRat3)
    title('ConcRat2 for 1st taper MT windowed sinusoid')
    xlabel('Time window #')
    
    startind=find(ConcRat3>=0,1,'first');
    ConcRat3(startind:startind+10)    
    mean(ConcRat3(startind:end-5))
    
%     figure
%     plot(ConcRat3,'-x')
%     hold on
%     plot(ConcRat2,'r-x')
end