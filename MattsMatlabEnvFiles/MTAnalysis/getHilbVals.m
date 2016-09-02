function [Amp,Freq,Ph]=getHilbVals(data,Fs,PhAdjFlag);
% function [Amp,Freq,Ph]=getHilbVals(data,Fs,PhAdjFlag);
%
% Takes the Hilbert of the input data, and from that calculates for the
% entire window the mean amplitude, overall frequency, and the initial
% phase using a linear fit to the phase angle from the Hilbert.
%   THE INITIAL PHASE DEFAULT IS TO ASSUME A COSINE WAVE (NOT SINE WAVE) AS
%   DOES ALL OF FOURIER ANALYSIS
%
% INPUTS:   data-   The raw data in a 2D array
%           Fs-     The sampling frequency to adjust the output Freq to be
%                   in units of Hz. DEFAULTS to 1, which is the equivalent 
%                   to outputting the data in radians per sample
%           PhAdjFlag-  set to 1 if you want to adjust the init phase to be
%                   equal to the phase of a sine wave to match with what
%                   was reported in previous ImpTrans methods using nlinfit of a sine wave
%                   Defults to 0
%
% INPUTS:   Amp-    The mean amplitude over the window
%           Freq-   The mean frequency in the window, (in Hz based on Fs)
%           Ph-     The initial phase, in radians


if nargin<3 PhAdjFlag=0;    end
if nargin<2 Fs=1;    end

%%%% For some reason this seems to be inaccurate when taking the Hilbert of
%%%% a matrix, so try going each row or column at a time
% Hilb=hilbert(data);
% sh=size(Hilb);
% if sh(1)>sh(2)
%     colvec=1;
%     Hilb=Hilb';
%     sh=size(Hilb);
% else    colvec=0;   end

sh=size(data);
if sh(1)>sh(2)
    colvec=1;
    data=data';
    sh=size(data);
else    colvec=0;   end
for isig=1:sh(1)
    Hilb(isig,:)=hilbert(data(isig,:));
end

%plot(data(2,:)+.002,'m')
% colvec
% size(data)
% sh

Amp=mean(abs(Hilb),2);
nsigs=sh(1);
fitx=[0:sh(2)-1];
for isig=1:nsigs
    tmpp=polyfit(fitx,unwrap(angle(Hilb(isig,:))),1);
    if tmpp(1)<0
        tmpp(1)=-tmpp(1);
        tmpp(2)=-tmpp(2);
    end
    Freq(isig)=tmpp(1);
    Ph(isig)=tmpp(2);
    %[Freq(isig) Ph(isig)]=polyfit(fitx,unwrap(angle(Hilb(isig,:))),1); %For some reason matlab didn't like this line, so I had to rewrite it as above
    
    if PhAdjFlag    
        %Ph(isig)=Ph(isig)+Freq(isig);  % This would move the phase over by one sample, but it turns out we don't need this
        Ph(isig)=Ph(isig)+pi/2; %converst to the phase for a sinusoid
    end
    while Ph(isig)>=2*pi    Ph(isig)=Ph(isig)-2*pi;  end
    while Ph(isig)<0    Ph(isig)=Ph(isig)+2*pi;  end
end

Freq=Freq'*Fs/(2*pi); %convert from rad/samp to Hz
Ph=Ph';
if colvec
    Amp=Amp';
    Freq=Freq';
    Ph=Ph';
end