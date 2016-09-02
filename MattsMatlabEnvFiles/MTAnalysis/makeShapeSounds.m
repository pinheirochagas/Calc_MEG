%makeShapeSounds.m

sigtypes={'sq','tri','saw','erp'};
sigtype=sigtypes{4};

minsigtime=30;   %sec
%minncycs=10;

plotsigflag=0;
writeflag=1;

Fs = 1000;
sigf=70;%Freq of sinusoid in Hz
sigfAmp=5;
d=minsigtime; %sec
xph=0;

t = 0:1/Fs:d;
t=t(1:end-1);

switch sigtype
    case 'sq'
        y=sigfAmp*square(2*pi*t*sigf+xph*pi/2);
        filename=['Square' num2str(sigf) 'Hz.wav'];
    case 'tri'
        y=sigfAmp*sawtooth(2*pi*t*sigf+xph*pi/2,.5);
        filename=['Tri' num2str(sigf) 'Hz.wav'];
    case 'saw'
        y=sigfAmp*sawtooth(2*pi*t*sigf+xph*pi/2);
        filename=['Saw' num2str(sigf) 'Hz.wav'];
    case 'erp'
        deadtime=10; %sec
        
        f=[10 5 2.5];
        amps=[.45 2.4714 1];    %2.4702 worked for normal smooth, 5 smooths
        phs=[0 pi 0];   %for sine waves, not cos
        halfper=1./f*Fs/2;    %# of samps
        
        clear y
        startt=1;
        for ifr=1:length(f)
            y(startt:startt+halfper(ifr)-1)=amps(ifr)*sin(2*pi*[0:1/Fs:1/Fs*(halfper(ifr)-1)]*f(ifr)+phs(ifr));
            startt=startt+halfper(ifr);
        end
        
        clear lps
        lps(1,:)=[40, 140]; %start
        lps(2,:)=[70, 225]; %end
        mps{1}=[];
        mps{2}(1,:)=[155,200];  %xvals
        mps{2}(2,:)=[.5,.85];  %yvals
        for ilp=1:size(lps,2)
            %y(lps(1,ilp):lps(2,ilp))=y(lps(1,ilp))+([lps(1,ilp):lps(2,ilp)]-lps(1,ilp))*((y(lps(2,ilp))-y(lps(1,ilp)))/(lps(2,ilp)-lps(1,ilp)));
            
            %YI = INTERP1(X,Y,XI)
            ax=lps(1,ilp);
            ay=y(lps(1,ilp));
            if ~isempty(mps{ilp})
                ax=[ax mps{ilp}(1,:)];
                ay=[ay mps{ilp}(2,:)];
            end
            ax=[ax lps(2,ilp)];
            ay=[ay y(lps(2,ilp))];
            
%             for imp=1:size(mps{ilp},2)
%                 
%             end
            
            y(lps(1,ilp):lps(2,ilp))=interp1(ax,ay,[lps(1,ilp):lps(2,ilp)],'cubic');            
                        
            nsmooths=5;
            for is=1:nsmooths
                y=smooth(y,'sgolay');
            end
            y=y';
        end
        y=[zeros(1,Fs*deadtime) y zeros(1,Fs*1)];
        
        disp(['Sum: ' num2str(sum(y))])
        filename=['ERP1.wav'];
end

if plotsigflag    
    figure;
    
    dist=max(y)-min(y);
    plot(y,'b-x')
    title(['real part of MT filtered noise. W: ' num2str(W) ';   cenf: ' num2str(sigf) ' Hz']);
    xlabel('sample #');
    axis([0 length(y) min(y)-.01*dist-.01 max(y)+.01*dist+.01])
end


if writeflag
    mainpath='/home/nelsonmj/Desktop/MatlabWork/SoundFiles/'; %'D:\PlexonData\Imp\Sounds\';
    y = .999*y/max(abs(y)); % -1 to 1 normalization
    
    wavwrite(y,Fs,[mainpath filename]);
    disp(['wrote file: ' filename ' to path: ' mainpath])
end