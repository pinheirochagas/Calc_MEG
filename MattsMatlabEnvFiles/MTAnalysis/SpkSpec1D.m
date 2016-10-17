function [Sx,f,PSx,N,err,tmpdf1] = SpkSpec1D(Dat1_1D,bn,nTr,TrLen,options)
%function [Sx,f,PSx,N,err,tmpdf1] = SpkSpec1D(Dat1_1D,bn,nTr,TrLen,options)
%
% The 1-dimensional Spk spectrum. Given a 1 x N input data vector (i.e. one
% deminsional data) this will break that data up into "trials", i.e. equal
% segments of data, and perform the usual MT analysis on that using
% SpkSpec, but does so without sliding the window in time at all, so the
% output only varies with frequency.
%
% Note that the bn input is needed... BUT this isn't the same tr by tr bn
% Input as in the other MT anal code... here it is the start and stop of 
% the experiment to know to when to create the start and stop of the 
% experiment when chopping the data into trials.
%
% Inputs:
%   Dat1_1D:    A 1D vector of input Spike data, in the form of spike times
%   bn:         The start and stop time of the experiment, needed to know
%               for chopping into trials. Defaults to using the first and
%               last spike in the recording. Needs to be referenced to teh
%               same event the Spike times in Dat1_1D are.
%   nTr:        The number of trials to parse InDat into, using 
%               Parse1DLFPIntoTrs.m ... Defaults to 20 if TrLen not entered
%               either. See comment below for more info..
%   TrLen:      The length of the trial (in ms) to parse input data into.
%   options:    A structure containing all of the options for the MT
%               Analysis. See the optional options input described in
%               SpkSpec for more details
%
%               Note that certain fields for options will be overwritten 
%               even if they are entered in in options... these are tapers,
%               bn, and dn. These are because in order to do the 1D
%               analysis, these can't change.
%
% Outputs:
%   Sx:         A 1 x nFreq vector indicaing the LFP spectrum at each
%               freq. see SpkSpec for more details.
%	f:  		Units of frequency for Sx.
%   PSx:        Partial spectrum.
%   N:          The length of the window ("trial length") ultimately used
%   err:        MT Analysis error structure.
%   tmpdf1:     Df used for error structure
%
%   Note that the program uses nTr for the parsing if both nTr and TrLen
%   are enetred. To instead use TrLen, input an empty matrix for nTr. nTr
%   defaults to 20 if neither nTr nor TrLen are input or if they are
%   enterred as empty matrices.
%
%   Note that data at the end of InDat may likely be cutoff if the number
%   of samples aren't evenly divided into the given number of trials or
%   given length of each trial.
%
%   Right now this defaults to an Fs of 1000, unless otherwise entered.
%
%   Note that for now, this assumes the use of only one taper... more 
%   tapers are possible to do, but this would require changes to the code..
%
%   Note that for these 1D cases without behavior, the statistical testing
%   against zero coherence (not the vs baseline or vs condition test) would
%   be best... unless one gets data from a second condition, even without
%   behavior.


%TrLen will be entered in ms... this code needs to adjust it to samples based on Fs...   
%but if Fs isn't entered (under options.sampling) then we assume it's 1000, and then TrLen is automatically in samples if it was entered in ms   
if nargin>=5 && ~isempty(TrLen) && isfield(options,'sampling')
    TrLen=TrLen*options.sampling/1000;
end

if nargin>=5 && isfield(options,'sampling');     curFs=options.sampling;         else        curFs=1000;     end
if nargin<2 || isempty(bn);     bn=[min(Dat1_1D) max(Dat1_1D)];     end

[Dat1 N]=Parse1DSpkIntoTrs(Dat1_1D,bn,nTr,TrLen); %N comes out of this in units of samples

%convert N to seconds
N=N/curFs;

options.dn=N;
options.tapers=[N 1/N+ 1e-5];   %the + 1 e-5 is needed to make sure that W*N is infinitesimally larger than 1, rather than infinitesimally smaller than it, which happend from rounding error if you just set W to 1/N...
options.bn=[0 (N-1/curFs)*1000];
options.plotflag=0;

if nargout>4
    [Sx,f,~,PSx,N,~,~,err,tmpdf1] = SpkSpec(Dat1,options);
elseif nargout>2
    [Sx,f,~,PSx,N] = SpkSpec(Dat1,options);
else
    [Sx,f] = SpkSpec(Dat1,options);
end

%[Sx,f,tout,PSx,N,dn,nwin,err,tmpdf1] = SpkSpec(...
%[Sx,f,tout,PSx,N,dn,nwin,err,tmpdf1] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, JustPartFlag,errType,ZTransFlag,ClusShuffOpts)
%[spec,f] = LFPSpec(X,[N W],Fs, N, fk, plotflag, [], [], pad);
