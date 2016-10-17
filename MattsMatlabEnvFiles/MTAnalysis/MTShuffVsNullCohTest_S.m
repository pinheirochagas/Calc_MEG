%MTShuffVsNullCohTest_S.m
%
% called by LFP_LFPCoh, etc. After looping through all windows and calling dmtUbiq_S.m

%variables to distinguish what function ultimately called this are:
%SpkFlag as a 2x1 vector indicating whether a given signal is a Spk (1)
%or not (0), and variable TwoSigsFlag to indicate whether or not two signals
%are present....

%I will write this to ask if doing a Spec test to do the theoretical
%spectrum tests...

if errType==2 && (ClusShuffOpts.CohTest  || ClusShuffOpts.PCohTest)
    %first get test stats for orig data
    %note that both the baseline and activation periods have the same num of df,... so there is no need to transform/correct the coh
    
    %first do shuffs before getting clus stats on orig data
    %Assuming TwoSigsFlag==1 for this test!
    disp(['Starting Cluster Shuffling, ' num2str(ClusShuffOpts.nShuffs) ' Shuffs to do'])
    if ClusShuffOpts.CohTest
        CohMaxClusStat=repmat(0,ClusShuffOpts.nShuffs,1);       %no clustering, so no need for a col w/ NormAboveThresh as 0 and a seperate col w/ NormAboveThresh as 1...
    end
    
    %Note: no spec test for this shuffle test
    %if ClusShuffOpts.SpecTest;
    
    if ClusShuffOpts.PCohTest
        PCohMaxClusStat=repmat(0,ClusShuffOpts.nShuffs,1);
    end
    
    %nReps=size(BaseXkoAll,1);
    ShuffActYk=repmat(0,[nReps, nrecf, nInActPer]);     %we only need to shuff Yk, and we'll measure the coherence of that with the actual Xk
    
    if ClusShuffOpts.PCohTest   %we only need to get the partial Xk's and Yk's once overall, not once per shuffle
        PActXkoAll=ActXkoAll-repmat( mean(ActXkoAll),nReps,1 );
        PActYkoAll=ActYkoAll-repmat( mean(ActYkoAll),nReps,1 );
    end
    
    %note that we don't need the Mag or Ph Adj. with this test either!
    tic
    for iS=1:ClusShuffOpts.nShuffs
        if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
        
        tmpInds=randperm( nReps );
        ShuffActYk=ActYkoAll( tmpInds,:,: );     %keep Xk as normal but shuff Yk
        
        if ClusShuffOpts.CohTest
            %for this the tets stat is just the mag of the coh... and I'm just going to a maximum test; no clustering per shuffle... instead we'll cluster at the end
            %that it would be possible to do a one-sample Z trans ... BUT-
            %the main reason I don't wanna do that:  but for trials with a
            %response to a stimulus, it creates a problem of knowing where to set the threshhold b/c even with the shuffling there
            %should be coh higher than zero everywhere, likely for each or most shuffles
            %on top of that: the z trans's are based on approx's anyway that may not be that great
            
            
            curSX1=squeeze( mean(ActXkoAll.*conj(ActXkoAll)) );
            curSY1=squeeze( mean(ShuffActYk.*conj(ShuffActYk)) );
            curTStat=abs( squeeze( mean(ActXkoAll.*conj(ShuffActYk)) )./sqrt( curSX1 .* curSY1 ) );
            if SetOutputRes>0
                curTStat2=AvgAcrossFreqs(curTStat,fraw,SetOutputRes,fk,[],1);
                CohMaxClusStat(iS)=max(max(curTStat2));
            else
                CohMaxClusStat(iS)=max(max(curTStat));
            end
        end
        
        if ClusShuffOpts.PCohTest
            PShuffActYk=PActYkoAll( tmpInds,:,: );
            
            curSX1=squeeze( mean(PActXkoAll.*conj(PActXkoAll)) );
            curSY1=squeeze( mean(PShuffActYk.*conj(PShuffActYk)) );
            curTStat=abs( squeeze( mean(PActXkoAll.*conj(PShuffActYk)) )./sqrt( curSX1 .* curSY1 ) );
            if SetOutputRes>0
                curTStat2=AvgAcrossFreqs(curTStat,fraw,SetOutputRes,fk,[],1);
                PCohMaxClusStat(iS)=max(max(curTStat2));
            else
                PCohMaxClusStat(iS)=max(max(curTStat));
            end            
        end
        
        if iS==1
            disp('For first Shuff: ');
            toc
            tmptim=toc;
            disp(['Shuffling should be done in about ' num2str( ClusShuffOpts.nShuffs*tmptim/60 ) ' minutes'])
        end
    end
    disp('Done Shuffling')
    
    err.wintimes=tout(InActPer); %these will be the center of each time win
    %Now calc Test Stats on orig data
    if ClusShuffOpts.CohTest
        %Unlike the other Shuff tests, curTStat will have time down dim 1 and freq down dim 2
        curTStat= abs(coh(InActPer,:));
        
        %[err.Coh err.CohNormAboveThresh]=CalcClusSig( curTStat,CohMaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
        %err=CalcClusSig_VsNullCoh(OTStat,MaxClusStat,nShuffs,wintimes,f,pval)
        err.Coh=CalcClusSig_VsNullCoh( curTStat,CohMaxClusStat,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
    end
    
    if ClusShuffOpts.PCohTest
        curTStat= abs(Pcoh(InActPer,:));
        
        %[err.PCoh  err.PCohNormAboveThresh]=CalcClusSig(curTStat,PCohMaxClusStat,ClusShuffOpts.Thresh,ClusShuffOpts.NClusCutOff,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
        err.PCoh=CalcClusSig_VsNullCoh( curTStat,PCohMaxClusStat,ClusShuffOpts.nShuffs,err.wintimes,f,pval );
    end
    
    %opts to plot this- when using imagesc for coh, you could only add each
    %cluster, and leave the rest of the space in teh graph blank... or you
    %could use matlab's edge function and draw a thick black ro whit line
    %around each cluster on the usual colorplot... one caveat to the edge
    %method- sometimes the output appears to be a little off, but it's
    %always close
    
    %Below: if wanting to do spec or PSpec test, this type of trial shuffling won't work, so instead we output the Jarvis and Mitra theoretical conf ints for spectra   
    if ClusShuffOpts.SpecTest || ClusShuffOpts.PSpecTest
        %you need to record the NTotSpksPerWin (and NTotSpksPerWin2 for Spk_SpkCoh, as a 1 x nWin vector before reaching here
        if SpkFlag(1)
            tmpdf1=repmat( 2./ (  repmat(1/(2*nReps),nwin,1) +1./(2*NTotSpksPerWin)),1,nrecf );
        else
            tmpdf1=repmat(2*nReps,nwin,nrecf);
        end
        if TwoSigsFlag
            if SpkFlag(2)    %we need to check the dfs of the second signal in case this is spk lfp coh,. in which case they might be different
                tmpdf2=repmat( 2./ (  repmat(1/(2*nReps),nwin,1) +1./(2*NTotSpksPerWin2)),1,nrecf );
            else
                tmpdf2=repmat(2*nReps,nwin,nrecf);
            end
        end
        
        if CalcSpec;
            BaseCILimsLo=tmpdf1./ chi2inv( 1-pval/2,tmpdf1 );
            BaseCILimsHi=tmpdf1./ chi2inv( pval/2,tmpdf1 );
            if exist('Sx','var') && ClusShuffOpts.SpecTest
                err.Spec1CIHi=Sx.* BaseCILimsHi;
                err.Spec1CILo=Sx.* BaseCILimsLo;
            end
            if exist('PSx','var') && ClusShuffOpts.PSpecTest
                err.PSpec1CIHi=PSx.* BaseCILimsHi;
                err.PSpec1CILo=PSx.* BaseCILimsLo;
            end
        end
        if TwoSigsFlag;
            if CalcSpec;
                BaseCILimsLo=tmpdf2./ chi2inv( 1-pval/2,tmpdf2 );
                BaseCILimsHi=tmpdf2./ chi2inv( pval/2,tmpdf2 );
                if exist('Sy','var') && ClusShuffOpts.SpecTest
                    err.Spec2CIHi=Sy.* BaseCILimsHi;
                    err.Spec2CILo=Sy.* BaseCILimsLo;
                end
                if exist('PSy','var') && ClusShuffOpts.PSpecTest;
                    err.PSpec1CIHi=PSy.* BaseCILimsHi;
                    err.PSpec1CILo=PSy.* BaseCILimsLo;
                end
            end
        end
    end
end
