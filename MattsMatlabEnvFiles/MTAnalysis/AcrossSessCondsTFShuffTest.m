function err=AcrossSessCondsTFShuffTest(TestStats1,TestStats2,t,f,Nms,ClusShuffOpts,pval)
%function err=AcrossSessCondsTFShuffTest(TestStats,TestStats2,t,f,Nms,ClusShuffOpts,pval)
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
%   TestStats1- a 3D array- [Time x Freq x nSess] of the values for the
%               first condition for each window you would like to test.
%   TestStats2- a 3D array- [Time x Freq x nSess] of the values for the
%               second condition for each window that you would like to
%               test. TIME AND FREQ MUST BE THE SAME SIZE AS TestStats1. Note that
%               this code will test the entiry 2D time-Freq matrix, so only
%               input the time-freq values you wnat to test. HOWEVER- for
%               this type of test only, the numbers of sessions in
%               TestStats1 and TestStats2 don't have to be the same.
%   t-          a 1D vector corresponding to the times of the windows along
%               the first dimeinsion of TestStats
%   f-          a 1D vector corresponding to the frequencies of the windows
%               along the second dimension of TestStats
%   Nms-        The length of the window (in ms) used to calculate
%               TestStats, which is assumed to be either coherence or
%               spectra. This defaults to 200 ms.
%   ClusShuffOpts-  A structure with various options for how to do the
%                   shuffling. See the code below for details.
%   pval-       The pvalue to used to determine which clusters are
%               significant.
%
% Outputs:
%   err-        A structure with the fields Raw, and NormAboveThresh.
%               Raw is a substructure containing the results when
%               NormAboveThresh is set to 0, and NormAboveThresh is a
%               substructure containing results when NormAboveThresh is set
%               to 1. see the help comments in LFP_LFPCoh for more details
%               on what's in those substructures

%%%%%%%%%for debugging, to plot inputs
% iplot=2;
% nrow=4; ncol=1; nplot=4;
% GenTallScrFigSubplot;
% 
% errorbar( f, squeeze(nanmean( TestStats1,3) ), squeeze(sem(TestStats1,3)), 'b' )
% hold on
% errorbar( f, squeeze(nanmean( TestStats2,3) ), squeeze(sem(TestStats2,3)), 'r' )
% set(gca,'XScale','Log','YScale','Log')
% grid on
% AxisAlmostTight

%need to make f a row vector for dimensions later
[r c]=size(f);
if r>c;     f=f';       end


nrecf=length(f);
if nrecf~=size(TestStats1,2) || nrecf~=size(TestStats1,2);       error(['f and TestStats1 or TestStats2 don''t match. Input vector f has ' num2str(nrecf) ' elements, while input array TestStats1 has ' num2str(size(TestStats1,2)) ' elements and TestStats2 has ' num2str(size(TestStats2,2))]);      end
nReps1=size(TestStats1,3);    %nReps is the number of sessions
nReps2=size(TestStats2,3);

