// Shuffle.c
// Random permutation of vector elements
// Y = Shuffle(X)
// Y = Shuffle('seed', N)
// INPUT:
//   X: Row or column vector. For arrays all elements are shuffled.
//      Types: DOUBLE, SINGLE, CHAR, LOGICAL, (U)INT64/32/16/8.
//      This works for CELL, STRUCT arrays also, but shuffling their indices
//      is faster.
//      The length of X is limited to 2^32 elements (34.4GB for DOUBLEs).
//   Seeding: Numerical scalar. For 2 inputs, the integer part of the 2nd input
//      is used to seed the random number generator KISS. Numbers between 0 and
//      2^32 are recommended.
//
// OUTPUT:
//   Y: Array of same type and size as X.
//
// This function is about 60% to 85% faster than: Y = X(randperm(numel(X));
// It uses the Knuth-shuffle algorithm (D. E. Knuth), which is also called
// Fisher-Yates-shuffle. The 32 bit random numbers are created by the cute
// KISS algorithm of George Marsaglia.
// SHUFFLE does not need temporary memory, while RANDPERM uses 2 temporary
// vectors of the same size as X and can exhaust the available free memory.
//
// EXAMPLES:
//   Shuffle('seed', 1234567890);
//   r = Shuffle(1:8)             %  ==> [2, 7, 6, 8, 5, 3, 4, 1]
//   r = Shuffle('abcdefg')       %  ==> 'cbfgade'
//
// To my surprise this works correctly for CELLs and STRUCT arrays also, but
// this is not documented by The MathWorks and may change in the future (tested
// with Matlab 5.3, 6.5, 7.7, 7.8, checked in Testshuffle):
//   r = Shuffle({'string', [], 9})   %  ==> {[], 'string', 9}
// But it is faster to permute the indices (shared data copies!):
//   c = {'string', [], 9};
//   r = c(Shuffle(1:length(c)));
//
// COMPILATION:
//   mex -O Shuffle.c
// Stricter input check to reject CELLs and STRUCT arrays, which are treated as
// array of the type mwSize (undocumented Matlab feature):
//   mex -O -DRESTRICT_INPUT_TYPE Shuffle.c
// Linux: consider C99 comment style:
//   mex -O CFLAGS="\$CFLAGS -std=C99" Shuffle.c
// Precompiled Mex: http://www.n-simon.de/mex
//
// Run the unit-test TestShuffle after compiling!
//
// Tested: Matlab 6.5, 7.7, 7.8, 32bit, WinXP, [UnitTest]
// Compiler: LCC v3.8, BCC 5.5, Open Watcom 1.8, MSVC 2008
//         Compatibility to other Matlab versions, Mac and Linux is assumed.
//         LCC v2.4 shipped with Matlab does not work correctly with 64 bit
//         integers: Shuffle.c can be compiled using signed long long variables,
//         but the results differ from the expectations. The free LCC v3.8 from
//         the net download works well.
// Author: Jan Simon, Heidelberg, (C) 2010 matlab.THISYEAR(a)nMINUSsimon.de
//
// See also RAND, RANDPERM.

/*
% $JRev: R0b V:002 Sum:IKLtX6yB5L8g Date:24-Mar-2009 22:08:44 $
% $License: BSD (see Docs\BSD_License.txt) $
% $File: Tools\Mex\Source\Shuffle.c $
% History:
% 001: 24-Mar-2010 10:51, Stable version.
*/

#include "mex.h"
#include "tmwtypes.h"

// For unknown reasons LCC v2.4 cannot compile KISS for unsigned long long, and
// calculates unexpected values for signed long long. LCC v3.8 from the net
// works well.
#if defined(__LCC__)
typedef unsigned long long ULONG64;
#else
typedef uint64_T ULONG64;
#endif

// Assume 32 bit addressing for Matlab 6.5:
// See MEX option "compatibleArrayDims" for MEX in Matlab >= 7.7.
#ifndef MWSIZE_MAX
#define mwSize  int32_T           // Defined in tmwtypes.h
#define mwIndex int32_T
#define MWSIZE_MAX MAX_int32_T
#endif

// Random number generator:
static unsigned long kx = 123456789, ky = 362436000, kz = 521288629,
                     kc = 7654321;
unsigned long KISS(void);

// Prototypes:
void Core8(double  *X, mwSize N);
void Core4(int32_T *X, mwSize N);
void Core2(int16_T *X, mwSize N);
void Core1(int8_T  *X, mwSize N);

