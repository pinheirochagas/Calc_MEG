function [MaxSums]=GetMaxSumPerBinWidth(InDat)
%
%
% Started for Kass Coh Project to find the freq regions with the largest
% difference in coh. b/t Norm and Deaff data.
%
% 100910 Matthew Nelson


len=length(InDat);
MaxSums=repmat(NaN,len,1);
Sums=MaxSums;
for BWdth=1:len
    nRegs=len - (BWdth-1);        
    
    for ix=1:nRegs
        Sums(ix)=abs( nansum( InDat(ix:ix+BWdth-1) ) );
    end
    MaxSums(BWdth)=max(Sums(1:nRegs));
end

