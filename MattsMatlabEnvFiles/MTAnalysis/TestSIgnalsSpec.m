%TestSignalsSpec.m

cosineonset=0;
freqswitch=0;
%filtnoise=0;
MTWinCos=1;

sigf=75;%Freq of sinusoid in Hz
sigfAmp=2.5;
xph=0;
sigf2=120;
sigf2Amp=0;
xph2=0;
NAmp=.10;

Fs = 1000;
d=1; %sec
P=1;    %For MT stuff to evaluate spectrum later; not for the MTFilter
zpad=4;

% Time vector of d seconds
t = 0:1/Fs:d;
t=t(1:end-1);

if cosineonset
    plotsigflag=1;
    
    x = sigfAmp*sin(2*pi*t*sigf+xph*pi/2);
    x=[zeros(1,length(x)) x];
    
    x2 = sigfAmp*cos(2*pi*t*sigf+xph*pi/2);
    x2=[zeros(1,length(x2)) x2];
    
    x3 = sigfAmp*cos(2*pi*t*sigf+xph*pi/2)-sigfAmp; %This d/n work b/c it has DC power
    x3=[zeros(1,length(x3)) x3];
    
    %numplotcycs=5;
    if plotsigflag
        figure
        %plot(x(1:round(Fs/sigf*numplotcycs)))
        plot(x,'b-x')
        hold on
        plot(x2,'r-x')
        plot(x3,'g-x')
    end
    
    windur=.1;
    dn=.01;
    
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    [spec{1},fspec{1}]= LFPSpec(x,[windur,P*1/windur],Fs, dn, Fs/2, 1, -d/2*1000, zpad);
    title('x- sin')
    [spec{2},fspec{2}]= LFPSpec(x2,[windur,P*1/windur],Fs, dn, Fs/2, 1, -d/2*1000, zpad);
    title('x2- cos')
    [spec{3},fspec{3}]= LFPSpec(x3,[windur,P*1/windur],Fs, dn, Fs/2, 1, -d/2*1000, zpad);
    title('x3- shifted cos')
    
    W=P*1/windur;
    
    clear ConcRat BandwidthEn WholeSpecEn
    figure
    hold on
    plotopts={'b-x','r-x','g-x'};
    for isig=1:3
        BWLimInd1(isig,1)=find(fspec{isig}>sigf-W,1,'first');
        BWLimInd1(isig,2)=find(fspec{isig}<sigf+W,1,'last');
        dfspec=fspec{isig}(2)-fspec{isig}(1);
        BandwidthEn(isig,:)=sum(spec{isig}(:,BWLimInd1(isig,1):BWLimInd1(isig,2)),2)*dfspec;
        WholeSpecEn(isig,:)=sum(spec{isig},2)*dfspec;
        %if dispflag disp(['MT Total Power from ' num2str(sigf-W) ' to ' num2str(sigf+W) ' Hz is: ' num2str(BandwidthEn2)]);     end
        %if dispflag disp(['MT Total Power of whole signal is: ' num2str(WholeSpecEn2)]);        end
        ConcRat(isig,:)=BandwidthEn(isig,:)./WholeSpecEn(isig,:);

        %if dispflag disp(['Concentration Ratio2: ' num2str(ConcRat2)]);     end
        plot(ConcRat(isig,:),plotopts{isig})
        title('ConcRat2 for 1st taper MT windowed sinusoid')
        xlabel('Time window #')
    end
    
    HilbCheck=1;
    if HilbCheck
        Hx=hilbert(x);
        figure
        subplot(2,1,1)
        plot(abs(Hx));
        title(['Hilbert Mag of a ' num2str(sigf) 'Hz Sine Wave Onset']);
        xlabel('sample #');
        
        subplot(2,1,2);
        plot(diff(angle(Hx))*Fs/(2*pi));  %instantaneous freq.
        title(['Hilbert Inst. Freq. of a ' num2str(sigf) 'Hz Sine Wave Onset']);
        xlabel('sample #');
        ylabel('Frequency (Hz)');
    end
end

