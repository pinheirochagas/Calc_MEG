function out = isodd(input)
% function out = iseven(input)
%
% outputs a one for each position in the array input that is even 
% (i.e. divisible by two).

out=(~iseven(input) & isint(input));