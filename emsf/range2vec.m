function vec = range2vec(range)
%
% function vec = range2vec(range)
%
% Takes a range, like [1 10], and returns a vector with every integer in
% the range, like [1 2 3 4 5 6 7 8 9 10]
%

if length(range)>2
    error('Range must be specified as a 2-element vector.')
end

vec = [range(1):range(2)];

return