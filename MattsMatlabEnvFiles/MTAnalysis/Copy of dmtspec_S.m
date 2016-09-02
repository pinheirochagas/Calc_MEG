%dmtspec_S.m
%script m file for use with tfspec
%scale=1;

if ~flag		% No pooling across trials
    %disp('Not detrending.')    
    tmp=tmp';
    if detrendflag  tmp=detrend(tmp);   end
    xk = fft(tapers(:,1:K).*tmp(:,ones(1,K)),nf)';
    xk = xk(:,nfk(1):nfk(2));
    Sk = (abs(xk));
    Sk=(Sk/nt).^2;
    if scale    
        Sk=Sk*2;    %because we're only using half the spectrum     
        Sk(1) = Sk(1)/2;    % DC Component should be unique.
        if incNy % Nyquist component should also be unique.
            MX(end) = MX(end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
        end
    end
    spec(ch,win,:) = mean(Sk,1); %averaging across tapers
    
%     This was in the matlab version of the code, as an example
%     case {'unity','eigen'}
%         % Compute the averaged estimate: simple arithmetic averaging is used.
%         % The Sk can also be weighted by the eigenvalues, as in Park et al.
%         % Eqn. 9.; note that that eqn. apparently has a typo; as the weights
%         % should be V and not 1/V.
%         if strcmp(params.MTMethod,'eigen')
%             wt = V(:);    % Park estimate -this is where V is the
%             eigenvalue weights...
%         else
%             wt = ones(k,1);
%         end
%         S = Sk*wt/k;  *note, this does the averaging and weighting right
%         here in one step
%     end
    

    if errorchk	%  Estimate error bars using Jacknife
        dof = 2*K;
        for ik = 1:K     %for each taper
            indices = setdiff([1:K],[ik]);     %all tapers other than our current taper
            xj = xk(indices,:);
            jlsp(ik,:) = log(mean(abs(xj).^2,1));  %a jackknife sample in each row leaving a different taper out, with a different frequency in each column
        end
        lsig = sqrt(K-1).*std(jlsp,1);      %note the default of std is actually what we want, with the N-1 correction,,,
        crit = tinv(1-pval./2,dof-1);		%   Determine the scaling factor
        err(1,ch,win,:) = exp(log(spec(ch,win,:))+crit.*lsig);
        err(2,ch,win,:) = exp(log(spec(ch,win,:))-crit.*lsig);
    end
end


if flag			% Pooling across trials
    Xk = zeros(nch*K, diff(nfk)+1);
    for ch=1:nch
        tmpch=tmp(ch,:)';
        if detrendflag  tmpch=detrend(tmpch);   end
        xk = fft(tapers(:,1:K).*tmpch(:,ones(1,K)),nf)';
        Xk((ch-1)*K+1:ch*K,:) = xk(:,nfk(1):nfk(2));
        %Xk=Xk/sampling;
    end
    Xk=abs(Xk)/nt;
    spec(win,:) = mean((abs(Xk)).^2,1);   %averaging across tapers and trials
    if scale    
        spec(win,:)=spec(win,:)*2;    %because we're only using half the spectrum
        spec(win,1)=spec(win,1)/2;
        if incNy % Nyquist component should also be unique.
            spec(win,end)=spec(win,end)/2;    % Here NFFT is even; therefore,Nyquist point is included.
        end
    end    

    if errorchk		%  Estimate error bars using Jacknife
        dof = 2*nch*K;
        for ik = 1:nch*K    %for each taper/trial combination
            indices = setdiff([1:K*nch],[ik]);   %all taper/trial combs other than our current one (that's a lot... probably why it takes so long)
            xj = Xk(indices,:);
            jlsp(ik,:) = log(mean(abs(xj).^2,1));    %a jackknife sample in each row leaving a different taper/trial comb out, with a different frequency in each column
        end
        lsig = sqrt(nch*K-1).*std(jlsp,1);
        crit = tinv(1-pval./2,dof-1);		% Determine the scaling factor; This gives you the t-statistic value (given the degrees of freedom) above which
        % you would expect to be found only pval/2 percent of the time by chance
        err(1,win,:) = exp(log(spec(win,:))+crit.*lsig);
        err(2,win,:) = exp(log(spec(win,:))-crit.*lsig);
    end
end
