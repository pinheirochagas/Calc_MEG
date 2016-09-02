function ImpResp=myTF2ImpResp(Hw,HwFreqs,N,Fs)
% function ImpResp=myTF2ImpResp(Hw,HwFreqs,N,Fs)
%
% With the transfer function given by the inputs Hw and HwFreqs, this
% generates the corresponding impulse response function in the time domain.

%options
%Fs=20000;
%NFFT=20000;

%get Hwi...
Hwi=InterpTF(Hw,HwFreqs,N,Fs);

%take ifft of Hwi
ImpResp=real(ifft( Hwi ));

% figure
% plot(ImpResp)
% disp('end')




