% tfFFCoh_S         %for Field-Field Coherence (or coherence of any two sampled continuous time series)  
% for use with LFP_LFPCoh; 
% derived from formerly tfspec_S, with inputs written below
%
%   Matt Nelson

sX = size(X);
nt = sX(2);              % calculate the number of points
nch = sX(1);               % calculate the number of channels

sY = size(Y);
nt2 = sY(2);              % calculate the number of points
nch2 = sY(1);               % calculate the number of channels

if nt ~= nt2 error('Error: Input time series are not the same length'); end 
if nch ~= nch2 error('Error: Input time series have different numbers of trials'); end 

[K N] = size(tapers); %K is # of tapers, N is number of Samples in a taper
%[N K] = size(tapers); %if going down dim 1... K is # of tapers, N is number of Samples in a taper    
if N > nt error(['Error: You probably need to transpose (rotate) your input data. Taper length: ' num2str(N) ' is longer than the time series, length: ' num2str(nt)]); end

dn = dn.*sampling;  %convert to number of samples
if ~isint(dn)
    dn=round(dn);
    disp(['Had to round dn to ' num2str(dn) ' samples for a ' num2str(dn/sampling*1e3) ' ms slide.'])
end

%for speed- I'm removing the insistance that 256 be the min # of points for the fft 
if pad==0
    nf=N;
else
    if FSPadFlag    nf = sampling*pad*2^nextpow2(N/sampling);  %nf = max(sampling*2^nextpow2(256/sampling), sampling*pad*2^nextpow2(N/sampling));
    else    nf = pad*2^nextpow2(N+1);    end    %nf = max(256, pad*2^nextpow2(N+1));     end %# of points for FFT
end

fstep=sampling/nf;
nfk(1)=floor(fk(1)/fstep)+1;    %this gives the index we go to for the FFT. It's plus 1 because the first index is the DC value. Note we can't always get any arbitrary frequency unless its a multiple of fstep
nfk(2)=ceil(fk(2)/fstep)+1;
nrecf=nfk(2)-nfk(1)+1;
f=(nfk(1)-1)*fstep:fstep:(nfk(2)-1)*fstep;
if iseven(nf) && f(end)==sampling/2 incNy=1;
else incNy=0;   end

% nfk = floor(fk/sampling*nf);  %Older not quite correct way of doing this
% f = linspace(fk(1),fk(2),diff(nfk));

nwin = (nt-N)/dn+1;           % calculate the number of windows
if ~isint(nwin)
    nwin=floor(nwin);
    disp('Had to round nwin down and cut off some of the data')
end

%t0=0; %ms time for first data sample; which is not actually included in x-axis plot
Nms=N*1000/sampling; %convert back to ms
dnms=dn*1000/sampling; %convert back to ms
tout=([0:nwin-1])*dnms+t0+Nms/2; %center of win- used for plotting


% Pooling across trials
coh = zeros(nwin,diff(nfk)+1);
%coh = zeros(diff(nfk)+1,nwin);     %if going down dim 1

if CalcPart && ~JustPartFlag
    Pcoh=coh;
end
if CalcSpec
    Sx=coh;
    Sy=coh;
    if CalcPartSpec
        PSx=coh;
        PSy=coh;
    end
end
%if errorchk     err = zeros(2,nwin,diff(nfk)+1);        end

%Init vals for ShuffTest
if errorchk && errType==2    
    %Find wins that are in BasePer and ActPer
    tst=tout-Nms/2;
    te=tout+Nms/2;
    InBasePer=isbetween(tst,ClusShuffOpts.BasePer) & isbetween(te,ClusShuffOpts.BasePer); %T or F based on whether a given window is completely within the baseline window
    InActPer=isbetween(tst,ClusShuffOpts.ActPer) & isbetween(te,ClusShuffOpts.ActPer); %T or F based on whether a given window is completely within the baseline window
            
    %InitBaseXko and BaseYko
    nInBasePer=sum(InBasePer);
    nInActPer=sum(InActPer);
    BaseXkoAll=repmat( 0,[nch*K, diff(nfk)+1, nInBasePer] );
    BaseYkoAll=BaseXkoAll;
    
    ActXkoAll=repmat( 0,[nch*K, diff(nfk)+1, nInActPer] );
    ActYkoAll=ActXkoAll;
end

%X=X';
%Y=Y';
for win = 1:nwin
    dat1 = X(:,(win-1)*dn+1:(win-1)*dn+N);   %changed to win-1 becasue that ignored the first few samples, also added 1 to nwin above
    dat2 = Y(:,(win-1)*dn+1:(win-1)*dn+N);
    %tmp1 = X((win-1)*dn+1:(win-1)*dn+N,:);   %changed to win-1 becasue that ignored the first few samples, also added 1 to nwin above
    %tmp2 = Y((win-1)*dn+1:(win-1)*dn+N,:);
    
    %dmtFFCoh_S
    dmtUbiq_S    
end

nReps=nch*K;
if errorchk 
    MTShuffTest_S   %This script performs either the shuffle test or the quick and easy analytical assumption test, based on the value of errType
end

if ZTransFlag
    coh=sqrt(2*nReps-2)*atanh(coh)-1/sqrt(2*nReps-2);   %according to Thompson and Chave, and Koopmans, this is approximately distributed as a standard Gausian
    %note- the expected value of the above is actually: sqrt(2*nReps-2)*atanh(coh), so sessions with more Reps will have a larger coherence after this transformation; BUT- under the null, coh=0, so in this case, the variance and teh expected val of ecah session is independent of the number of Reps, which teh assumption we want to test with our staitistical tests...           
    if CalcPart     Pcoh=sqrt(2*nReps-2)*atanh(Pcoh)-1/sqrt(2*nReps-2);     end
    if CalcSpec
        Sx=( log(Sx)-(psi(2*nReps)-log(2*nReps)) )/sqrt(psi(1,2*nReps));
        Sy=( log(Sy)-(psi(2*nReps)-log(2*nReps)) )/sqrt(psi(1,2*nReps));
        
        if CalcPartSpec
            PSx=( log(PSx)-(psi(2*nReps)-log(2*nReps)) )/sqrt(psi(1,2*nReps));
            PSy=( log(PSy)-(psi(2*nReps)-log(2*nReps)) )/sqrt(psi(1,2*nReps));
        end
    end
end