function [RegListFirstInd,DiffVals]=RankMaxDiffRegions(InDat1,InDat2,BWdth)
%
%
% Started for Kass Coh Project to find the freq regions with the largest
% difference in coh. b/t Norm and Deaff data.
%
% 100910 Matthew Nelson

if nargin < 3 || isempty(BWdth)
    disp(['In RankMaxDiffRegions, setting BWdth to 4'])
    BWdth=4;
end

[r1 c1]=size(InDat1);
[r2 c2]=size(InDat2);
if r1~=r2
    if r1==c2
        InDat2=InDat2';
    else
        error('In RankMaxDiffRegions, matrix inputs must have the same size')
    end
elseif c1~=c2
    error('In RankMaxDiffRegions, matrix inputs must have the same size')
end

nRegs=length(InDat1)- (BWdth-1);
RegListFirstInd(1:nRegs,1)=1:nRegs;
DiffVals=repmat(NaN,nRegs,1);

for ix=1:nRegs
    DiffVals(ix)=nansum( InDat1(ix:ix+BWdth-1)-InDat2(ix:ix+BWdth-1) );
end

[~,I]=sort(abs(DiffVals),1,'descend');
DiffVals=DiffVals(I);
RegListFirstInd=RegListFirstInd(I);
    
