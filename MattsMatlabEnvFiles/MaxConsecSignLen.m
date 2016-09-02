function MaxnConsec=MaxConsecSignLen(A)
%function MaxnConsec=MaxConsecSignLen(A)
%
% Return the maximum length of any run of consecutive positive or negative
% valuesbin the input data vector A. (assumed to be a vector presently in 
% this code.)
%
% created 100321 by MJN

%convert A to a column vector if it wasn't already
[r c]=size(A);
if c>r;     A=A';   end
nA=size(A,1);

A2=repmat(1,nA,1);
A2(A==0)=NaN;   %NaN's will kill any run, which is what we want here for the zero values
A2(A<0)=-1;

dA2=diff(A2);
MaxnConsec=max( diff( [0; find(dA2~=0); nA] ) );

