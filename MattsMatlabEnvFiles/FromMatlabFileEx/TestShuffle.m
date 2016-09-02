function TestShuffle(doSpeed)
% Automatic test: Shuffle
% This is a routine for automatic testing. It is not needed for processing and
% can be deleted or moved to a folder, where it does not bother.
%
% TestShuffle(doSpeed)
% INPUT:
%   doSpeed: Optional logical flag to trigger time consuming speed tests.
%            Default: TRUE. If no speed test is defined, this is ignored.
% OUTPUT:
%   On failure the test stops with an error.
%
% Tested: Matlab 6.5, 7.7, 7.8, WinXP
% Author: Jan Simon, Heidelberg, (C) 2010 matlab.THISYEAR(a)nMINUSsimon.de

% $JRev: R0t V:019 Sum:63bBrmUAmlCp Date:24-Mar-2010 13:48:01 $
% $License: BSD (see Docs\BSD_License.txt) $
% $File: Tools\UnitTests_\TestShuffle.m $

% Initialize: ==================================================================
if nargin == 0
   doSpeed = true;
end
if doSpeed
   TestTime = 1;
else
   TestTime = 0.1;
end

% Hello:
ErrID = ['JSim:', mfilename];
whichShuffle = which('Shuffle');
[dum1, dum2, FileExt] = fileparts(whichShuffle);

disp(['==== Test Shuffle:  ', datestr(now, 0), char(10), ...
      'Version: ', whichShuffle, char(10)]);

% Known answer test:
ClassList = {'double', 'single', 'int32', 'int16', 'int8', 'char'};
for iClass = 1:length(ClassList)
   aClass = ClassList{iClass};
   disp(['== ', aClass]);
   R = Shuffle(mycast([], aClass));
   if ~isequal(R, mycast([], aClass))
      error(ErrID, 'SHUFFLE failed for: []');
   end
   
   R = Shuffle(mycast(1, aClass));
   if ~isequal(R, mycast(1, aClass))
      error(ErrID, 'SHUFFLE failed for: [1]');
   end
   
   R = Shuffle(mycast([1, 2], aClass));
   if ~isequal(sort(R), mycast([1, 2], aClass))
      error(ErrID, 'SHUFFLE failed for: [1, 2]');
   end
   
   R = Shuffle(mycast([1; 2], aClass));
   if ~isequal(sort(R), mycast([1; 2], aClass))
      error(ErrID, 'SHUFFLE failed for: [1; 2]');
   end
   
   for i = 1:12
      R = Shuffle(mycast([1, 2, 3], aClass));
      if ~isequal(sort(R), mycast(1:3, aClass))
         error(ErrID, 'SHUFFLE failed for: [1, 2, 3]');
      end
   end
   
   m = mycast(zeros(2000, 5), aClass);
   x = mycast(3:7, aClass);
   for i = 1:2000
      m(i, :) = Shuffle(x);
   end
   m = unique(m, 'rows');
   if ~all(ismember(perms(x), m, 'rows'))
      error(ErrID, 'SHUFFLE does not create all permutations.');
   end
   
   x = mycast(1:127, aClass);
   R = Shuffle(x);
   if ~isequal(x, sort(R))
      error(ErrID, 'SHUFFLE failed for: [1:127].');
   end
   
   % The M-version replies different values due to the random number generator.
   if strcmpi(FileExt, ['.', mexext])
      % Test values after seeding and 3e5 times calling the KISS:
      % If SHUFFLE was compiled with LCC v2.4 (shipped with Matlab), the 64 bit
      % integer arithmetics are wrong. Or the user has implemented another RNG?
      Shuffle('seed', 1234567890);
      for i = 1:1e5
         v = Shuffle(1:3);
      end
      m = Shuffle(1:32);
      if ~isequal(m, [5, 8, 15, 26, 14, 1, 23, 7, 29, 10, 20, 25, 3, 6, 31, ...
               13, 11, 2, 12, 4, 16, 21, 22, 17, 9, 19, 24, 27, 18, 32, 28, 30])
         warning([ErrID, ':UnexpectedValue'], ...
            'Unexpected values after seeding. Compiled with LCC v2.4 ?!');
      end
   end
   
   disp('  ok: known answer tests');
end

% ------------------------------------------------------------------------------
fprintf('\n== Compare speed:\n')

for aDataLen = [10, 100, 1000, 10000, 100000, 1000000]
   Data = 1:aDataLen;
   
   % Determine number of loops:
   iTime = cputime;
   iLoop = 0;
   while cputime - iTime < TestTime
      v = Data(randperm(aDataLen));
      clear('v');   % Suppress JIT acceleration for realistic times
      iLoop = iLoop + 1;
   end
   nDigit = max(1, floor(log10(max(1, iLoop))) - 1);
   nLoop  = max(4, round(iLoop / 10 ^ nDigit) * 10 ^ nDigit);
   
   tic;
   for i = 1:nLoop
      v = Data(randperm(aDataLen));
      clear('v');
   end
   RandPermTime = toc;
   
   tic;
   for i = 1:nLoop
      v = Shuffle(Data);
      clear('v');
   end
   MexTime = toc;
   
   tic;
   for i = 1:nLoop
      v = shuffle_M(Data);
      clear('v');
   end
   MTime = toc;
   
   fprintf('[1 x %d],  %d loops:\n', aDataLen, nLoop);
   fprintf('  X(RANDPERM):       %6.2f sec\n', RandPermTime);
   fprintf('  SHUFFLE(X) as M:   %6.2f sec\n', MTime);
   fprintf('  SHUFFLE(X) as Mex: %6.2f sec  ==>  %.1f%% of RANDPERM\n', MexTime, ...
      100.0 * MexTime / RandPermTime);
end

fprintf('\nSHUFFLE seems to work well.\n');

return;

% ******************************************************************************
function A = mycast(A, ClassName)
% Simulate CAST for Matlab 6
A = feval(ClassName, A);

return;

% ******************************************************************************
function X = shuffle_M(X)
% Fast X(RANDPERM(LENGTH(X))), Knuth's shuffle
% This Matlab version is faster than RANDPERM, but the MEX is faster.
% Author: Jan Simon, Heidelberg, (C) 2010 matlab.THISYEAR(a)nMINUSsimon.de

for i = 1:numel(X)
   w    = ceil(rand * i);
   t    = X(w);
   X(w) = X(i);
   X(i) = t;
end
   
return;
