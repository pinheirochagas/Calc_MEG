function [spec, f, err] = tfspec(X, tapers, sampling, dn, fk, pad, pval, flag);
%TFSPEC  Moving window time-frequency spectrum using multitaper techniques.
%
% [SPEC, F, ERR] = TFSPEC(X, TAPERS, SAMPLING, DN, FK, PAD, PVAL, FLAG) 
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
%			   	    [N,W] Form:  N = duration of analysis window in s.
%                                W = bandwidth of frequency smoothing in Hz.
%               Defaults to [N,3,5] where N is NT/10
%				and NT is duration of X. 
%               
%	    SAMPLING 	=  Sampling rate of time series X in Hz. 
%				Defaults to 1.
%	    DN		=  Amount to slide window each time sample. (In s)
%			       	Defaults to N/10;
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,SAMPLING/2]
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%	   PVAL		=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	   FLAG = 0:	calculate SPEC seperately for each channel/trial.
%	   FLAG = 1:	calculate SPEC by pooling across channels/trials. 
%
%  Outputs: SPEC	=  Spectrum of X in [Space/Trials, Time, Freq] form. 
%	    F		=  Units of Frequency axis for SPEC.
%	    ERR 	=  Error bars in[Hi/Lo, Space, Time, Freq]  
%			   form given by the Jacknife-t interval for PVAL.
% 
%   See also DPSS, PSD, SPECGRAM.

%   Author: Bijan Pesaran, version date 15/10/98.

sX = size(X);
nt = sX(2);              % calculate the number of points
nch = sX(1);               % calculate the number of channels

if nargin < 3 sampling = 1.; end
n = floor(nt./10)./sampling;
if nargin < 2 tapers = [n,3,5]; end
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
%   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling; %# of samples in window
   if ~isint(tapers(1))
        tapers(1)=round(tapers(1));
        disp(['Had to adjust window length to ' num2str(tapers(1)) ' samples for a ' num2str(tapers(1)/sampling*1e3) ' msec window.'])
   end
   tapers = dpsschk(tapers);
end
if nargin < 4 dn = n/10; end
if nargin < 5 fk = [0,sampling/2]; end
if length(fk) == 1
    fk = [0,fk];
end
if fk(2)>sampling/2 fk(2)=sampling/2;   end
if nargin < 6 pad = 2; end
if nargin < 7 pval = 0.05; end
if nargin < 8 flag = 1; end

[N K] = size(tapers); %K is # of tapers, N is number of Samples in a taper
if N > nt error('Error: Tapers are longer than time series'); end

% Determine outputs
errorchk = 0;
if nargout > 2 errorchk = 1; end

dn = dn.*sampling;  %convert to number of samples
if ~isint(dn)
    dn=round(dn);
    disp(['Had to round dn to ' num2str(dn) ' samples for a ' num2str(dn/sampling*1e3) ' ms slide.'])
end
nf = max(256, pad*2^nextpow2(N+1)); %# of points for FFT
nfk = floor(fk/sampling*nf);
nwin = (nt-N)/dn;           % calculate the number of windows
if ~isint(nwin)
    nwin=floor(nwin);
    disp('Had to round nwin down and cut off some of the data')
end
f = linspace(fk(1),fk(2),diff(nfk));

if ~flag				% No pooling across trials
    spec = zeros(nch,nwin,diff(nfk));
    err = zeros(2,nch,nwin,diff(nfk));
    for ch = 1:nch
        for win = 1:nwin
            tmp = X(ch,win*dn+1:win*dn+N);  %Note, this ignores the first few samples
            dmtspec_S
            
%             if ~errorchk				%  Don't estimate error bars
%                 ftmp = dmtspec(tmp, tapers, sampling, fk, pad);
%                 spec(ch,win,:) = ftmp;
%             else 					%  Estimate error bars
%                 [ftmp, dum, err_tmp] = dmtspec(tmp, tapers, sampling, fk, pad, pval);
%                 spec(ch,win,:) = ftmp;
%                 err(1,ch,win,:) = err_tmp(1,:);
%                 err(2,ch,win,:) = err_tmp(2,:);
%             end
        end
    end
end

if flag					% Pooling across trials
    spec = zeros(nwin,diff(nfk));
    err = zeros(2,nwin,diff(nfk));
    for win = 1:nwin        %once here
        tmp = X(:,win*dn+1:win*dn+N);
        dmtspec_S
        
%         if ~errorchk				%  Don't estimate error bars
%             ftmp = dmtspec(tmp, tapers, sampling, fk, pad, pval, flag);     %many times here
%             spec(win,:) = ftmp;
%         else					%  Estimate error bars
%             [ftmp, dum, err_tmp] = dmtspec(tmp, tapers, sampling, fk, pad, pval,flag);
%             spec(win,:) = ftmp;
%             err(1,win,:) = err_tmp(1,:);
%             err(2,win,:) = err_tmp(2,:);
%         end
    end
end

if size(spec,1) == 1 & length(size(spec)) > 2
    spec = sq(spec);
end