// Main function ===============================================================
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  mwSize n;
  unsigned long Seed;
  
  // Check number of inputs, seed KISS for 2 inputs:
  if (nrhs == 2) {  // Seed and warm up:
     if (mxGetElementSize(prhs[1]) < 4 || mxGetNumberOfElements(prhs[1]) != 1) {
        mexErrMsgIdAndTxt("JSim:Shuffle:BadSeed",
                          "Input [Seed] must be a numeric scalar.");
     }
     Seed = (unsigned long) mxGetScalar(prhs[1]);
     kx   =  123456789 ^ Seed ^ 1;
     ky   =  362436000 ^ Seed ^ 2;
     kz   =  521288629 ^ Seed ^ 4;
     kc   = (698769069 ^ Seed ^ 8) % 698769069;  // Actually no need to seed kc
     
     // Warm up - not necessarily needed also:
     n = 64 + KISS() % 63;
     while (n--) {
        KISS();
     }
     return;
     
  } else if (nrhs != 1) {
     mexErrMsgIdAndTxt("JSim:Shuffle:BadNInput", "1 or 2 inputs required.");
  }
  
  // Check number of outputs - [ans] is set for nlhs==0:
  if (nlhs > 1) {
     mexErrMsgIdAndTxt("JSim:Shuffle:BadNInput", "1 output allowed.");
  }
  
#ifdef RESTRICT_INPUT_TYPE
  // The method works for STRUCT arrays and CELLs also, but this is not
  // documented by The MathWorks! This stricter test rejects unexpected inputs:
  if (!mxIsNumeric(prhs[0]) && !mxIsChar(prhs[0])) {
     mexErrMsgIdAndTxt("JSim:Shuffle:BadInputType",
                       "The input must be numeric or a string.");
  }
#endif

  // Limit input size on 64-bit systems, because KISS replies just 32 bits:
  // A 64 bit KISS is easy to create - mail me on demand!
  n = mxGetNumberOfElements(prhs[0]);
  if ((n >> 31) > 2) {  // n > 4294967296, for 32 and 64 bit mwSize
     mexErrMsgIdAndTxt("JSim:Shuffle:ToLargeInput",
                       "The input array is limited to 4294967296 elements.");
  }
  
  // Create the output with the same size, type and data as the input:
  plhs[0] = mxDuplicateArray(prhs[0]);
  
  // Call different functions depending on the number of bytes per element:
  switch (mxGetElementSize(plhs[0])) {
    case 8:  Core8(            mxGetPr(plhs[0]),   n);  break;
    case 4:  Core4((int32_T *) mxGetData(plhs[0]), n);  break;
    case 2:  Core2((int16_T *) mxGetData(plhs[0]), n);  break;
    case 1:  Core1((int8_T  *) mxGetData(plhs[0]), n);  break;
    default:
       mxDestroyArray(plhs[0]);
       mexErrMsgIdAndTxt("JSim:Shuffle:BadInputType", "Unknown input type.");
  }
  
  return;
}

// =============================================================================
unsigned long KISS(void) {
  // George Marsaglia: Keep It Simple Stupid
  // Features: 32 bit numbers, solve DIEHARD test, period > 2^124 (== 2.1e37)
  
#if (defined(__BORLANDC__) && __BORLANDC__ >= 0x530)
  ULONG64 t, a = 698769069UL;
#else
  ULONG64 t, a = 698769069ULL;
#endif

  kx  = 69069 * kx + 12345;
  ky ^= ky << 13;
  ky ^= ky >> 17;
  ky ^= ky << 5;
  t   = a * kz + kc;
  kc  = t >> 32;
  
  return kx + ky + (kz = t);
}

// =============================================================================
void Core8(double *X, mwSize n)
{
  // Knuth or Fisher-Yates shuffle for DOUBLE and (U)INT64.
  // The 32 bit random number created by KISS is *not* truncated by MOD or DIV
  // to avoid any bias.
  
  double t;
  mwSize w;

  while (n > 0) {
     w    = (mwSize) ((double) n * KISS() / 4294967296.0);   // 0 <= w <= n-1
     t    = X[w];
     X[w] = X[--n];
     X[n] = t;
  }

  return;
}

// =============================================================================
void Core4(int32_T *X, mwSize n)
{
  // Knuth or Fisher-Yates shuffle for SINGLE and (U)INT32.
  // To my surprise this works for CELL and STRUCT arrays also.
  int32_T t;
  mwSize  w;

  while (n > 0) {
     w    = (mwSize) ((double) n * KISS() / 4294967296.0);   // 0 <= w <= n-1
     t    = X[w];
     X[w] = X[--n];
     X[n] = t;
  }

  return;
}

// =============================================================================
void Core2(int16_T *X, mwSize n)
{
  // Knuth or Fisher-Yates shuffle for CHAR and (U)INT16.
  int16_T t;
  mwSize  w;

  while (n > 0) {
     w    = (mwSize) ((double) n * KISS() / 4294967296.0);   // 0 <= w <= n-1
     t    = X[w];
     X[w] = X[--n];
     X[n] = t;
  }

  return;
}

// =============================================================================
void Core1(int8_T *X, mwSize n)
{
  // Knuth or Fisher-Yates shuffle for (U)INT8 and LOGICAL.
  int8_T t;
  mwSize w;
  
  while (n > 0) {
     w    = (mwSize) ((double) n * KISS() / 4294967296.0);   // 0 <= w <= n-1
     t    = X[w];
     X[w] = X[--n];
     X[n] = t;
  }

  return;
}
