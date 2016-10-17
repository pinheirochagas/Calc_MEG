function [coh, f, Sx, Sy, Pcoh, PSx, PSy, N, err, tmpdf1, tmpdf2] = Spk_LFPCoh1D(Dat1_1D,Dat2_1D,t0,bn,nTr,TrLen,options)
%function [coh, f, Sx, Sy, Pcoh, PSx, PSy, N, err, tmpdf1, tmpdf2] = Spk_LFPCoh1D(Dat1_1D,Dat2_1D,t0,bn,nTr,TrLen,options)
%
% The 1-dimensional Spk-LFP coherence. Given 2 1 x N input data vectors 
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
% Note that the t0 input for Spk_LFPCoh in particular is critical to know
% how to line up the spike with the field temporally
% 
% Dat1_1D is the spk, and Dat2_1D is the LFP
%
% Inputs:
%   Dat1_1D:    A 1D vector of input Spike data, in the form of spike times
%   Dat2_1D:    A 1D vector of input AD data.
%   t0:         The time value of the first LF sample. Needed to be
%               referenced to the same event as bn and the spike times to
%               be sure that everything is matched up properly.
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
%               Spk_LFPCoh for more details
%
%               Note that certain fields for options will be overwritten 
%               even if they are entered in in options... these are tapers,
%               bn, and dn. These are because in order to do the 1D
%               analysis, these can't change.
%
% Outputs:
%   coh:        A 1 x nFreq vector indicaing the coherence at each freq. 
%               See Spk_LFPCoh for more details.
%	f:  		Units of frequency for coh, and everything else.
%   Sx:         A 1 x nFreq vector indicaing the LFP spectrum of Dat1_1D 
%               at each freq.
%   Sy:         A 1 x nFreq vector indicaing the LFP spectrum of Dat2_1D 
%               at each freq.
%   Pcoh:       A 1 x nFreq vector indicaing the partial coherence at each 
%               freq. See Spk_LFPCoh for more details.
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
if nargin>=7 && ~isempty(TrLen) && isfield(options,'sampling')
    TrLen=TrLen*options.sampling/1000;
end

if nargin>=7 && isfield(options,'sampling');     curFs=options.sampling;         else        curFs=1000;     end
if nargin<3 || isempty(bn);     
    bn=[t0 t0+length(Dat2_1D)-1];   %for this case (unlike the others) we use teh LFP signal as a guide for when to cutoff the Spk data
end

%where t0 really comes into play: potentially return an error or trim the LFP based on bn and t0
if t0>bn(1);     error(['bn(1) is: ' num2str(bn(1)) ' which is before the start of the LFP given by t0: ' num2str(t0)]);   end
if bn(2)-t0+1>length(Dat2_1D);     error(['bn(2) is: ' num2str(bn(2)) ' which is after the last point in the LFP, which is at time: ' num2str(length(Dat2_1D)+t0-1)]);   end
Dat2_1D=Dat2_1D(bn(1)-t0+1:bn(2)-t0+1);  

[Dat1 N]=Parse1DSpkIntoTrs(Dat1_1D,bn,nTr,TrLen); %N comes out of this in units of samples
[Dat2 N]=Parse1DLFPIntoTrs(Dat2_1D,nTr,TrLen); %N comes out of this in units of samples

%convert N to seconds
N=N/curFs;

%note that the t0 entered for this only serves to line up the spikes and
%the fields...   

options.dn=N;
options.tapers=[N 1/N+1e-5];
options.bn=[0 (N-1/curFs)*1000];
options.plotflag=0;
options.t0=0;   %this is 0 b/c the TrLens for Spk and LFP match, and teh spike times in the Spk var were cut into trials so that teh time at teh first sample was time 0

if nargout>8    
    [coh,f,~,Sx,Sy,Pcoh,PSx,PSy,N,~,~,err,tmpdf1,tmpdf2] = Spk_LFPCoh(Dat1,Dat2,options);
elseif nargout>4
    [coh,f,~,Sx,Sy,Pcoh,PSx,PSy,N] = Spk_LFPCoh(Dat1,Dat2,options);
elseif nargout>2
    [coh,f,~,Sx,Sy] = Spk_LFPCoh(Dat1,Dat2,options);
else
    [coh,f] = Spk_LFPCoh(Dat1,Dat2,options);
end
