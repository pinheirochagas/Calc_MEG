function err=CalcMaxSig(OTStat,MaxClusStat,nShuffs,wintimes,f,pval)  
%function err=CalcMaxSig(OTStat,MaxClusStat,nShuffs,wintimes,f,pval)     
%
%Note we don't need NClusCutOff b/c that's only used for calcing clus sums     

%first find all PVals ... no way to do this without looping through...
%OTStat needs to have Freqs down dim 1 and time wins down dim 2   

OTStatNegInds=OTStat<0;     %record signs of OTstat to be sure that sig values of opposite signs don't get clustered together        
OTStat=abs(OTStat);

MaxClusStat=sort(MaxClusStat);
err.NullTestStatDist=MaxClusStat;
err.SigThresh= MaxClusStat( floor((1-pval)*nShuffs),1 );
for iw=1:length(wintimes)
    for iF=1:length(f)
        err.PVals(iw,iF)=sum( MaxClusStat>=OTStat(iw,iF) )/nShuffs;        
    end
end

%to avoid adjacent positive and negative significant locations from being clustered together, cluster the positive values first, then the negative values     
%first cluster positive values, then negative values
[err.SigClusAssign,err.NSigClus] = bwlabeln(OTStat>=err.SigThresh & ~OTStatNegInds  ,4);
[tmpClusAssign,tmpNSigClus] = bwlabeln(OTStat>=err.SigThresh & OTStatNegInds  ,4);

if tmpNSigClus
    if ~err.NSigClus
        err.SigClusAssign=tmpClusAssign;
        err.NSigClus=tmpNSigClus;
    else
        err.SigClusAssign( tmpClusAssign>0 )= tmpClusAssign( tmpClusAssign>0 ) + err.NSigClus;
        err.NSigClus=err.NSigClus+tmpNSigClus;
        
        %need to go through SigClusAssign to see that Sig Clus's are arranged in order of freq, whether pos or neg     
        cClus=0;
        inClusFlag=false;
        for ix=1:length(err.SigClusAssign)
            if inClusFlag
                if err.SigClusAssign(ix)
                    err.SigClusAssign(ix)=cClus;
                else
                    if cClus==err.NSigClus;  
                        break
                    end
                    inClusFlag=0;
                end
            else 
                if err.SigClusAssign(ix)
                    cClus=cClus+1;
                    err.SigClusAssign(ix)=cClus;
                    inClusFlag=1;
                end
            end            
        end
        
    end
end


%get TFCens of all Clusters
err.AllTFCens=repmat(0,err.NSigClus,2);
[Cli,Clj,Cln] = find(err.SigClusAssign);
for isc=1:err.NSigClus
    tmpInds=find( Cln==isc );   %all the clusters here are significant
    
    %for some reason, here the dimensions DON'T seem to get screwed up for when there's only one time window, so the below conditional code is not necessary      
    %if length(wintimes)==1      %.... the dimensions get screwed up if there's only one time window
    %    err.Clus(isc).AllTFVals=[wintimes( Cli(tmpInds) )' f( Clj(tmpInds) )']; %Cli will be TIME inds, and Clj will be FREQ Inds
    %else
        err.Clus(isc).AllTFVals=[wintimes( Cli(tmpInds) )' f( Clj(tmpInds) )']; %Cli will be TIME inds, and Clj will be FREQ Inds
    %end
    err.Clus(isc).TFCen=mean(err.Clus(isc).AllTFVals,1);
    err.AllTFCens(isc,:)=err.Clus(isc).TFCen;
end