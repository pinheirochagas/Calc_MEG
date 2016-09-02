function out=myRunAvg(in,winlen)
% function out=myRunAvg(in,winlen)
%
%   Right now it looks like this averages down the rows to produce a
%   running average. A column vector will be trasnposed before performing 
%   this operation.
%
% Performs a running average of length winlen on the data in IN. 
% The length of out is the length of in - winlen +1, so it only spits out 
% the number for which all elements in the average are present.

l=size(in,2);
nr=size(in,1);

%transpose
if l==1 && nr>1     
    in=in';
    l=size(in,2);
    nr=size(in,1);
end

l2=l-winlen+1;
out=zeros(nr,l2);
for ir=1:nr
    for is=1:winlen
        out(ir,:)=out(ir,:)+in(ir,is:is+l2-1);
    end
end
out=out/winlen;