function [Spec,f,err] = SpikeSpec(Spike,tlength,plotflag)
%
%   [Spec,f,err] = SpikeSpectrum(Spike)
%       derived from sessSpectrum
%
%   INPUTS: 
%       Spike	=  Array in spike times in ms. The program converts those 
%                   times into dN form (from Jarvis and Mitra) where the 
%                   value of Spike should be 0 for every 1 ms time bin that
%                   doesn't have a spike, and 1 for every 1 ms time bin
%                   that does have a spike
%
%  Outputs from tfspec:
%       SPEC	=  Spectrum of X in [Space/Trials, Time, Freq] form. 
%	    F		=  Units of Frequency axis for SPEC.
%	    ERR 	=  Error bars in[Hi/Lo, Space, Time, Freq]  
%			   form given by the Jacknife-t interval for PVAL.
%                   *Note, calculating error bars does take awhile; so the
%                   code only calculates them if the function call has
%                   three output arguments. Be prepared to wait if you do
%                   this 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<3
    plotflag=1;
end
if nargin<2
   tlength=max(max(Spike)); 
end

N = .200; 
W = 5;

%if length(Trials) > 100
%    W = 5;
%else 
%    W = 10; 
%end

%Spike = SpikeTrial(Trials, Sys, Ch, Cl(1), Field, ...
%        [bn(1)-N/2*1e3,bn(2)+N/2*1e3], num);

dN=zeros(1,tlength);
dN(Spike)=1;

%                                                     in Hz
%function [spec,rate,f,err] = tfspec_pt(dN, tapers, sampling, dn, fk, pad, pval,flag);
tic;
if nargout > 2
    [Spec,f,err] = tfspec_pt(dN,[N,W],1e3,.01,200,2,0.05,1);
else
    [Spec,f] = tfspec_pt(dN,[N,W],1e3,.01,200,2,0.05,1);
end
toc

if plotflag
    figure
    imagesc(log10(Spec'+1e-8)) %add 1e-8 to avoid plotting log of zero))
    axis xy
    colorbar
    %because, according to Jarvis and Mitra- "It is conventional to display
    %spectra on a log scale because taking the log of the spectrum
    %stabilizes the variance and leads (to) a distribution that is
    %approximately gaussian."
    %
    %note this is just for display, the actual spectra for significance
    %testing and other purposes is given in Spec. (though the jackknife
    %procedure for the error bars is done in natural logspace, with output
    %transformed back before being output by the function)
end
    