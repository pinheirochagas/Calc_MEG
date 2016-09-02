function [OutDat TrLen]=Parse1DSpkIntoTrs(InDat,bn,nTr,TrLen)
%function [OutDat TrLen]=Parse1DSpkIntoTrs(InDat,bn,nTr,TrLen)
%
% This will take a given 1D input (typically LFP, but it could be a spike
% train after being turned into a continuous variable) and parse it into
% trials.
%
% Inputs:
%   InDat:      A 1D vector of input data. The data is the spike times in
%               units of samples, typically milliseconds (assuming a 1 ms
%               spike bin size sampling rate is desired)
%   bn:         A 2x1 vector indicating the start and end times during
%               which spikes could have been recorded. Used to tell how 
%               long the actual recoridng is when breaking up into trials. 
%               If not entered, the program will default into using the 
%               time of the first and the last spike.
%   nTr:        The number of trials to parse InDat into
%   TrLen:      The length of the trial to parse InDat into. (just in units
%               of number of samples... the units for this should match 
%               with the units for bn. But for a 1kHz sampling rate, this 
%               will be in milliseconds)
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
% OutPuts:
%   OutDat:     InDat reshaped to be a Nan-padded nTr x MaxNSpks array ...
%               For ecah Tr, time zero will be the earliest possible time
%               for a spike
%   TrLen:      The variable for TrLen eventually used, useful for non-time
%               moving MTAnalysis later. The units for this is samples,
%               (typically ms) done based on whatever the sampling rate
%               implied by bn was.
%
InDat=squeeze(InDat);
if nargin<2 || isempty(bn);     bn=[min(InDat) max(InDat)];     end
if nargin<3 || (isempty(nTr) && (nargin<4 || isempty(TrLen)))   %if nargin was only 1, or if nTr and TrLen both weren't input   
    nTr=20;         
end

nS=bn(2)-bn(1);
if isempty(nTr)     %this should only happen at this point if TrLen was enterred as the third arg but nTr was left empty
    nTr=floor(nS/TrLen);
else
    TrLen=floor(nS/nTr);
end

%tmpDat=InDat( isbetween(InDat,bn) )-bn(1);
tmpDat=InDat( isbetween(InDat,[bn(1) TrLen*nTr+bn(1)-1]) )-bn(1); %we can't just use bn as the start and end of spieks to include b/c of rounding errors if the trials (of an integer number of samples) don't copmletely cover the data...
TrInds=floor(tmpDat/TrLen)+1;

[~,MaxnSpks]=mode( TrInds );
OutDat=repmat(NaN,nTr,MaxnSpks);
SpkCount=repmat(0,nTr,1);
nSpk=length(tmpDat);
for iSpk=1:nSpk
    cTr=TrInds(iSpk);
    SpkCount( cTr )=SpkCount( cTr )+1;
    OutDat( cTr,SpkCount( cTr ) )= tmpDat(iSpk)- TrLen*(cTr-1);
end


