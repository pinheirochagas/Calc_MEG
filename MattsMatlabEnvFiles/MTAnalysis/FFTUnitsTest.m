% This involves specififc code from: http://www.mathworks.com/support/tech-notes/1700/1702.html

%What we will actually do is look at the max of the mean-square power
%spectrum obtained via a heavily zero-padded FFT

%FFTUnitsTest.m
HilbCheck=0;
FFTCheck=1;
MTCheck=1;
ChronCheck=1;
MatlabCheck=1;
PerCheck=1;
%if iit==1   plotflag=0;  else    plotflag=0;  end
plotflag=0;
dispflag=1;
getxfromspec=0;
FiltSigFlag=0;  %If not getting the signal from the spectrum, this will determine whether or not to filter the signal with an MTfilter

%if iit==1   plotsigflag=0;  else    plotsigflag=0;  end
plotsigflag=0;

% Sampling frequency
Fs = 1000;
d=1; %sec
P=3;    %For MT stuff to evaluate spectrum later; not for the MTFilter
zpad=2;

    %sqrt(2)*64 ~ 90.5
sigf=sqrt(2)*64; %Freq of sinusoid in Hz.... Make this a weird decimal (or an irrational number) to guarantee it doesn't fall exactly on one of the items
d=50/sigf;  %To generate 50 cycles worth of data...

sigfAmp=1;
%xph=.555; %this is multiplied by pi/2 later... so in essence this is in units of pi/2...
xph=2*rand;

sigf2=198.3826;
sigf2Amp=0;
xph2=1;
NAmp=0.1;

%filtP=1;
%filtK=2*filtP-1;
filtW=5;

filtf=sigf;

%%%%%%%% N,  W   K
otapers=[d,P*1/d,5];    %This is set to have P=3, not W=3
W=otapers(2);
tapers=otapers;
ntapers=3;

zoomWRat=1.4;

% Time vector of d seconds
t = 0:1/Fs:d;
t=t(1:end-1);

if ~getxfromspec
    % Create a sine wave of f Hz and add some noise
    x = sigfAmp*cos(2*pi*t*sigf+xph*pi/2) + NAmp*randn(1,length(t))+ sigf2Amp*cos(2*pi*t*sigf2+xph2*pi/2);

    if FiltSigFlag
        %x=mtfilter(x,[d,filtP,filtK],Fs,filtf);
        x=mtfilter(x,[d,filtW],Fs,filtf);
    end
