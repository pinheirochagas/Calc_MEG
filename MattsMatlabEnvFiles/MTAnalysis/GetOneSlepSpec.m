function [spec,f]=GetOneSlepSpec(X,Fs,fk,plotflag,pad)
%function [spec,f]=GetOneSlepSpec(X,Fs,fk,plotflag,pad)
%
% Note- as in LFPSpec, this assumes that each trial is down each row of X
%
% This calls LFPSpec, with the inputs X, Fs (Hz) and fk- (freqs to plot in 
% Hz) to get the stationary non-moving window spectrum of X - in the form 
% of: nTr x Time using only the first Slepian taper.

if nargin<5     pad=[];     end
if nargin<4     plotflag=[];     end
if nargin<2     Fs = [];   end
if nargin<3     fk = [];   end

N=size(X,2)/Fs;
W=1/N+1e-8;
[spec,f] = LFPSpec(X,[N W],Fs, N, fk, plotflag, [], [], pad);
%LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, JustPartFlag,errType,ZTransFlag,ClusShuffOpts)

if plotflag
    figure
    %plot(f,spec);
    loglog(f,spec)
    xlabel('Freq (Hz)')
    ylabel('PSD Power/Hz')
end