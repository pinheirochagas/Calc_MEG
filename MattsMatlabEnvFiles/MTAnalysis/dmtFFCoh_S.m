%dmtFFCoh_S.m
%script m file for use with tfspec
%scale=1;

% Pooling across trials
%Xk = zeros(nch*K, diff(nfk)+1);
%Yk=Xk;
if detrendflag
    tmp1=detrend(tmp1);
    tmp2=detrend(tmp2);
end     %detrends the columns of tmp (which are trials of X)

%note: below: older code that I rewrote belwo to improve speed   
% for ch=1:nch
%     %tmpch1=tmp1(:,ch);
%     %curk = fft(tapers(:,1:K).*tmpch1(:,ones(1,K)),nf)';
%     
%     curk = fft(tapers.*tmp1( repmat(ch,K,1),: ),nf); %tapers should already be 1:K...    
%     Xk((ch-1)*K+1:ch*K,:) = curk(:,nfk(1):nfk(2));  %so Xk will have nch*K down dim 1, and freqs down dim 2
%     
%     %tmpch2=tmp2(:,ch);
%     %curk = fft(tapers(:,1:K).*tmpch2(:,ones(1,K)),nf)';
%     
%     curk = fft(tapers.*tmp2( repmat(ch,K,1),: ),nf);
%     Yk((ch-1)*K+1:ch*K,:) = curk(:,nfk(1):nfk(2));
% end

%amazing- prestoring the tapers in teh workspace rather than replicating them at the input
%to FFT seems to save a considerable amount of time... I would have thought otherwise    
%i.e. whats below takes much less time than the alternative:   Xk = fft( tapers(repmat(1:K,nch,1),:).*tmp1( tmpInds,: ),nf,2 );  
%but for some reason it doesn't seem to speed things up to do that for replicating the data... perhaps it has to do with the number of times it has to replicate
%values of the matrix, and when this number is high it's better to pre-store that in the workspace? hard to say

