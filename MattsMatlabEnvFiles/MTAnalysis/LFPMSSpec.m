function [Px,F,Psdx] = LFPMSSpec(X, Fs, fk, plotflag, pad)
% function [Px,F,Psdx] = LFPMSSpec(X, Fs, fk, plotflag, pad)
%
% Calculates the mean-square power spectrum (not the psd) of a 1D input 
% data vector X using the first multi-taper window. Uses dpss and
% periodogram.
% 
% The available options are similar to their usage in LFPSpec.

FSPadFlag=0;    % Set to 1 if you want the number of points in the FFT to be a the next power of 2 "relative to multiple of the Sampling rate in Hz rather than always a power of 2. 
                % The advantage of this is that the specific frequency measurements you make will be done at more round numbers.
                % The disadvantage is that if Fs is not a power of 2, this means the FFT algorithm will run more slowly
if nargin < 5 || isempty(pad);  pad = 4;    end
if nargin < 4 || isempty(plotflag);  plotflag=0; end
if nargin<2 || isempty(Fs);     Fs = 1000;   end

if nargin<3 || isempty(fk);  fk = [0,Fs/2]; end
if length(fk) == 1
    fk = [0,fk];
end
if fk(2)>Fs/2  fk(2)=Fs/2;   end

N=length(X);
if FSPadFlag    nf = max(Fs*2^nextpow2(256/Fs), Fs*pad*2^nextpow2(N/Fs));
else    nf = max(256, pad*2^nextpow2(N+1));     end %# of points for FFT

%win=dpss(N, 1+1e-8,1);
win=ones(size(X));
[Px,F]=periodogram(X,win,nf,Fs,'ms');
Psdx=periodogram(X,win,nf,Fs,'psd');

if plotflag
    figure    
    loglog(F,Px)
end