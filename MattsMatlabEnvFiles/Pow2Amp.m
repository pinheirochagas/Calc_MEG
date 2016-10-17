function Amp=Pow2Amp(S)
% function Amp=Pow2Amp(S)
%
% For use with converting power spectrum values to the apmlitude of the 
% corresponding saine wave (i.e. the value a in a*sin(2*pi*f*t) which is 1 
% half of the peak to peak sine wave amplitude!) The enitre fxn is:
%
%   Amp=sqrt(S)*sqrt(2); 
%
% I only made this fxn so I don't have to try to remember how to convert
% that if I ever need to.
%
% created by MJN on 061030

Amp=sqrt(S)*sqrt(2); 