%Though matlab is faster doing things down the first dim, we prefer to keep
%our data with trials as the first dim, and time in the trial as the second
%dim. I tested the speed of the code, and on my copmuter it turns out to be
%faster to do the fft (and eveyrthing else) down the second dim than to
%transpose the data and do things down the first dim...
tmpInds=GenSecDimVarInds(K,nch);
tmpTaps=tapers(repmat([1:K]',nch,1),:);
%tmpTaps=tapers(:,repmat([1:K]',nch,1)); %if going down dim 1

Xk = fft( tmpTaps.*tmp1( tmpInds,: ),nf,2 );  %with an FFT, freq samples replace time samples for each trial, regardless of the dimension the FFT was performed on... 
Yk = fft( tmpTaps.*tmp2( tmpInds,: ),nf,2 );  %with an FFT, freq samples replace time samples for each trial, regardless of the dimension the FFT was performed on... so this outputs
%Xk = fft( tmpTaps.*tmp1( :,tmpInds ),nf );  %if going down dim 1   
%Yk = fft( tmpTaps.*tmp2( :,tmpInds ),nf );  %if going down dim 1 

if nfk(1)>1 || nfk(2)<size(Xk,2)   
    %Xk = Xk(nfk(1):nfk(2),:);  %if going down dim 1
    %Yk = Yk(nfk(1):nfk(2),:);
    
    Xk = Xk(:,nfk(1):nfk(2));    %so Xk will have nch*K down dim 1 and freqs down dim 2
    Yk = Yk(:,nfk(1):nfk(2));
end
%note that these Xk and Yk won't quantitatively match the J1 and J2 in teh Chronux code for the same data, which is b/c they normalize differently, before teh fourier transform... this normalization has no effect on the resulting coherence values though    

%for partial coherence, calc residual Fourier coefficients
if CalcPart
    XkResid=Xk-repmat( mean(Xk),nch*K,1 );
    YkResid=Yk-repmat( mean(Yk),nch*K,1 );
    if JustPartFlag;    coh(win,:) = mean(XkResid.*conj(YkResid))./sqrt( mean(abs(XkResid).^2) .* mean(abs(YkResid).^2) );
    else    Pcoh(win,:) = mean(XkResid.*conj(YkResid))./sqrt( mean(abs(XkResid).^2) .* mean(abs(YkResid).^2) );
    end
end

if ~JustPartFlag      
    coh(win,:) = mean(Xk.*conj(Yk))./sqrt( mean(conj(Xk).*Xk) .* mean(conj(Yk).*Yk) );    
    
    %coh(:,win) = mean(Xk.*conj(Yk),2)./sqrt( mean(abs(Xk).^2,2) .*mean(abs(Yk).^2,2) ); if going down dim 1     
end

if CalcSpec
    if errorchk && errType==2
        Xko=Xk;     %need to save these (before scaling later) if doing the permutation sig tests  
        Yko=Yk;
    end

    if PSDScaleFlag
        Xk=abs(Xk)/sqrt(sampling);
        Yk=abs(Yk)/sqrt(sampling);
        if CalcPartSpec
            XkResid=abs(XkResid)/sqrt(sampling);
            YkResid=abs(YkResid)/sqrt(sampling);
        end
    else
        OddTaps=[1:2:K]';    %to scale aptly for MS spec, we can only look at the odd tapers, b/c the even tapers sum to zero
        nOddTaps=length(OddTaps);
        
        tmpSelChans=repmat(OddTaps,nch,1);
        
        %Definitely no abs is desired in the line of code below
        %U=sum( tapers(:, repmat(OddTaps,1,nch)) ,1)';    %do this for a non-rect window instead of dividing by teh number of trials
        U=sum( tapers(tmpSelChans,:) ,2);                
        %note the same U normalization vector applies to both signals X and Y
        
        %Note- Xk here was transposed (above) after the fft, so the dimension ordering here is different than in LFPSpec...
        %This doesn't work for multiple trials!... see code a little lower  
        %Xk=abs(Xk( OddTaps,: ))./repmat(U',1,size(Xk,2));
        %Yk=abs(Yk( OddTaps,: ))./repmat(U',1,size(Yk,2));
        
        tmpSelChans=tmpSelChans+K*( ceil([1:nOddTaps*nch]'/nOddTaps)-1 );
        Xk=abs(Xk( tmpSelChans,: ))./repmat(U,1,size(Xk,2));
        Yk=abs(Yk( tmpSelChans,: ))./repmat(U,1,size(Yk,2));
        
        if CalcPartSpec
            XkResid=abs(XkResid( tmpSelChans,: ))./repmat(U,1,size(XkResid,2));
            YkResid=abs(YkResid( tmpSelChans,: ))./repmat(U,1,size(YkResid,2));
        end
    end
    
    %Note- Xk here was transposed (above) after teh fft, so the dimension ordering here is different than in LFPSpec...
    Sx(win,:) = mean(Xk.^2);   %averaging across tapers and trials
    Sy(win,:) = mean(Yk.^2);   %averaging across tapers and trials
    
    if CalcPartSpec
        PSx(win,:) = mean(XkResid.^2);   %averaging across tapers and trials
        PSy(win,:) = mean(YkResid.^2);   %averaging across tapers and trials
    end
    if scale
        Sx(win,:)=Sx(win,:)*2;    %because we're only using half the spectrum
        Sx(win,1)=Sx(win,1)/2;
        Sy(win,:)=Sy(win,:)*2;    %because we're only using half the spectrum
        Sy(win,1)=Sy(win,1)/2;
        if incNy % Nyquist component should also be unique.
            Sx(win,end)=Sx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
            Sy(win,end)=Sy(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
        end
        
        if CalcPartSpec
            PSx(win,:)=PSx(win,:)*2;    %because we're only using half the spectrum
            PSx(win,1)=PSx(win,1)/2;
            PSy(win,:)=PSy(win,:)*2;    %because we're only using half the spectrum
            PSy(win,1)=PSy(win,1)/2;
            if incNy % Nyquist component should also be unique.
                PSx(win,end)=PSx(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
                PSy(win,end)=PSy(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
            end
        end
    end
end

if errorchk && errType==2    %do cluster permutation tests similar to Maris et al. 2007 in JNM  
        %here we just want to collect the baselin and activity period Four. components...       
        if InBasePer(win)
            curBwin=sum(InBasePer(1:win));
            BaseXkoAll(:,:, curBwin )=Xko;
            BaseYkoAll(:,:, curBwin )=Yko;
            
            %decided not to take mean of mult base wins, instead randomly select 1 win for each shuff for each freq if multiple basewins are present       
%             if curBwin==nInBasePer  %then avg the Fourier copmonents across all the BaseWins
%                 BaseXko=mean(BaseXkoAll,3);
%                 BaseYko=mean(BaseXkoAll,3);
%             end
        end
        
        if InActPer(win)
            curAwin=sum(InActPer(1:win));
            ActXkoAll(:,:, curAwin )=Xko;
            ActYkoAll(:,:, curAwin )=Yko;
        end                        
    else 
        
    end
        
%     if errorchk		%  Estimate error bars using Jacknife
%         coh_err = zeros(2, diff(nfk));
%         SX_err = zeros(2, diff(nfk));
%         SY_err = zeros(2, diff(nfk));
%
%         dof = 2*nch*K;
%         for ik = 1:nch*K    %for each taper/trial combination
%             indices = setdiff([1:K*nch],[ik]);   %all taper/trial combs other than our current one (that's a lot... probably why it takes so long)
%             xj = Xk(indices,:);
%             jlsp(ik,:) = log(mean(abs(xj).^2,1));    %a jackknife sample in each row leaving a different taper/trial comb out, with a different frequency in each column
%         end
%         lsig = sqrt(nch*K-1).*std(jlsp,1);
%         crit = tinv(1-pval./2,dof-1);		% Determine the scaling factor; This gives you the t-statistic value (given the degrees of freedom) above which
%         % you would expect to be found only pval/2 percent of the time by chance
%         err(1,win,:) = exp(log(spec(win,:))+crit.*lsig);
%         err(2,win,:) = exp(log(spec(win,:))-crit.*lsig);
%     end