else
    BWPh=pi/4;  %in radians
    BWMag=10;   %This will be the PSD value

    %For now make true spectrum a top-hat fxn
    %NFFT= zpad*2^(nextpow2(length(t))); %we can assume that this is always even, so I will
    NFFT=length(t);
    NumUniquePts = ceil((NFFT+1)/2);
    f = (0:NumUniquePts-1)*Fs/NFFT;
    NFFT

    BWLimInd1(1)=find(f>sigf-W,1,'first');
    BWLimInd1(2)=find(f<sigf+W,1,'last');
    
    SxMag=zeros(1,NumUniquePts);        
    SxPh=zeros(1,NumUniquePts);
    SxMag(BWLimInd1(1):BWLimInd1(2))=BWMag;
    SxPh(BWLimInd1(1):BWLimInd1(2))=BWPh;
    
    %Here we're going to undo all the scaling we do after taking the FFT
    tmpSx=SxMag;
    tmpSx=tmpSx*Fs;
    if ~rem(NFFT,2) % Nyquist component should also be unique.
        % Here NFFT is even; therefore,Nyquist point is included.
        tmpSx(end) = tmpSx(end)*2;
    end
    
    % DC Component should be unique.
    tmpSx(1) = tmpSx(1)*2;
    
    % Multiply by 2 because you threw out second half of FFTX above
    tmpSx = tmpSx/2;
    
    % Take the square of the magnitude of fft of x.
    tmpSx = sqrt(tmpSx);
    
    % Scale the fft so that it is not a function of the length of x
    tmpSx = tmpSx*length(t);  %This assumes a reSctangular window was done to derive the spectrum
    
    % Undo taking the magnitude of fft of x, i.e. include phase information
    tmpSx=tmpSx.*exp(j*SxPh);
    
    % FFT is symmetric, throw away second half
    tmpSx= [tmpSx revorder(tmpSx(2:end-1))];
    
    x=ifft(tmpSx,NFFT);
        
    if plotsigflag
        figure
        subplot(3,1,1);
        ay=abs(x);
        dist=max(ay)-min(ay);
        plot(ay)
        title(['abs of signal from boxcar spectrum W: ' num2str(W) ';   cenf: ' num2str(sigf) ' Hz']);
        xlabel('sample #');
        axis([0 Fs*d min(ay)-.01*dist max(ay)+.01*dist])

        subplot(3,1,2);
        ry=real(x);
        dist=max(ry)-min(ry);
        plot(ry)
        title(['real part of signal from boxcar spectrum W: ' num2str(W) ';   cenf: ' num2str(sigf) ' Hz']);
        xlabel('sample #');
        axis([0 Fs*d min(ry)-.01*dist max(ry)+.01*dist])

        subplot(3,1,3);
        iy=imag(x);
        dist=max(iy)-min(iy);
        plot(iy)
        title(['imag part of signal from boxcar spectrum W: ' num2str(W) ';   cenf: ' num2str(sigf) ' Hz']);
        xlabel('sample #');
        if dist>0    axis([0 Fs*d min(iy)-.01*dist max(iy)+.01*dist]);  end
        
        plotsigflag=0;
    end
      
    zoomflag=1;
    if plotflag
        figure
        subplot(2,1,1);
        plot(f,SxMag,'-x');
        title(['Input Power Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
        xlabel('Frequency (Hz)');
        ylabel('Power');
        if zoomflag     axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(SxMag)*1.05]);    end

        subplot(2,1,2);
        plot(f,SxPh,'-x');
        title(['Input phase Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
        xlabel('Frequency (Hz)');
        ylabel('phase');
        if zoomflag     axis([sigf-W*zoomWRat sigf+W*zoomWRat -180 180]);     end
        hold on
        plot([f(1) f(end)], [0 0],':r')
    end
    
end

x=real(x);

if HilbCheck
    [HilbAmp,HilbFreq,HilbPh]=getHilbVals(x,Fs);
    HilbPh=GetAngDiff(HilbPh*180/pi,xph*90);
%     HilbPh=HilbPh*180/pi-xph*90;
%     if HilbPh<-180 HilbPh=HilbPh+360;    
%     elseif HilbPh>180 HilbPh=HilbPh-360;   end
end

if FFTCheck
    clear FFTX
    
    zoomflag=1;
    %plotsigflag=1;
    numplotcycs=5;
    if plotsigflag
        figure
        plot(x(1:Fs/sigf*numplotcycs))
    end
    
    usewin=1;
    useMTwin=0;
    
    % Use next highest power of 2 greater than or equal to
    % length(x) to calculate FFT.
    NFFT= zpad*2^(nextpow2(length(x)));
    
    %NFFT=length(x);
    %NFFT=1024*16;
    if dispflag     disp(['NFFT: ' num2str(NFFT)]);     end

    % Take fft, padding with zeros so that length(FFTX) is equal to NFFT
    if usewin
        if useMTwin            
            if tapers(3)> floor(2*tapers(1)*tapers(2)-1) %this adjusts k automatically and notifies the user if they enter a value for k larger than the usable amount
                disp(['Had to decrease number of tapers from: ' num2str(tapers(3)) ' to 2*n*w-1, which is: ' num2str(floor(2*tapers(1)*tapers(2)-1))])
                tapers(3)=floor(2*tapers(1)*tapers(2)-1);
            end
            tapers(2)=tapers(2)*tapers(1);  %convert to [n,p,k] form for dpsschk and matlab's dpss
            tapers(1) = tapers(1).*Fs; %# of samples in window

            if ~isint(tapers(1))
                tapers(1)=round(tapers(1));
                disp(['Had to adjust window length to ' num2str(tapers(1)) ' samples for a ' num2str(tapers(1)/sampling*1e3) ' msec window.'])
            end
            tapers = dpsschk(tapers);   %Note: These are already normalized to have a total energy of one
            %                               i.e. sum(tapers.^2,1) = 1 for each taper (with each down each column of tapers)
            %if scale    % But we may want sum(tapers)=1, which is the
            %equivalent of dividing by the number of samples at the end
            %    tmpsum=sum(tapers);
            %    for it=1:size(tapers,2) tapers(:,it)=tapers(:,it)/tmpsum(it);   end
                %sum(tapers)
            %end
            win=tapers';
            %size(win)
            %return
            
            for it=1:size(win,1)
                FFTX(it,:) = fft(x.*win(it,:),NFFT);
            end
            FFTX2=mean(FFTX);    %to get the phase angle
        else    
            win = 1/length(x)*ones(1,length(x));
            if dispflag     disp(['length x is: ' num2str(length(x)) '; constant win value is: ' num2str(win(1))]);     end
            FFTX = fft(x.*win,NFFT);
            FFTX2 = FFTX;
        end
    else
        FFTX = fft(x,NFFT);
        FFTX2 = FFTX;
    end

    % Calculate the numberof unique points
    NumUniquePts = ceil((NFFT+1)/2);

    % FFT is symmetric, throw away second half
    FFTX = FFTX(:,1:NumUniquePts);
    FFTX2 = FFTX2(:,1:NumUniquePts);

    % Take the magnitude of fft of x
    MX = abs(FFTX);
    AngX=angle(FFTX2)*180/pi;
        
    % Scale the fft so that it is not a function of the
    % length of x
    if ~usewin  MX = MX/length(x);  %I think this is for the power spectrum calculation, not the PSD...
%     else    
%         U=1/length(x)*sum(win.^2);
%             %It seems like doing this after the 
    end

    % Take the square of the magnitude of fft of x.
    MX = MX.^2;
    
    if(size(win,1)>1)   MX=mean(MX);    end

    % Multiply by 2 because you
    % threw out second half of FFTX above
    MX = MX*2;

    % DC Component should be unique.
    MX(1) = MX(1)/2;

    % Nyquist component should also be unique.
    if ~rem(NFFT,2)
        % Here NFFT is even; therefore,Nyquist point is included.
        MX(end) = MX(end)/2;
    end

    if usewin & useMTwin    MX=MX/Fs;   end
    
    % This is an evenly spaced frequency vector with
    % NumUniquePts points.
    f = (0:NumUniquePts-1)*Fs/NFFT;

    AmpX=sqrt(MX)*sqrt(2);  %Or could do AmpX=Pow2Amp(MX)
    [temp,maxind]=max(MX);
    Ph=GetAngDiff(AngX(maxind),xph*90);
    %Ph=AngX(maxind)-xph*90;
    %if Ph<-180 Ph=Ph+360;    
    %elseif Ph>180 Ph=Ph-360;   end
    FFTAmp=AmpX(maxind);
    FFTFreq=f(maxind);
    if dispflag     
        disp(['Amp at Max spec is: ' num2str(FFTAmp)]);
        disp(['Phase at Max spec is: ' num2str(Ph) ' degrees']);    
        disp(['Freq at Max spec is: ' num2str(FFTFreq) ' Hz']);
    end
    
    dfFFT=f(2)-f(1);
    BandWidthLimInd1(1)=find(f>sigf-W,1,'first');
    BandWidthLimInd1(2)=find(f<sigf+W,1,'last');
    BandwidthEn1=sum(MX(BandWidthLimInd1(1):BandWidthLimInd1(2)))*dfFFT;
    WholeSpecEn1=sum(MX)*dfFFT;
    if dispflag     disp(['FFT Total Energy* from ' num2str(sigf-W) ' to ' num2str(sigf+W) ' Hz is: ' num2str(BandwidthEn1)]);      end
    if dispflag     disp(['FFT Total Energy* of whole signal is: ' num2str(WholeSpecEn1)]);     end
    ConcRat1=BandwidthEn1/WholeSpecEn1;
    if dispflag     disp(['Concentration Ratio1: ' num2str(ConcRat1)]);     end

    % Generate the plot, title and labels.
    if plotflag
        figure
        subplot(3,1,1);
        plot(f,MX,'-x');
        title(['Power Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
        xlabel('Frequency (Hz)');
        ylabel('Power');
        if zoomflag     axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(MX)*1.05]);    end
        subplot(3,1,2);
        plot(f,AmpX,'-x');
        title(['Amplitude Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
        if zoomflag     axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(AmpX)*1.05]);     end
        subplot(3,1,3);
        plot(f,AngX,'-x');
        title(['phase of a ' num2str(sigf) 'Hz Sine Wave']);
        xlabel('Frequency (Hz)');
        ylabel('phase');
        if zoomflag     axis([sigf-W*zoomWRat sigf+W*zoomWRat -180 180]);     end
        hold on
        plot([f(1) f(end)], [0 0],':r')
    end
end



if MTCheck
    zoomflag=0;
    tapers=otapers;
    tapers(3)=ntapers;
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    [spec,F]=LFPSpec(x,tapers,Fs, d, Fs/2,0);
    dfMT=F(2)-F(1);
    BandWidthLimInd2(1)=find(F>sigf-W,1,'first');
    BandWidthLimInd2(2)=find(F<sigf+W,1,'last');
    BandwidthEn2=sum(spec(BandWidthLimInd2(1):BandWidthLimInd2(2)))*dfMT;
    WholeSpecEn2=sum(spec)*dfMT;
    if dispflag disp(['MT Total Power from ' num2str(sigf-W) ' to ' num2str(sigf+W) ' Hz is: ' num2str(BandwidthEn2)]);     end
    if dispflag disp(['MT Total Power of whole signal is: ' num2str(WholeSpecEn2)]);        end
    ConcRat2=BandwidthEn2/WholeSpecEn2;
    if dispflag disp(['Concentration Ratio2: ' num2str(ConcRat2)]);     end
    
    figure
    subplot(2,1,1)
    plot(F,spec,'-x');
    title(['MT Power Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
    xlabel('Frequency (Hz)');
    ylabel('Power');
    if zoomflag    axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(spec)*1.05]);     end
    subplot(2,1,2)
    Ampspec=Pow2Amp(spec);
    plot(F,Ampspec,'-x');
    title(['MT Amplitude Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    if zoomflag axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(Ampspec)*1.05]);     end
end


if ChronCheck
    zoomflag=0;   
    params.pad=2;
    params.tapers=[W*d ntapers];
    params.Fs=Fs;
    
    [S,tChron,fChron]=mtspecgramc(x',[d d],params);
    S=2*S;
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    %[spec,F]=LFPSpec(x,tapers,Fs, d, 500,0);
    dfChron=fChron(2)-fChron(1);
    BandWidthLimInd3(1)=find(fChron>sigf-W,1,'first');
    BandWidthLimInd3(2)=find(fChron<sigf+W,1,'last');
    BandwidthEn3=sum(S(BandWidthLimInd3(1):BandWidthLimInd3(2)))*dfChron;
    WholeSpecEn3=sum(S)*dfChron;
    if dispflag     disp(['Chron Total Power from ' num2str(sigf-W) ' to ' num2str(sigf+W) ' Hz is: ' num2str(BandwidthEn3)]);      end
    if dispflag     disp(['Chron Total Power of whole signal is: ' num2str(WholeSpecEn3)]);     end
    ConcRat3=BandwidthEn3/WholeSpecEn3;
    if dispflag    disp(['Concentration Ratio3: ' num2str(ConcRat3)]);      end
    figure
    subplot(2,1,1)
    plot(fChron,S,'-x');
    title(['Chron MT Power Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
    xlabel('Frequency (Hz)');
    ylabel('Power');
    if zoomflag    axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(S)*1.05]);     end
    subplot(2,1,2)
    AmpspecChron=Pow2Amp(S);
    plot(fChron,AmpspecChron,'-x');
    title(['Chron MT Amplitude Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    if zoomflag axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(AmpspecChron)*1.05]);     end
end

if MatlabCheck
    zoomflag=0;   
    params.pad=2;
    params.tapers=[W*d ntapers];
    params.Fs=Fs;
    
    [Pxx,fMatlab]=pmtm(x,{P},NFFT,Fs);
    dfMatlab=fMatlab(2)-fMatlab(1);
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    %[spec,F]=LFPSpec(x,tapers,Fs, d, 500,0);
    BandWidthLimInd4(1)=find(fMatlab>sigf-W,1,'first');
    BandWidthLimInd4(2)=find(fMatlab<sigf+W,1,'last');
    BandwidthEn4=sum(Pxx(BandWidthLimInd4(1):BandWidthLimInd4(2)))*dfMatlab;
    WholeSpecEn4=sum(Pxx)*dfMatlab;
    if dispflag     disp(['Matlab Total Power from ' num2str(sigf-W) ' to ' num2str(sigf+W) ' Hz is: ' num2str(BandwidthEn4)]);     end
    if dispflag     disp(['Matlab Total Power of whole signal is: ' num2str(WholeSpecEn4)]);        end
    ConcRat4=BandwidthEn4/WholeSpecEn4;
    if dispflag     disp(['Concentration Ratio4: ' num2str(ConcRat4)]);     end
    figure
    subplot(2,1,1)
    plot(fMatlab,Pxx,'-x');
    title(['Matlab MT Power Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
    xlabel('Frequency (Hz)');
    ylabel('Power');
    if zoomflag    axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(Pxx)*1.05]);     end
    subplot(2,1,2)
    Axx=Pow2Amp(Pxx);
    plot(fMatlab,Axx,'-x');
    title(['Matlab MT Amplitude Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    if zoomflag axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(Axx)*1.05]);     end
end

if PerCheck
    zoomflag=1;   
    params.pad=2;
    params.tapers=[W*d ntapers];
    params.Fs=Fs;
    win = 1/length(x)*ones(1,length(x));
    
    [PxxPer,fPer] = periodogram(x,win,NFFT,Fs,'psd');
    dfPer=fPer(2)-fPer(1);
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    %[spec,F]=LFPSpec(x,tapers,Fs, d, 500,0);
    BandWidthLimInd5(1)=find(fPer>sigf-W,1,'first');
    BandWidthLimInd5(2)=find(fPer<sigf+W,1,'last');
    BandwidthEn5=sum(PxxPer(BandWidthLimInd5(1):BandWidthLimInd5(2)))*dfPer;
    WholeSpecEn5=sum(PxxPer)*dfPer;
    if dispflag     disp(['Per Total Power from ' num2str(sigf-W) ' to ' num2str(sigf+W) ' Hz is: ' num2str(BandwidthEn5)]);        end
    if dispflag     disp(['Per Total Power of whole signal is: ' num2str(WholeSpecEn5)]);       end
    ConcRat5=BandwidthEn5/WholeSpecEn5;
    if dispflag     disp(['Concentration Ratio5: ' num2str(ConcRat5)]);     end
    figure
    subplot(2,1,1)
    plot(fPer,PxxPer,'-x');
    title(['Per Power Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
    xlabel('Frequency (Hz)');
    ylabel('Power');
    if zoomflag    axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(PxxPer)*1.05]);     end
    subplot(2,1,2)
    AxxPer=Pow2Amp(PxxPer);
    plot(fPer,AxxPer,'-x');
    title(['Per Amplitude Spectrum of a ' num2str(sigf) 'Hz Sine Wave']);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    if zoomflag axis([sigf-W*zoomWRat sigf+W*zoomWRat -.1 max(AxxPer)*1.05]);     end
end
    
if FFTCheck && dispflag
    if MTCheck  disp(['MT/FFT Whole En ratio: ' num2str(WholeSpecEn2/WholeSpecEn1)]);    end
    if ChronCheck   disp(['Chron/FFT Whole En ratio: ' num2str(WholeSpecEn3/WholeSpecEn1)]); end
    if MatlabCheck   disp(['Matlab/FFT Whole En ratio: ' num2str(WholeSpecEn4/WholeSpecEn1)]); end
    if PerCheck     disp(['PSD/MX =: ' num2str(PxxPer(1:5)'./MX(1:5))]); end
end

