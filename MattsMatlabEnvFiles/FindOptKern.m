function k=FindOptKern(InSig,OutSig,MaxnLags)
%function k=FindOptKern(InSig,OutSig,MaxnLags)
%
% Given InSig, OutSig, and the MaxnLags, this will find the optimal causal
% kernal of length MaxnLags that when convolved with InSig gives the
% optimal approximation to OutSig in a least squares sense.
% 
% Note that this code produces the optimal causal kernel. the basic
% technique does not have to produce a causal kernel, but this code does.
%
% Input
%   InSig:      An N x 1 vector of the input signal (i.e. Trial type in the
%               trial history example)
%   OutSig:     An N x 1 vector of the output signal (i.e. RT in the trial
%               history example)
%   MaxnLags:   A scalar for the maximum number of lags to calculate up to.
%               Must be less than the length of the signal.
%
%   k:          A MaxnLags x 1 vector of the optimal kernel.
%
%   Note that the first sample in the ouput k corresponds to the value in 
%   OutSig on time n+1 that results from a unit input in InSig on time n
%
% For an explanation of this, See Corrado, Sugrue, Seung and Newsome (2004) 
% pp. 591-592
% Also see: http://hebb.mit.edu/courses/9.29/2004/lectures/lecture03.pdf
%
% by MJN on 090318
% verified on 090318 with spk sdf kernel simulation that the first sample 
% in the ouput k corresponds to the value in OutSig on time n+1 that
% results from a unit input in InSig on time n

%convert data to column vectors
[r c]=size(InSig);
if c>r;     InSig=InSig';       end
[r c]=size(OutSig);
if c>r;     OutSig=OutSig';       end

%means may need to subtracted out...
%InSig=InSig-mean(InSig);
%OutSig=OutSig-mean(OutSig);

Cxy=xcov(OutSig,InSig,MaxnLags);
Cxy=Cxy(MaxnLags+2:end);

Cxx=xcov(InSig,InSig,MaxnLags-1);
Cxx=Cxx(MaxnLags:end);
Cxxmat=toeplitz(Cxx);

%below is a matrix multiplication, done by multiplying by the inverse
k= (Cxxmat^-1)*Cxy;