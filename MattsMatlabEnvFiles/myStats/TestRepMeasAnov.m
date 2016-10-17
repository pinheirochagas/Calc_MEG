%TestRepMeasAnov.m

%%%%%%% User inputs
nS=10;
nTr=100;
Bmn=[.1 .05 .5 .3 -.2];
BSVar=[.02 .02 .02 .02 .02];

NVar=.02;
%%%%%%% End of User inputs

nTot=nS*nTr;
nX=length(Bmn);
X=randn(nTot,nX);

Bsubj=repmat(Bmn,nS,1) + randn(nS,nX).*repmat(BSVar,nS,1);


for iS=1:nS
    
end

%apply model and create S vector  
Y=zeros(nTot,1);
S=zeros(nTot,1);
for iS=1:nS
    st=(iS-1)*nTr+1;
    en=iS*nTr;
    
    S( st:en )=iS;        
    
    Y( st:en )=X(st:en,:)*(Bsubj( iS,: )') + randn(nTr,1)*NVar;
end
    

%Test the function
%[b,bint,p] = myRepMeasRegress(Y,X,Subj)
[b,bint,p] = myRepMeasRegress(Y,X,S)
