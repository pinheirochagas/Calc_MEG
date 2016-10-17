function X = Shuffle(X, Seed)
% Shuffle - Random permutation of vector elements
% Y = Shuffle(X)
% Y = Shuffle('seed', N)
% INPUT:
%   X: Row or column vector. For arrays all elements are shuffled.
%      Types: DOUBLE, SINGLE, CHAR, LOGICAL, (U)INT64/32/16/8.
%      This works for CELL, STRUCT arrays also, but shuffling their indices
%      is faster.
%      The length of X is limited to 2^32 elements (34.4GB for DOUBLEs).
%   Seeding: Numerical scalar. For 2 inputs, the integer part of the 2nd input
%      is used to seed the random number generator KISS. Numbers between 0 and
%      2^32 are recommended.
%
% OUTPUT:
%   Y: Array of same type and size as X.
%
% This function is about 60% to 85% faster than: Y = X(randperm(numel(X));
% It uses the Knuth-shuffle algorithm (D. E. Knuth), which is also called
% Fisher-Yates-shuffle. The 32 bit random numbers are created by the cute
% KISS algorithm of George Marsaglia.
% SHUFFLE does not need temporary memory, while RANDPERM uses 2 temporary
% vectors of the same size as X and can exhaust the available free memory.
%
% EXAMPLES:
%   Shuffle('seed', 1234567890);
%   r = Shuffle(1:8)             %  ==> [2, 7, 6, 8, 5, 3, 4, 1]
%   r = Shuffle('abcdefg')       %  ==> 'cbfgade'
%
% To my surprise this works correctly for CELLs and STRUCT arrays also, but
% this is not documented by The MathWorks and may change in the future (tested
% with Matlab 5.3, 6.5, 7.7, 7.8, checked in Testshuffle):
%   r = Shuffle({'string', [], 9})   %  ==> {[], 'string', 9}
% But it is usually faster to permute the indices:
%   c = {'string', [], 9};
%   r = c(Shuffle(1:length(c)));
%
% COMPILATION: See Shuffle.c
%
% Run the unit-test TestShuffle after compiling!
%
% Tested: Matlab 6.5, 7.7, 7.8, 32bit, WinXP, [UnitTest]
%         Compiler: LCC v3.8, BCC 5.5, Open Watcom 1.8, MSVC 2008
% Author: Jan Simon, Heidelberg, (C) 2010 matlab.THISYEAR(a)nMINUSsimon.de
%
% See also RAND, RANDPERM.

% $JRev: R0a V:000 Sum:Zn1RntQtCJmY Date:08-Jun-2004 00:31:37 $
% $License: BSD $
% $File: Tools\GLSets\Shuffle.m $

% Fast X(RANDPERM(LENGTH(X))), Knuth's shuffle
% This Matlab version is faster than RANDPERM, but the MEX is faster.

if nargin == 2
   % Backward compatibility to Matlab 6:
   rand('seed', Seed);  %#ok<RAND>
   return;
end

% Simple Knuth shuffle in forward direction:
for i = 1:numel(X)
   w    = ceil(rand * i);
   t    = X(w);
   X(w) = X(i);
   X(i) = t;
end

return;
