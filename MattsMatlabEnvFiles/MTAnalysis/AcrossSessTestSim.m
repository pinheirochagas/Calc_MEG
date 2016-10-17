nSess=32;
t=-300:10:500;
f=0:10:80;

tOn=isbetween(t,[300 500]);
fOn=isbetween(f,[20 60]);
ntOn=sum(tOn);
nfOn=sum(fOn);
Opts.nShuffs=50;

TestStats1=randn(length(t),length(f),nSess);
TestStats2=randn(length(t),length(f),nSess);
TestStats1(tOn,fOn,:)=TestStats1(tOn,fOn,:)+randn(ntOn,nfOn,nSess)*.1+50;

%err=AcrossSessTFShuffTest( TestStats,t,f,[],Opts );
err=AcrossSessWInSessCondsTFShuffTest( TestStats1,TestStats2,t,f,[],Opts ); 
