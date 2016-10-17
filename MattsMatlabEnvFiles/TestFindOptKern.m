%TestFindOptKern.m
%
% A script to test the function FindOptKern.
%
% By: Matt Nelson 090325

%simulate a spike train
nSpks=500;
bn=[0 30000]; 
%below line of code ensure no spikes are too near the edge of the time series, to make things nicer  
spk=unique( round( rand(nSpks,1)*(bn(2)-160*2) )+160 );

%convert the spkes to a continuous signal
ContSpk=repmat(0,bn(2),1);
ContSpk(spk)=1;

%create PSP for smoothing spikes
BW=160;
Growth=1; %ms
Decay=20; %ms, to match grav PSP

Kernel=[0:BW];
Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
Kernel=Kernel./sum(Kernel);  %this makes the Kernel sum to 1
Kernel=Kernel.*1000;    %this makes the Kernel sum to 1000... because the time bin of 1 msec has a time unit of 1 in our plots, this makes the output sdf in unit of Hz (spks/sec)

%convolve continuous spike train with filter to get the output
sdf=filter(Kernel,1,ContSpk);

%add noise
NVar=1;
sdf=sdf+NVar*randn(size(sdf));

%find the kernel
k=FindOptKern(ContSpk,sdf,80);

%plot to compare with the known kernel... the goal is for the two lines to match reasonably well 
figure
plot(k,'b') %what we estimated after convolution with noise added
hold on
plot(Kernel(2:end),'r'); %the known original kernel

% Note that Original Kernel is shifted by 1 for the plot comparison because
% the first sample in the ouput k corresponds to the value in OutSig on time 
% n+1 that results from a unit input in InSig on time n
