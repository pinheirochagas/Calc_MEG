function err=AcrossSessWInConds1DShuffTest_AllFreqBinSizes (TestStats1,TestStats2,f,ClusShuffOpts,alpha)
%function err=AcrossSessWInConds1DTFShuffTest(TestStats,TestStats2,f,ClusShuffOpts,alpha)
%
% Like AcrossSessTFShuffTest, but instead of comparing TestSats in the
% activation period to the baseline period, this compares TestStats1 to
% TestStats2 at every time and frequency location in each. This code enacts
% a between sessions test.
%
% Note that this program does a between sessions test- i.e. it compares the
% values from one group of types of sessions to the values of a totally
% different set of types of sessions where the numbers of sessions in each
% group don't necessarily have to match up. Look to
% AcrossSessWInSessCondsTFShuffTest for the more common (for monkey
% neuroscience) within sessions test, used for example if you wanted to
% compare set size 2 and 4 across sessions where data for each set size was
% gathered in ecah session.
%
% It is assumed that the values of TestStat correspond to the (possibly
% transformed) values for measures like coherence or power spectra, not
% something like the raw Fourier components from which these values should
% be calculated after shuffling.
%
% This program will simply test the means in TestStats1 vs TestStats2 using
% a signed rank test and shuffling and clustering procedure to determine
% significance. A positive result means that TestStats1 is higher than
% TestStats2, while the reverse is true of a negative result.
%
% Note- this is a MAGNITUDE based test. Inputs will be transformed to their
% magnitudes before performing the shuffling and test.
%
% Note that this still uses the ActPer ClusShuffOpt, and it will analyze
% time windows falling within ActPer.
%
% WARNING- your code should check that there are no Nan's in the inputs to
% this function...
%
% Inputs:
%   TestStats1- a 2D array- [nReps x Freq] of the values for the
%               first condition for each window you would like to test.
%   TestStats2- a 2D array- [nReds x Freq] of the values for the
%               second condition for each window that you would like to
%               test. TIME AND FREQ MUST BE THE SAME SIZE AS TestStats1. Note that
%               this code will test the entiry 2D time-Freq matrix, so only
%               input the time-freq values you wnat to test. HOWEVER- for
%               this type of test only, the numbers of sessions in
%               TestStats1 and TestStats2 don't have to be the same.
%   f-          a 1D vector corresponding to the frequencies of the windows
%               along the second dimension of TestStats
%   ClusShuffOpts-  A structure with various options for how to do the
%                   shuffling. See the code below for details.
%   alpha-       The pvalue to be used to determine which clusters are
%               significant.
%
% Outputs:
%   err-        A structure with the fields Raw, and NormAboveThresh.
%               Raw is a substructure containing the results when
%               NormAboveThresh is set to 0, and NormAboveThresh is a
%               substructure containing results when NormAboveThresh is set
%               to 1. see the help comments in LFP_LFPCoh for more details
%               on what's in those substructures
%
%               ... Note that the output START with a bin size of one- i.e.
%               so the first element in the array BestFinPValsPerBW give
%               the bets pval for a bin width of 1, the second gives the
%               best pvals for a bin width of two, ... etc... 

nReps=size(TestStats1,1);    %nReps is the number of sessions
if nReps~=size(TestStats2,1);       error('Number of sess in TestStats1 and TestStats2 don''t match, which is necessary for the within sessions across sessions test this code runs.');      end

