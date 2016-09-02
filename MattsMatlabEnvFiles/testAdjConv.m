function testAdjConv()
% Adjust parameters below   
%
% This script generates a fake signal of noise plus an impulse of activity at one time point to test the timing preservation of the adjusted convolution    

%%%%%%%%% Adjustable paramaters   
CompareToOtherConv=0;    % this is just an option to compare the output to the output of another function available on the FileExchange as of 2014-12-4     

fsample=1000;

tSigLims=[-0.025 0.025];        % in seconds, time of the signal to generate   
tOutLims=[-0.02 0.02];    % in seconds, time of the signal to calculate and plot the convolution over   

Baseline=10;
pkTime=0;
pkAddedVal=50;
NoiseStd=1;

KernWidth = 0.001; %%% size in sec of the std of the Gaussian kernel for smoothing the data
nKernStdToInc=4;    % the number of stds of the Gaussian to include when generating the kernel    
%%%%%%%%% End of adjustable paramaters  


t=[tSigLims(1): 1/fsample :tSigLims(2)];

sig=randn(length(t),1)*NoiseStd + Baseline;
[~,pksamp] = min( abs(t-pkTime) );    
sig(pksamp)=sig(pksamp)+pkAddedVal;


opts.KernWidth=KernWidth;
opts.nKernStdToInc=nKernStdToInc;

%[SigOut,tout,kern,kdelay, OrigSigExcerpt]=AdjConv(sig,kern,t,toutlims,opts)
[AdjConvSig, tout, ~, OrigSigExcerpt]=AdjConv(sig,'Gauss',t,tOutLims,opts);

figure
plot(tout,OrigSigExcerpt,'b-*')
hold on

plot( tout,AdjConvSig,'r-*' )
if CompareToOtherConv
    GaussFiltSig=gaussfilt_local(t,sig,KernWidth);    % need to adjust KernWidth into units of samples
 
    [~,st] = min( abs(t-tOutLims(1)) );
    [~,en] = min( abs(t-tOutLims(2)) );

    GaussFiltSig_toPlot=GaussFiltSig(st:en);
    plot( tout,GaussFiltSig_toPlot,'m-*' )
end

title(['gkern Width: ' num2str(KernWidth*1000) ' ms'])

end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ zfilt ] = gaussfilt_local( t,z,sigma)
%Apply a Gaussian filter to a time series
%   Inputs: t = independent variable, z = data at points t, and 
%       sigma = standard deviation of Gaussian filter to be applied.
%   Outputs: zfilt = filtered data.
%
%   written by James Conder. Aug 22, 2013
%   convolution for uniformly spaced time time vector (faster) Sep 4, 2014

n = length(z);  % number of data
a = 1/(sqrt(2*pi)*sigma);   % height of Gaussian
sigma2 = sigma*sigma;

% check for uniform spacing
% if so, use convolution. if not use numerical integration
uniform = false;
dt = diff(t);
dt = dt(1);
ddiff = max(abs(diff(diff(t))));
if ddiff/dt < 1.e-4
    uniform = true;
end

if uniform
    filter = dt*a*exp(-0.5*((t - mean(t)).^2)/(sigma2));
    i = filter < dt*a*1.e-6;
    filter(i) = [];
    zfilt = conv(z,filter,'same');
else
    %%% get distances between points for proper weighting
    w = 0*t;
    w(2:end-1) = 0.5*(t(3:end)-t(1:end-2));
    w(1) = t(2)-t(1);
    w(end) = t(end)-t(end-1);

    %%% check if sigma smaller than data spacing
    iw = find(w > 2*sigma, 1);
    if ~isempty(iw)
        disp('WARNING: sigma smaller than half node spacing')
        disp('May lead to unstable result')
        iw = w > 2.5*sigma;
        w(iw) = 2.5*sigma;
        % this correction leaves some residual for spacing between 2-3sigma.
        % otherwise ok.
        % In general, using a Gaussian filter with sigma less than spacing is
        % a bad idea anyway...
    end

    %%% loop over points
    zfilt = 0*z;    % initalize output vector
    for i = 1:n
        filter = a*exp(-0.5*((t - t(i)).^2)/(sigma2));
        zfilt(i) = sum(w.*z.*filter);
    end

    %%% clean-up edges - mirror data for correction
    ss = 2.4*sigma;   % distance from edge that needs correcting

    % left edge
    tedge = min(t);
    iedge = find(t < tedge + ss);
    nedge = length(iedge);
    for i = 1:nedge;
        dist = t(iedge(i)) - tedge;
        include = find( t > t(iedge(i)) + dist);
        filter = a*exp(-0.5*((t(include) - t(iedge(i))).^2)/(sigma2));
        zfilt(iedge(i)) = zfilt(iedge(i)) + sum(w(include).*filter.*z(include));
    end

    % right edge
    tedge = max(t);
    iedge = find(t > tedge - ss);
    nedge = length(iedge);
    for i = 1:nedge;
        dist = tedge - t(iedge(i));
        include = find( t < t(iedge(i)) - dist);
        filter = a*exp(-0.5*((t(include) - t(iedge(i))).^2)/(sigma2));
        zfilt(iedge(i)) = zfilt(iedge(i)) + sum(w(include).*filter.*z(include));
    end
end         % uniform vs non-uniform

end


