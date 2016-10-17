%function makeMTFiltSigs(sigf)

%sigf=1000;
deadtime=[10 5]; %sec    %was 10 3; or could be [1 1] if you want to add zeros first before doing the MT filtering
%minsigtime=.2;   %sec    %was 5 ***Keep this at 2, we'll rely on that fact for analysis later
minsigtime=2*filtd;
minncycs=10;
filtW=2;

%filter options for MT filt
%filtd=d/2;
%testnum='2';
%filtd=.005;
%filtP=2.5; %filtd*filtW;   %filtP is what is used later, not filtW
filtP=1; %... P is the same as N*W for the tapers
filtK=2*filtP-1;

df=2;   %fft vals, not in Hz --- for dumb filt

dumbfilt=0; %MT filt generally turns out to be a little bit better, and have the nice property of being time-limited...
filtpulse=1;
nofiltflag=0;
MTwinflag=0;
Triwinflag=0;   %This doesn't work very well
MatlabCheck=0;
plothilbflag=0;
plotsigflag=0;
timespeccheck=0;
writeflag=1;
cosadjflag=0;   %this turns out to be a bad way to do things; so don't use it
purecosend=0;

addzerosfirst=0;     %also don't do this as the signal gets spread out over the zeros
%Fs = 40000; %40000;
%sigf=50;%Freq of sinusoid in Hz
d=minsigtime; %sec
cyclen=1/sigf*Fs;   %number of samps
%numcycs=d*Fs/cyclen;
numcycs=d*sigf;

if ~isint(cyclen)
    %error(['cyclen is: ' num2str(cyclen) ' and needs to be an integer'])
elseif rem(cyclen,2) && cosadjflag
    error(['cyclen is: ' num2str(cyclen) ' and needs to be even'])
end

if ~isint(numcycs)
    %error(['numcycs is: ' num2str(numcycs) ' and needs to be an integer'])
end

P=1;  %The P you use to investigate the data later
xph=0;
zpad=4;
sigf2=sigf;
sigf2Amp=5;
xph2=0;

zoomWRat=2.4;

t = 0:1/Fs:d;
t=t(1:end-1);

%x=randn(1,d*Fs);
%x=ones(1,d*Fs);
if cosadjflag    
    x=sigf2Amp*cos(2*pi*t*sigf2+xph2*pi/2);
    halfcyclen=cyclen/2;   %number of samps
    x(1:halfcyclen)=sigf2Amp/2*cos(2*pi*t(1:halfcyclen)*sigf2+xph2*pi/2)-sigf2Amp/2;
    x(end-halfcyclen+1:end)=sigf2Amp/2*cos(2*pi*t(end-halfcyclen+1:end)*sigf2+xph2*pi/2)-sigf2Amp/2;    
elseif filtpulse
    x=zeros(1,length(t));
    x(round(length(t)/2))=sigf2Amp;
else
    x=sigf2Amp*sin(2*pi*t*sigf2+xph2*pi/2);
end


if cosadjflag || MTwinflag
    if Triwinflag
        win(1:round(length(x)/2))=linspace(0,sigf2Amp,round(length(x)/2));
        nrem=length(x)/2-round(length(x)/2);
        win(round(length(x)/2)+1:end)=linspace(0,sigf2Amp,nrem);
    else
        tapers = dpsschk([d*Fs 1 1]);
        win=tapers';
    end
    y=x.*win;
elseif ~nofiltflag
    if addzerosfirst    x=[zeros(1,Fs*deadtime(1)) x zeros(1,Fs*deadtime(2))];  end
    if dumbfilt        
        
%         lf = sigf-df;   % lowest frequency
%         hf = sigf+df;   % highest frequency
%         lp = lf * d; % ls point in frequency domain    
%         hp = hf * d; % hf point in frequency domain
        
        cp=sigf*d;
        lp=cp-df;
        hp=cp+df;
        n=length(x);
        
        filter = zeros(1, n);           % initializaiton by 0
        filter(1, lp : hp) = 1;         % filter design in real number
        filter(1, n - hp : n - lp) = 1; % filter design in imaginary number
        
        s = fft(x);                  % FFT
        s = s .* filter;                 % filtering
        s = ifft(s);                     % inverse FFT
        y = real(s);        
        
    else    y=mtfilter(x,[filtd,filtP,filtK],Fs,sigf);  end
else    y=x;
end


if purecosend
    Hy=hilbert(y);
    Hsampcen=1/sigf/2*Fs;   %?I forget why exactly I used this as the sample center
    samplen=10;
    minexttime=.100; %sec
    numextcycs=15;
    
    numextcycs=max(ceil(minexttime/(1/sigf)),numextcycs);
    nd=numextcycs*1/sigf;
    nt=0:1/Fs:nd-1/Fs;
    
    if ~nofiltflag
        tmpamp=mean(abs(Hy(end-round(Hsampcen+samplen/2):end-round(Hsampcen-samplen/2))));
    else
        tmpamp=sigf2Amp;
    end
    y=[y tmpamp*sin(2*pi*nt*sigf2+xph2*pi/2)];
    
    if plotsigflag
        figure
        plot(y(end-cyclen*(numextcycs+2):end))
        title(['end of sig after adding ' num2str(numextcycs) ' pure cos. cycles'])
    end
end

if plotsigflag
    if filtpulse
        figure
        plot(y)
    else
        figure
        subplot(2,1,1)
        plot(x(1:cyclen*5))
        subplot(2,1,2)
        plot(y(1:cyclen*5))
        title(['beginning of sig before and after MTFilt'])
    end
end

if ~addzerosfirst   y=[zeros(1,Fs*deadtime(1)) y zeros(1,Fs*deadtime(2))];  end
%W=filtP/filtd

y=y+.00*randn(1,length(y));
W=filtW;

if plotsigflag && ~filtpulse 
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

if plothilbflag
    Hy=hilbert(y);
    figure
    subplot(2,1,1)
    plot(abs(Hy));
    title(['Hilbert Mag of a ' num2str(sigf) 'Hz MTFilt Sine Wave Onset']);
    xlabel('sample #');

    subplot(2,1,2);
    plot(diff(angle(Hy))*Fs/(2*pi));  %instantaneous freq.
    title(['Hilbert Inst. Freq. of a ' num2str(sigf) 'Hz MTFilt Sine Wave Onset']);
    xlabel('sample #');
    ylabel('Frequency (Hz)');
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
    disp('checking spectrum')
    windur=.1;
    dn=.01;
    fkwidth=250; %Hz
    fk(1)=max(0,sigf-fkwidth);
    fk(2)=min(Fs/2,sigf+fkwidth);
    
    clear spec fspec
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    [spec{3},fspec{3}]= LFPSpec(y,[windur,P*1/windur],Fs, dn, fk, 1, -d*1000, zpad);
    
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
    endind=find(ConcRat3>=0,1,'last');
    ConcRat3(startind:startind+10)    
    mean(ConcRat3(startind:endind))
    
%     figure
%     plot(ConcRat3,'-x')
%     hold on
%     plot(ConcRat2,'r-x')
end

if writeflag
    mainpath='C:\MATLAB7\work\Imp\MTAnalysis\SoundFiles\filtpulses\';
    %mainpath='/home/nelsonmj/Desktop/MatlabWork/SoundFiles/'; %'D:\PlexonData\Imp\Sounds\';
    y = .999*y/max(abs(y)); % -1 to 1 normalization
    filename=['Pul' pulnum 'MTFilt' num2str(sigf) 'Hz.wav'];
    wavwrite(y,Fs,[mainpath filename]);
    disp(['wrote file: ' filename ' to path: ' mainpath])
end
    