if freqswitch
    plotsigflag=1;
    
    x = sigfAmp*sin(2*pi*t*sigf+xph*pi/2);
    tx= sigf2Amp*sin(2*pi*t*sigf2+xph2*pi/2);
    x=[x tx];
    
    %numplotcycs=5;
    if plotsigflag
        figure
        %plot(x(1:round(Fs/sigf*numplotcycs)))
        plot(x)
    end
    
    windur=.1;
    dn=.01;
    
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    [spec{2},fspec{2}]= LFPSpec(x,[windur,P*1/windur],Fs, dn, Fs/2, 1, -d/2*1000, zpad);
end


if MTWinCos
    plotsigflag=1;
    dispflag=1;
    
    x = sigfAmp*sin(2*pi*t*sigf+xph*pi/2);
    x2 = sigfAmp*sin(2*pi*t*sigf+(xph+.5)*pi/2);
    
    tapers = dpsschk([d*Fs 1 1]);
    win=tapers';
    x=x.*win;
    x=[zeros(1,length(x)) x];   %(1:end-250)
    x2=x2.*win;
    x2=[zeros(1,length(x2)) x2];    %(1:end-250)
    
    Noise=NAmp*randn(1,length(x));
    
    x=x+Noise;
    x2=x2+Noise;     %make each have the same noise
    
    %numplotcycs=5;
    if plotsigflag
        figure
        %plot(x(1:round(Fs/sigf*numplotcycs)))
        plot(x)
    end
    
    windur=.1;
    dn=.01;
    
    %[spec,f,N,dn,nwin,err] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, pad, pval, flag);
    [spec{1},fspec{1}]= LFPSpec(x,[windur,P*1/windur],Fs, dn, Fs/2, 1, -d/2*1000, zpad);
    
    W=P*1/windur;
    
    BWLimInd1(1)=find(fspec{1}>sigf-W,1,'first');
    BWLimInd1(2)=find(fspec{1}<sigf+W,1,'last');
    dfspec=fspec{1}(2)-fspec{1}(1);
    BandwidthEn2=sum(spec{1}(:,BWLimInd1(1):BWLimInd1(2)),2)*dfspec;
    WholeSpecEn2=sum(spec{1},2)*dfspec;
    %if dispflag disp(['MT Total Power from ' num2str(sigf-W) ' to ' num2str(sigf+W) ' Hz is: ' num2str(BandwidthEn2)]);     end
    %if dispflag disp(['MT Total Power of whole signal is: ' num2str(WholeSpecEn2)]);        end
    ConcRat2=BandwidthEn2./WholeSpecEn2;
    %if dispflag disp(['Concentration Ratio2: ' num2str(ConcRat2)]);     end
    figure
    plot(ConcRat2)
    title('ConcRat2 for 1st taper MT windowed sinusoid')
    xlabel('Time window #')
    
    HilbCheck=1;
    if HilbCheck
        Hx=hilbert(x);
        Hx2=hilbert(x2);
        figure
        subplot(3,1,1)
        plot(abs(Hx));
        title(['Hilbert Mag of a ' num2str(sigf) 'Hz Sine Wave Onset']);
        xlabel('sample #');
        
        subplot(3,1,2);
        plot(diff(angle(Hx))*Fs/(2*pi));  %instantaneous freq.
        title(['Hilbert Inst. Freq. of a ' num2str(sigf) 'Hz Sine Wave Onset']);
        xlabel('sample #');
        ylabel('Frequency (Hz)');
        
        subplot(3,1,3);
        plot((angle(Hx2)-angle(Hx))*180/pi);  %instantaneous freq.
        title(['Relative Phase of two ' num2str(sigf) 'Hz simultaneous Sine Wave Onsets']);
        xlabel('sample #');
        ylabel('Phase (deg)');
        
        rph=(angle(Hx2)-angle(Hx))*180/pi;
        tmpph=rph(1025:end-1);
        tmpind=find(tmpph<0);
        tmpph(tmpind)=tmpph(tmpind)+360;
        disp(['Overall phase difference: ' num2str(mean(tmpph)) ' degrees'])
    end
end