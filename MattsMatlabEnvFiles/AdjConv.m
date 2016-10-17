function [sigOut,tout,kern,OrigSigExcerpt]=AdjConv(sig,kern,t,tOutLims,opts)
%function SigOut=AdjConv(sig,kern,t,opts)
%
% This performs a convolution while properly preserving the timing of peaks
% and avoiding edge effects. The functin can use a kernel input to it, or
% generate a guassian kernel within the functiuon, according to input
% parameters.
%
% Note that the data input to the function must be longer than the
% convolved data output of the function, with half of the kernel length
% extending on either side of the time limits in tOutLims
%
% Inputs:
%       sig-    nt x 1 vector of the time series signal to be convolved
%       kern-   nk x 1 vector of the kernel to convolve sig with. Or
%               altrnatively, a string 'Gauss' to create a Gaussian kernel 
%               with parameters given by the opts input structure   
%       t-      nt x 1 vector of times correspondig to each sample of sig.
%               In units of seconds.
%       tOutLims-  2x1 vector indiacting the start and end time 
%               (in seconds) to calculate the convolution output over   
%       opt-    1 x 1 structure. Fieldnames of opts will be read into the
%               function workspace to override default parameters. See code
%               for details of parameters to potentially override
%
% Outputs:
%       SigOut-     The output signal over the time range defined               
%       tout-       The times corresponding to each sample of SigOut
%       kern-       The kernel used. Potetnially useful if generated within
%                   the function.
%       OrigSigExcerpt-     An excerpt of the original signal over the same
%                   time range defined by tout for plotting to compare to
%                   SigOut and invetsigate the performance of the
%                   convolution
%
% Matthew Nelson Dec 5th, 2014
% matthew.nelson.neuro@gmail.com


% Set Default Parameters
% These apply if kern is input as 'Gauss'       
KernWidth = 0.05; %%% size in sec of the std of the Gaussian kernel for smoothing the data
nKernStdToInc=4;

if nargin<4 || isempty(opts);       opts=struct;     end
if nargin<3 || isempty(t);          t =[1:length(sig)];     end
if nargin<2 || isempty(kern);       kern='Gauss';     end

fieldlist=fieldnames(opts);
for ifld=1:length(fieldlist)
    eval([fieldlist{ifld} '= opts.(fieldlist{ifld});']);
end

% calc fsample   
fsample=1/( t(2)-t(1) );   % in Hz  

%create the kernel if needed
if isstr(kern)
    if strcmp(kern,'Gauss')
        xlim=floor(nKernStdToInc*KernWidth*fsample)*1/fsample; %calculate the xlimit time associated nearest sample- without going over the limits
        tmpx = -xlim:(1/fsample):xlim;
        kern=normpdf(tmpx,0,KernWidth);
        kern=kern./sum(kern);
    end
end

%calc kdelay   
kdelay=floor( (length(kern)-1)/2 );     %in units of samples
    
% convert needed time units to samples 
[~,st] = min( abs(t-tOutLims(1)) );
[~,en] = min( abs(t-tOutLims(2)) );
if nargout >= 2
    tout=t(st:en);
end
if nargout >= 4
    OrigSigExcerpt=sig(st:en);
end

sigOut=conv(sig(st-kdelay:en+kdelay + iseven(length(kern))),kern,'valid');