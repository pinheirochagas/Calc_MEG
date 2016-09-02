function [coh, f, Sx, Sy, Pcoh, PSx, PSy, N, err, tmpdf1, tmpdf2] = LFP_LFPCoh1D(Dat1_1D, Dat2_1D, nTr, TrLen, options)
%function [coh, f, Sx, Sy, Pcoh, PSx, PSy, N, err, tmpdf1, tmpdf2] = LFP_LFPCoh1D(Dat1_1D, Dat2_1D, nTr, TrLen, options)  
%
% The 1-dimensional LFP_LFP coherence. Given 2 1 x N input data vectors 
% (i.e. one deminsional data) this will break that data up into "trials", 
% i.e. equal segments of data, and perform the usual MT analysis on that 
% using LFP_LFPCoh, but does so without sliding the window in time at all, 
% so the output only varies with frequency.
%
% Inputs:
%   Dat1_1D:    A 1D vector of input AD data.
%   Dat2_1D:    A 1D vector of input AD data.
%   nTr:        The number of trials to parse InDat into, using 
%               Parse1DLFPIntoTrs.m ... Defaults to 20 if TrLen not entered
%               either. See comment below for more info..
%   TrLen:      The length of the trial (in ms) to parse input data into.
%   options:    A structure containing all of the options for the MT
%               Analysis. See the optional options input described in
%               LFPSpec for more details
%
%               Note that certain fields for options will be overwritten 
%               even if they are entered in in options... these are tapers,
%               bn, and dn. These are because in order to do the 1D
%               analysis, these can't change.
%
% Outputs:
%   coh:        A 1 x nFreq vector indicaing the coherence at each freq. 
%               See LFP_LFPCoh for more details.
%	f:  		Units of frequency for coh, and everything else.
%   Sx:         A 1 x nFreq vector indicaing the LFP spectrum of Dat1_1D 
%               at each freq.
%   Sy:         A 1 x nFreq vector indicaing the LFP spectrum of Dat2_1D 
%               at each freq.
%   Pcoh:       A 1 x nFreq vector indicaing the partial coherence at each 
%               freq. See LFP_LFPCoh for more details.
%   PSx:        Partial spectrum of Dat1_1D.
%   PSy:        Partial spectrum of Dat2_1D.
%   N:          The length of the window ("trial length") ultimately used
%   err:        MT Analysis error structure.
%   tmpdf1:     Df used for Dat1_1D error structure
%   tmpdf2:     Df used for Dat2_1D error structure
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

[Dat1 N]=Parse1DLFPIntoTrs(Dat1_1D,nTr,TrLen); %N comes out of this in units of samples
[Dat2 N]=Parse1DLFPIntoTrs(Dat2_1D,nTr,TrLen); %N comes out of this in units of samples

%convert N to seconds
N=N/curFs;

options.dn=N;
options.tapers=[N 1/N+1e-5];
options.plotflag=0;

if nargout>8
    [coh, f, ~, Sx, Sy, Pcoh, PSx, PSy, N, ~, ~, err, tmpdf1,tmpdf2] = LFP_LFPCoh(Dat1,Dat2,options);        
    %[coh, f, tout, Sx, Sy, Pcoh, PSx, PSy, N, dn, nwin, err, tmpdf1,tmpdf2] = LFP_LFPCoh(X,Y,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, JustPartFlag,errType,ZTransFlag,ClusShuffOpts)
elseif nargout>4
    [coh,f,~,Sx,Sy,Pcoh,PSx,PSy,N] = LFP_LFPCoh(Dat1,Dat2,options);
elseif nargout > 2
    [coh,f,~,Sx,Sy] = LFP_LFPCoh(Dat1,Dat2,options);
else
    [coh,f] = LFP_LFPCoh(Dat1,Dat2,options);
end

%[Sx,f,tout,PSx,N,dn,nwin,err,tmpdf1] = LFPSpec(X,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, JustPartFlag,errType,ZTransFlag,ClusShuffOpts)
%[spec,f] = LFPSpec(X,[N W],Fs, N, fk, plotflag, [], [], pad);