%assign fields from ClusShuffOpts to workspace here in beginning, after setting defaults
%%%%%Designing code to automatically test vs. a max stat as wel... (since it d/n take very long to do.... store output in err.Max
%UseMaxStat=0;  %setting this to 1 will use a vs Max stat rather than a vs clus sum stat to determine significance
nShuffs=5000;
fk=[0 100];

DontTakeAbsVal=1;    

%I'm considering removing the below as an option and instead outputting both values for eth same shuffling
%ClusShuffOpts.NormAboveThreshStats=1;   %if set to 1, when calc'ing clus sums, this sums the difference from the thresh of each test stat above thresh val, not the raw test stat val
%Setting to 1 will make the test more sensitive to indivdiual time and freq values way above thresh (i.e. for smaller clusters with more activation) and setting it 0 makes the test more sensitive to broader time-freq clusters of activation with individual values not as far above the threshhold
%In practice, there are subtle but not major differences b/t setting this to 1 or 0

if nargin < 5 || isempty(alpha);      alpha=0.05;      end

%this takes any field in ClusShuffOpts and adds it to the workspace, thus
%writing over any defaults above if desired by the user input
if(nargin>=4) && ~isempty(ClusShuffOpts)
    fieldlist=fieldnames(ClusShuffOpts);
    for ifld=1:length(fieldlist)
        if length(ClusShuffOpts.(fieldlist{ifld}))>1
            eval([fieldlist{ifld} '=[' num2str(ClusShuffOpts.(fieldlist{ifld})) '];']);
        else
            eval([fieldlist{ifld} '=' num2str(ClusShuffOpts.(fieldlist{ifld})) ';']);
        end
    end
end

if ~DontTakeAbsVal
    TestStats1=abs(TestStats1);
    TestStats2=abs(TestStats2);
end

%separate TestStats into Act1All and Act2All
Infk=isbetween(f,fk);
Act1All=TestStats1(:,Infk);
Act2All=TestStats2(:,Infk);

f=f(Infk);
nrecf=length(f);

%TotActAll=cat(1,Act1All,Act2All);

disp(['Starting Cluster Shuffling, ' num2str(nShuffs) ' Shuffs to do'])

%diff # of Reps for each stat type in this shuffling program
ShuffAct1=repmat(0,[nReps nrecf]);  %this matches the dims in the input TestStats, but is different form the dims in the within session stats code in LFP_LFPCoh, etc.
ShuffAct2=repmat(0,[nReps nrecf]);

%here we first need to get through all of the shuffles and save the values for every shuffle befor egetting a null distribution...     
MaxSums=repmat(NaN,[nShuffs, nrecf]);
err.PValDist=repmat(NaN,[nShuffs, 1]);
tic
for iS=1:nShuffs
    if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
    
    tmprand=rand( nReps,1 );
    KeepAct1=tmprand<0.5;    
    
    for iR=1:nReps
        if KeepAct1(iR)
            ShuffAct1( iR,: )=Act1All( iR,: );                        
            
            ShuffAct2( iR,: )=Act2All( iR,: );            
        else
            ShuffAct1( iR,: )=Act2All( iR,: );            
            
            ShuffAct2( iR,: )=Act1All( iR,: );             
        end
    end 
    
    %tmpInds=randperm( nReps1+nReps2 );
    %ShuffAct1=TotActAll( tmpInds(1:nReps1),: );
    %ShuffAct2=TotActAll( tmpInds(nReps1+1:end),: );
    
    %for iW=1:nInActPer    
    curDiffs= nanmean( ShuffAct1 ) - nanmean( ShuffAct2 ); %we do want an abs val test here... which makes the test a two sided test...    
    %end
        
    MaxSums(iS,:)=GetMaxSumPerBinWidth(curDiffs);
               
    if iS==1
        disp('For first Shuff: ');
        toc
        tmptim=toc;
        disp(['Shuffling should be done in about ' num2str( nShuffs*tmptim/60 ) ' minutes'])
        %disp('But be aware that after the shuffling there is more stuff that needs to be done and I''m not sure how long that will take')
    end
end
    
disp('Done With First Shuffling')
disp('Now get p-value distribution')


%RANDI(IMAX,M,N)
tmpInds=randi(nShuffs,nShuffs,1);
for iiS=1:nShuffs
    iS=tmpInds(iiS);
    err.PValDist(iiS) = min(sum( MaxSums >= repmat( MaxSums(iS,:),nShuffs,1 ) )) / nShuffs;
end
err.PValDist=sort( err.PValDist,1,'ascend' );
tmpInd=ceil(alpha*nShuffs);
if isinteger(alpha*nShuffs);     tmpInd=tmpInd+1;        end
err.critPVal=err.PValDist( tmpInd );    %the raw pval must be LESS than this to be considered to eb significant        

%[RegListFirstInd,DiffVals]=RankMaxDiffRegions(InDat1,InDat2,BWdth);
MnDiffs= nanmean( Act1All ) - nanmean( Act2All );

%initialize outputs
err.BestRawPValsPerBW=repmat(NaN,nrecf,1);
err.BestFinPValsPerBW=err.BestRawPValsPerBW;
err.BestFirstInd=err.BestRawPValsPerBW;
err.BestPoolTtestPval=err.BestRawPValsPerBW;
err.BestMnDiffTtestPval=err.BestRawPValsPerBW;

err.AllRawPValsPerBW=cell(nrecf,1);
err.AllAdjPValsPerBW=err.AllRawPValsPerBW;
err.AllPoolTtestPValsPerBW=err.AllRawPValsPerBW;
err.AllMnDiffTtestPValsPerBW=err.AllRawPValsPerBW;
for BWdth=1:nrecf
    nRegs=nrecf - (BWdth-1);
    
    err.AllRawPValsPerBW{BWdth}=repmat(NaN,nRegs,1);
    err.AllAdjPValsPerBW{BWdth}=err.AllRawPValsPerBW{BWdth};
    err.AllPoolTtestPValsPerBW{BWdth}=err.AllRawPValsPerBW{BWdth};
    err.AllMnDiffTtestPValsPerBW{BWdth}=err.AllRawPValsPerBW{BWdth};
    for ix=1:nRegs
        csum=abs( sum( MnDiffs(ix:ix+BWdth-1) ) );     %assume no nansums to save time    
        err.AllRawPValsPerBW{BWdth}(ix)= sum( MaxSums(:,BWdth) >=csum )/nShuffs;
        err.AllAdjPValsPerBW{BWdth}(ix)= sum( err.PValDist <= err.AllRawPValsPerBW{BWdth}(ix) )/nShuffs;
        
        %here were pooling all the trials from all over the bin to do a p-value test...    
        [~, err.AllPoolTtestPValsPerBW{BWdth}(ix)]= ttest( Act1All( nReps*(ix-1)+1:nReps*(ix-1+BWdth) ),Act2All( nReps*(ix-1)+1:nReps*(ix-1+BWdth) ) );    %using a 1 dimensional indexing of the Act1All and Act2All arrays

        if BWdth==1
            err.AllMnDiffTtestPValsPerBW{BWdth}(ix)=1;
        else
            [~, err.AllMnDiffTtestPValsPerBW{BWdth}(ix)]= ttest( MnDiffs(ix:ix+BWdth-1) );    %using a 1 dimensional indexing of the Act1All and Act2All arrays
        end
    end
                
    [vals, I]=sort( err.AllRawPValsPerBW{BWdth},1,'ascend' );
    err.BestRawPValsPerBW(BWdth)=vals(1);
    err.BestFirstInd(BWdth)=I(1);
    
    err.BestFinPValsPerBW(BWdth)=err.AllAdjPValsPerBW{BWdth}( I(1) );
    
    err.BestPoolTtestPval(BWdth) =err.AllPoolTtestPValsPerBW{BWdth}( I(1) );
    err.BestMnDiffTtestPval(BWdth) =err.AllMnDiffTtestPValsPerBW{BWdth}( I(1) );
end

err.BestSigBWAssign=repmat(0,nrecf,1);
err.BestSigBWAssign_PoolTtest=err.BestSigBWAssign;
err.BestSigBWAssign_MnDiffTtest=err.BestSigBWAssign;
err.TieFlag=0;

[minFinP minFinPInd]= min( err.BestFinPValsPerBW );
if minFinP < alpha
    if sum( err.BestFinPValsPerBW==minFinP ) > 1
        err.TieFlag=1;
        
        [minPoolP minPoolPInd]= min( err.BestPoolTtestPval );
        err.BestSigBWAssign_PoolTtest( err.BestFirstInd(minPoolPInd):err.BestFirstInd(minPoolPInd)+minPoolPInd-1 ) =1;
        
        [minMnDiffP minMnDiffPInd]= min( err.BestMnDiffTtestPval );
        err.BestSigBWAssign_MnDiffTtest( err.BestFirstInd(minMnDiffPInd):err.BestFirstInd(minMnDiffPInd)+minMnDiffPInd-1 ) =1;
    else
        err.BestSigBWAssign( err.BestFirstInd(minFinPInd):err.BestFirstInd(minFinPInd)+minFinPInd-1 ) =1;
    end
end
    
    
    
