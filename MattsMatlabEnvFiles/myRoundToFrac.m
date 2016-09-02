function out=myRoundToFrac(n,Frac)
%function out=myRoundToFrac(n,Frac)
%
% This will round n to the nearest multiple of Frac. For example,
% myRoundtoFrac(10.345,0.5) gives 10.5 as a result.

out=round(n./Frac).*Frac;