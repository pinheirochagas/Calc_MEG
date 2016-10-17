function [coh, f, Sx, Sy, N, err, tmpdf1, tmpdf2] = Spk_SpkCoh1D(Dat1_1D,Dat2_1D,bn,nTr,TrLen,options,MultTapsFlag,MultTapsAndTrParseFlag)
%function [coh, f, Sx, Sy, N, err, tmpdf1, tmpdf2] = Spk_SpkCoh1D(Dat1_1D,Dat2_1D,bn,nTr,TrLen,options,MultTapsFlag)
%
% Updated on 100210 to allow for multiple tapers of one long window (see
% discusison of MultTapsFlag below) instead of breaking signal into
% multiple trials. Using multiple tapers for one long trial is actually
% better.
%
% The 1-dimensional Spk-Spk coherence. Given 2 1 x N input data vectors 
% (i.e. one deminsional data) this will break that data up into "trials", 
% i.e. equal segments of data, and perform the usual MT analysis on that 
% using SpkSpec, but does so without sliding the window in time at all, so 
% the output only varies with frequency.
%
% Note that the bn input is needed... BUT this isn't the same tr by tr bn
% Input as in the other MT anal code... here it is the start and stop of 
% the experiment to know to when to create the start and stop of the 
% experiment when chopping the data into trials.
%
% Inputs:
%   Dat1_1D:    A 1D vector of input Spike data, in the form of spike times
%   Dat2_1D:    Another 1D vector of input Spike data, in the form of 
%               spike times.
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
%   MultTapsFlag:   Set to 1 if you want to keep everything as one trial,
%                   but use multiple tapers rather than breaking up into
%                   trials. This is actually preferred in a sense of 
%                   time-frequency localization, and statistical power. 
%                   Whatever the value for nTr is would be used for the 
%                   numbers of tapers. MultTapsFlag Defaults to 1.
%
%                   Note that when using MultTaps, this uses the value for
%                   nTr as the numbers of tapers, gets N from bn, and sets
%                   W accordingly to satisfy the equation 2NW-1 = nTaps
%
%   MultTapsAndTrParseFlag: Set this and MultTapsAbove to 1 to use mult
%                           taps as above, but to first divide the data up
%                           into the number of trials given by nTr and
%                           Trlen. Defaults to 0.
%
%                           NOTE: Having this input as 1 only makes sense
%                           and will only work if options.SetOutputRes>0 as
%                           well.
%                   
%
% Outputs:
%   coh:        A 1 x nFreq vector indicaing the coherence at each freq. 
%               See Spk_SpkCoh for more details.
%	f:  		Units of frequency for coh, and everything else.
%   Sx:         A 1 x nFreq vector indicaing the LFP spectrum of Dat1_1D 
%               at each freq.
%   Sy:         A 1 x nFreq vector indicaing the LFP spectrum of Dat2_1D 
%               at each freq.
%   Pcoh:       A 1 x nFreq vector indicaing the partial coherence at each 
%               freq. See Spk_SpkCoh for more details.
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

%coh=0; f=0; Sx=0; Sy=0; N=0; err=0; tmpdf1=0; tmpdf2=0;
%disp(['in Spk_SpkCoh1D: I need to finish the MT code for the option: options.SetOutputNShuffRes'])
%return


if nargin<8 || isempty(MultTapsAndTrParseFlag);       MultTapsAndTrParseFlag=1;         end
if nargin<7 || isempty(MultTapsFlag);       MultTapsFlag=1;         end

%TrLen will be entered in ms... this code needs to adjust it to samples based on Fs...   
%but if Fs isn't entered (under options.sampling) then we assume it's 1000, and then TrLen is automatically in samples if it was entered in ms   
if nargin>=6 && ~isempty(TrLen) && isfield(options,'sampling')
    TrLen=TrLen*options.sampling/1000;
end
if nargin<4 || isempty(nTr);    nTr=20;     end

if nargin>=6 && isfield(options,'sampling');     curFs=options.sampling;         else        curFs=1000;     end
if nargin<2 || isempty(bn);     bn=[min( min(Dat1_1D),min(Dat1_2D) ) max( max(Dat1_1D),max(Dat1_2D) )];     end

if MultTapsFlag
    N=(bn(2)-bn(1))/curFs;  %gives N in seconds
    options.bn=bn;
    
    if isfield(options,'SetOutputRes') && options.SetOutputRes>0        
        W=options.SetOutputRes;     %here we just have to set N and W, and then the code in Spk_SPkCoh will choose the appropriate K
    else        
        %this is the solution to 2*N*W-1=nTr
        W=(nTr+1)/(2*N) +1e-5;  %the +1e-5 is b/c of rounding issues
    end    
    
    if MultTapsAndTrParseFlag && isfield(options,'SetOutputRes') && options.SetOutputRes>0
        [Dat1 ~]=Parse1DSpkIntoTrs(Dat1_1D,bn,nTr,TrLen); %N comes out of this in units of samples
        [Dat2 N]=Parse1DSpkIntoTrs(Dat2_1D,bn,nTr,TrLen); %N comes out of this in units of samples
        
        %set bn to the TrLen (in ms!)
        options.bn=[0 N];
        %convert N to seconds
        N=N/curFs;        
    else
        Dat1(1,:)=Dat1_1D;
        Dat2(1,:)=Dat2_1D;
    end
    
    options.tapers=[N W];
else
    [Dat1 ~]=Parse1DSpkIntoTrs(Dat1_1D,bn,nTr,TrLen); %N comes out of this in units of samples
    [Dat2 N]=Parse1DSpkIntoTrs(Dat2_1D,bn,nTr,TrLen); %N comes out of this in units of samples
    
    %convert N to seconds
    N=N/curFs;
    options.tapers=[N 1/N+1e-5];
    options.bn=[0 (N-1/curFs)*1000];
end

options.dn=N;
options.plotflag=0;

%Note- no need to return Partial coh or spec for this no matter what, so those outputs of Spk_SpkCoh will be discarded   
%   [coh,f,tout,Pcoh,Sx,Sy,PSx,PSy,N,dn,nwin,err,tmpdf1,tmpdf2] = Spk_SpkCoh(Spk,Spk2,tapers,bn, sampling, dn, fk, plotflag, pad, pval, JustPartFlag,errType,ZTransFlag,ClusShuffOpts)   
if nargout>5    
    [coh,f,~,~,Sx,Sy,~,~,N,~,~,err,tmpdf1,tmpdf2] = Spk_SpkCoh(Dat1,Dat2,options);
elseif nargout>4
    [coh,f,~,~,Sx,Sy,~,~,N] = Spk_SpkCoh(Dat1,Dat2,options);
elseif nargout>2
    [coh,f,~,~,Sx,Sy] = Spk_SpkCoh(Dat1,Dat2,options);
else
    [coh,f] = Spk_SpkCoh(Dat1,Dat2,options);
end