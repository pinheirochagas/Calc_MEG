function [OutDat TrLen]=Parse1DLFPIntoTrs(InDat,nTr,TrLen)
%function [OutDat TrLen]=Parse1DLFPIntoTrs(InDat,nTr,TrLen)
%
% This will take a given 1D input (typically LFP, but it could be a spike
% train after being turned into a continuous variable) and parse it into
% trials.
%
% Inputs:
%   InDat:      A 1D vector of input data.
%   nTr:        The number of trials to parse InDat into
%   TrLen:      The length of the trial to parse InDat into. (just in units
%               of number of samples...)
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
%   OutDat:     InDat reshaped to be a nTr x TrLen array
%   TrLen:      The variable for TrLen eventually used, useful for non-time
%               moving MTAnalysis later
%

TrLen=round(TrLen);
if nargin<2 || (isempty(nTr) && (nargin<3 || isempty(TrLen)))   %if nargin was only 1, or if nTr and TrLen both weren't input   
    nTr=20;         
end

nS=length(InDat);
if isempty(nTr)     %this should only happen at this point if TrLen was enterred as the third arg but nTr was left empty
    nTr=floor(nS/TrLen);
else
    TrLen=floor(nS/nTr);
end
   
OutDat=reshape(InDat(1:TrLen*nTr),TrLen,nTr)';