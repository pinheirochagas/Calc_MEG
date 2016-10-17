function [MaxClusSum,ClusSums,ClusAssign]=FindStatClusOld(TStat,Thresh,NClusCutOff,NormAboveThreshStats)
%function [MaxClusSums,ClusSums,ClusAssign]=FindStatClusOld(TStat,Thresh,NClusCutOff,NormAboveThreshStats)
%
%This FindStatsClus lumps Pos and Neg CLus's together... Clus Assign wil be
%a Pos Clus Number for Pos Clus's, and a Neg Clus Number for Neg Clus's

%set below to 1 to emphasize highly sig ind vals within a cluster, set to 0
%to emphasize the number of sig points within a cluster, i.e. cluster size
%I need to test each with large numbers of shuffles later...
if nargin<4  || isempty(NormAboveThreshStats);      NormAboveThreshStats=0;     end

%you have to go through this once to get pos clus's and once more to get
%neg clus's... if not, then if an above thresh pos postion is adjacent to a
%belwo thresh neg position, they would be put into teh same cluster and the
%resulting sum of the cluster test stat would be degraded as they cancel

[ClusAssign,NClusPos] = bwlabeln(TStat>=Thresh,4);
[ClusAssignNeg,NClusNeg] = bwlabeln(TStat<=-Thresh,4);

%find non-zeros vals and position for both pos and neg clus's
%alternate option done in a few lines- this should be the fastest way to do it...   
[Cli,Clj,Cln] = find(ClusAssign);
[CliNeg,CljNeg,ClnNeg] = find(ClusAssignNeg);

Cli=[Cli; CliNeg];
Clj=[Clj; CljNeg];
Cln=[Cln; ClnNeg+NClusPos];    %renumber the negative clusters so the total cluster number starts at the first number available after the number of positive clusters
NClus=NClusPos+NClusNeg;

%get MaxClusStat
ClusSums=repmat(0,NClus,1);

if NClus<NClusCutOff
    for iCl=1:NClus     %for smaller numbers of cluster, this should be faster
        tmpInds=Cln==iCl;
        ClusSums(iCl)=sum(sum( MultiDimSelect(TStat, Cli(tmpInds),Clj(tmpInds) ) ));
        %ClusSums(iCl)=sum(sum(TStat( Cli(tmpInds),Clj(tmpInds) )));
        if ClusSums(iCl)<0  %if this is a negative clus, combine ClusAssignNeg w/ ClusAssign
            ClusAssign( Cli(tmpInds),Clj(tmpInds) ) = iCl; %-(iCl-NClusPos);
        end
    end
else
    for iv=1:length(Cli)
        ClusSums( Cln(iv) )= ClusSums( Cln(iv) ) + TStat(Cli(iv),Clj(iv));
        if TStat(Cli(iv),Clj(iv))<0
            ClusAssign( Cli(iv),Clj(iv) ) = Cln(iv); %-(Cln(iv)-NClusPos);
        end        
    end
end

%normalize the significance for a continuous transition to a given timepoint being above thresh    
if NormAboveThreshStats
    for iCl=1:NClus
        if ClusSums(iCl)>0
            ClusSums(iCl)=ClusSums(iCl)-Thresh*sum(Cln==iCl);
        elseif ClusSums(iCl)<0
            ClusSums(iCl)=ClusSums(iCl)+Thresh*sum(Cln==iCl);
        end
    end
end

if NClus==0;        MaxClusSum=0;       else        MaxClusSum=max(abs(ClusSums));      end