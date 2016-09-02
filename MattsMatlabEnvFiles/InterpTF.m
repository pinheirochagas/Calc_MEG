function Hwi=InterpTF(Hw,HwFreqs,NFFT,Fs)
% function Hwi=InterpTF(Hw,HwFreqs,NFFT,Fs)
%
% With the transfer function given by the inputs Hw and HwFreqs, this
% will generate an interpolated transfer function, Hwi, of length NFFT, 
% given sampling freq Fs
%
% Note- this will give the symmetric full spectrum- neg and pos freqs- for
% with calcs in the freq domain and with signals FFT...

%options
if nargin<4 || isempty(Fs)        Fs=20000;     end
if nargin<3 || isempty(NFFT)        NFFT=20000;     end

extrap=0;
methods={'nearest', ... % - nearest neighbor interpolation
      'linear' ...  %  - linear interpolation
      'spline' ...  %  - piecewise cubic spline interpolation (SPLINE)
      'pchip' ...   %  - shape-preserving piecewise cubic interpolation
      'cubic'};     %  - same as 'pchip'
InterpMnum=4;       %which of the above methods you want to use to interpolate; i.e. 4 refers to pchip

%pre-calcs
NumUniquePts = ceil((NFFT+1)/2);
f = (0:NumUniquePts-1)*Fs/NFFT;

tmpY=Hw;
tmpX=HwFreqs;
if ~extrap
    if tmpX(1)>0
        tmpY=[0.00001*exp(1i*angle(tmpY(1))) tmpY];          
        tmpX=[0 tmpX];          %try keeeping angle the same as tmpY(1) and make mag 0.001 or something
    end    
    if tmpX(end)<f(end)
        tmpY=[tmpY 0.00001*exp(1i*angle(tmpY(end)))];
        tmpX=[tmpX f(end)];
    end
end

%get Hwi
tmpm = interp1(tmpX,abs(tmpY),f,methods{InterpMnum},'extrap');
tmpr = interp1(tmpX,real(tmpY),f,methods{InterpMnum},'extrap');
tmpi = interp1(tmpX,imag(tmpY),f,methods{InterpMnum},'extrap');
tmpph=angle(tmpr+tmpi*1i);        %This seems to work best if you get the phase from interpolating the real and imag components, and the magnitude from interpolating the magnitude itself

Hwi=tmpm.*exp(1i*tmpph);

%add the second part of the filter spectrum for a symmetric spectrum (from a real filter)
if ~rem(NFFT,2) % Here NFFT is even; therefore,Nyquist point is included.
    Hwi=[Hwi(1) Hwi(2:end-1) Hwi(end) conj(Hwi([length(Hwi)-1:-1:2]))]; %the complex conjugate will negate the phase for all frequencies above the Nyquist
else
    Hwi=[Hwi(1) Hwi(2:end) conj(Hwi([length(Hwi):-1:2]))]; %the complex conjugate will negate the phase for all frequencies above the Nyquist
end


