function [out,allinds] =subsamp(X,n,avgFlag)
% function out =subsamp(X,n)
%
% Subsamples a given time series vector (or array). Keeps every nth sample of the
% vector (or array) X, starting over with teh first sample of each row of X
% if X is an array.
%
% If avgFlag is set to on, the will be a running average, of width n. At
% the moment, using avgFlag doesn't work...

if nargin<3 |   isempty(avgFlag)    avgFlag=0;  end

[r c]=size(X);
rowsamps=ceil(c/n);
rowinds=[1:n:(rowsamps-1)*n+1];
allinds=repmat(rowinds,r,1);
out=zeros(r,rowsamps);
if avgFlag
    for irow=1:r
        if isodd(n)         %Note temporally the first sample will be biased towards the middle samples, and teh end sample could be biased either way
            ln=(n-1)/2;
            out(irow,1)=sum(X(irow,1:ln+1))/(ln+1);
            for iind=2:length(rowinds)-1
                out(irow,iind)=sum(X(irow,rowinds(iind)-ln:rowinds(iind)+ln))/n;
            end
            nesamps=c-(rowinds(end)-ln)+1;
            out(irow,end)=sum(X(irow,rowinds(end)-ln:end))/nesamps;        
        else
            %still keep it symmetrical so there's no temporal bias
            ln=(n-2)/2;
            out(irow,1)=(sum(X(irow,1:ln+1)) +.5*X(irow,ln+2) )/(ln+1.5);
            for iind=2:length(rowinds)-1
                out(irow,iind)=(sum(X(irow,rowinds(iind)-ln:rowinds(iind)+ln)) +.5*X(irow,rowinds(iind)+ln+1)+.5*X(irow,rowinds(iind)-ln-1))/n;
            end
            nesamps=c-(rowinds(end)-ln)+1.5;
            out(irow,end)=(sum(X(irow,rowinds(end)-ln:end)) +.5*X(irow,rowinds(end)-ln-1))/nesamps;                         
        end
    end
else
    for irow=1:r
        out(irow,:)=X(irow,rowinds);
    end
end