%assign fields from ClusShuffOpts to workspace here in beginning, after setting defaults
%%%%%Designing code to automatically test vs. a max stat as wel... (since it d/n take very long to do.... store output in err.Max
%UseMaxStat=0;  %setting this to 1 will use a vs Max stat rather than a vs clus sum stat to determine significance
nShuffs=5000;
%BasePer=[-320 -80]; %in ms- this is the time window corresponding to the baseline period. A given window must be ENTIRELY confined to this interval to be considered to be in the baseline period
ActPer=[0 800]; %in ms- this is the time window corresponding to the activity period, which are all the time periods you wish to test against the baseline period. A given window must be ENTIRELY confined to this interval to be considered to be in the activity period
Thresh=1.96;
NClusCutOff=6;    %To improve speed, the algorithm operates two different ways (with the same result) based on the number of clusters in a given shuffle- one way is faster if there are more clusters and one way is faster if there are fewer clusters. This value sets the cutoff number of clusters value to determine which algorithm to use on a particular shuffle
fk=[0 100];

TestCohSumForAllFreqs=0;    %if set to 1, the coherence difference at all freqs will simply be averaged as the test statistic
UseTTest=0;     %set to 1 to use t-tests to test the MEAN rather than teh median at each point
UseRawCohAvgStats=0;    %the user can set this to 1 (via ClusShuffOpts) to use as the Tstat each shuffle the difference of the magnitude of the raw (coherent) average at each frequencies, instead of the ranksum z-statistic
DontTakeAbsVal=0;

%I'm considering removing the below as an option and instead outputting both values for eth same shuffling
%ClusShuffOpts.NormAboveThreshStats=1;   %if set to 1, when calc'ing clus sums, this sums the difference from the thresh of each test stat above thresh val, not the raw test stat val
%Setting to 1 will make the test more sensitive to indivdiual time and freq values way above thresh (i.e. for smaller clusters with more activation) and setting it 0 makes the test more sensitive to broader time-freq clusters of activation with individual values not as far above the threshhold
%In practice, there are subtle but not major differences b/t setting this to 1 or 0

if nargin < 5 || isempty(Nms);      Nms=200;      end
if nargin < 7 || isempty(pval);      pval=0.05;      end

%this takes any field in ClusShuffOpts and adds it to the workspace, thus
%writing over any defaults above if desired by the user input
if(nargin>=5) && ~isempty(ClusShuffOpts)
    fieldlist=fieldnames(ClusShuffOpts);
    for ifld=1:length(fieldlist)
        if length(ClusShuffOpts.(fieldlist{ifld}))>1
            eval([fieldlist{ifld} '=[' num2str(ClusShuffOpts.(fieldlist{ifld})) '];']);
        else
            eval([fieldlist{ifld} '=' num2str(ClusShuffOpts.(fieldlist{ifld})) ';']);
        end
    end
end

if ~UseRawCohAvgStats && ~DontTakeAbsVal
    TestStats1=abs(TestStats1);
    TestStats2=abs(TestStats2);
end

%Only need to find wins that are in ActPer
tst=t-Nms/2;
te=t+Nms/2;
%InBasePer=isbetween(tst,BasePer) & isbetween(te,BasePer); %T or F based on whether a given window is completely within the baseline window
InActPer=isbetween(tst,ActPer) & isbetween(te,ActPer); %T or F based on whether a given window is completely within the baseline window
%nInBasePer=sum(InBasePer);
nInActPer=sum(InActPer);

%separate TestStats into Act1All and Act2All
%BaseAll=TestStats(InBasePer,:,:);
Act1All=TestStats1(InActPer,:,:);
Act2All=TestStats2(InActPer,:,:);

Infk=isbetween(f,fk);
Act1All=Act1All(:,Infk,:);
Act2All=Act2All(:,Infk,:);

f=f(Infk);
nrecf=length(f);

TotActAll=cat(3,Act1All,Act2All);

disp(['Starting Cluster Shuffling, ' num2str(nShuffs) ' Shuffs to do'])
MaxClusStat=repmat(0,nShuffs,2);
if TestCohSumForAllFreqs
    MaxStat=repmat(0,nShuffs,nInActPer);
    curTStat=repmat(0,1,nInActPer);
else
    MaxStat=repmat(0,nShuffs,1);
    curTStat=repmat(0,nrecf,nInActPer);
end

if UseRawCohAvgStats
    TStatNulls=repmat(NaN,[nInActPer nrecf nShuffs]);
end

%diff # of Reps for each stat type in this shuffling program
ShuffAct1=repmat(0,[nInActPer, nrecf, nReps1]);  %this matches the dims in the incput TestStats, but is different form teh dims in the within session stats code in LFP_LFPCoh, etc.
ShuffAct2=repmat(0,[nInActPer, nrecf, nReps2]);

tic
for iS=1:nShuffs
    if mod(iS,100)==0;      disp(['OnShuff:' num2str(iS)]);     end
    
    tmpInds=randperm( nReps1+nReps2 );
    ShuffAct1=TotActAll( :,:,tmpInds(1:nReps1) );
    ShuffAct2=TotActAll( :,:,tmpInds(nReps1+1:end) );
    
    if TestCohSumForAllFreqs
        for iW=1:nInActPer
            MaxStat(iS,iW)= abs( nanmean(nanmean( ShuffAct1(iW,:,:) )) - nanmean(nanmean( ShuffAct2(iW,:,:) )) ); %we do want an abs val test here... which makes the test a two sided test...
        end
    else
        
        if UseRawCohAvgStats
            for iF=1:nrecf
                for iW=1:nInActPer                  %use mean and not nanmean, as this should be a little faster, and this operation below will be done ALOT
                    TStatNulls(iW,iF,iS)= abs(nanmean( squeeze( ShuffAct1(iW,iF,:) ) )) - abs(nanmean( squeeze( ShuffAct2(iW,iF,:) ) ));
                end
            end
        else
            if UseTTest
                for iF=1:nrecf
                    for iW=1:nInActPer
                        [~,p]=ttest2( squeeze( ShuffAct1(iW,iF,:) ),squeeze( ShuffAct2(iW,iF,:) ) );
                        curTStat(iF,iW)=norminv(1-p/2,0,1);   %here the resulting curTStat will only be positive
                        if nanmean(ShuffAct2(iW,iF,:)) > nanmean( ShuffAct1(iW,iF,:) )
                            curTStat(iF,iW)=-curTStat(iF,iW);   %here we turn the given curTStat negative if needed
                        end
                    end
                end
            else
                for iF=1:nrecf
                    for iW=1:nInActPer
                        [~, ~, stats]=my_ranksum(squeeze( ShuffAct1(iW,iF,:) ),squeeze( ShuffAct2(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                        curTStat(iF,iW)=stats.zval;
                    end
                end
            end
            
            %MaxStat(iS,:)=MaxConsecSignLen( nanmean(ShuffAct1,3)-nanmean(ShuffAct2,3) );
            
            %if UseMaxStat
            MaxStat(iS,:)=max(max( abs(curTStat) ));
            %else
            MaxClusStat(iS,:)=FindStatClus(curTStat,Thresh,NClusCutOff);
            %end
        end
    end
    
    if iS==1
        disp('For first Shuff: ');
        toc
        tmptim=toc;
        disp(['Shuffling should be done in about ' num2str( ClusShuffOpts.nShuffs*tmptim/60 ) ' minutes'])
    end
end

disp(['Done Shuffling'])

err.wintimes=t(InActPer); %these will be the center of each time win

%curTStat needs to have Freqs down dim 1 and win down dim 2
if TestCohSumForAllFreqs
    err.AllFreqsCohDiffP=repmat(NaN,1,nInActPer);
    for iW=1:nInActPer
        curTStat(iW)= abs( nanmean(nanmean( Act1All(iW,:,:) )) - nanmean(nanmean( Act2All(iW,:,:) )) ); %we do want an abs val test here... which makes the test a two sided test...
        err.AllFreqsCohDiffP(iW)= sum( MaxStat>=curTStat(iW) )/nShuffs;
    end
else
    if UseRawCohAvgStats
        TStatMns=mean(TStatNulls,3);
        DevsFromMn=abs(TStatNulls-repmat(TStatMns,[1 1 nShuffs]));
        
        MaxStat=squeeze( max( max(DevsFromMn,[],1),[],2 ) );
        
        for iF=1:nrecf
            for iW=1:nInActPer
                curTStat(iF,iW)= abs(nanmean( squeeze( Act1All(iW,iF,:) ) )) - abs(nanmean( squeeze( Act2All(iW,iF,:) ) )) - TStatMns(iW,iF);
            end
        end
    else
        if UseTTest
            for iF=1:nrecf
                for iW=1:nInActPer
                    %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on teh same scale as the other test stats (i.e. teh Fisher transform, or zpf for coh.
                    [~,p]=ttest2( squeeze( Act1All(iW,iF,:) ),squeeze( Act2All(iW,iF,:) ) );
                    curTStat(iF,iW)=norminv(1-p/2,0,1);   %here the resulting curTStat will only be positive
                    if nanmean(Act2All(iW,iF,:)) > nanmean( Act1All(iW,iF,:) )
                        curTStat(iF,iW)=-curTStat(iF,iW);   %here we turn the given curTStat negative if needed
                    end
                end
            end
        else
            for iF=1:nrecf
                for iW=1:nInActPer
                    %to go with the zvals... One disadvantage with zvals is that they are only approximate, and may not be as accurate with low numbers of trials... but they output the test stat on teh same scale as the other test stats (i.e. teh Fisher transform, or zpf for coh.
                    [~, ~, stats]=my_ranksum(squeeze( Act1All(iW,iF,:) ),squeeze( Act2All(iW,iF,:) ),'method','approximate');    %These approximate values are easier to work with and to know how to threshhold, among other things...
                    curTStat(iF,iW)=stats.zval;
                end
            end
        end
    end
    
    %if UseMaxStat
    err.Max=CalcMaxSig( curTStat',MaxStat,nShuffs,err.wintimes,f,pval );
    %else
    if ~UseRawCohAvgStats
        [err.Raw err.NormAboveThresh]=CalcClusSig( curTStat,MaxClusStat,Thresh,NClusCutOff,nShuffs,err.wintimes,f,pval );
    end
    %end
    
end