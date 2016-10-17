function varargout=ADAlignTrials(AlignEv,win,t0,varargin)
% function varargout=ADAlignTrials(AlignEv,win,t0,varargin)
%   
%   Aligns matrices of analog data samples per trial to a given event at 
%   variables times during the each trial. Handy for digitally sampled
%   analog data (which I refer to as AD data) stored in a repeated trial
%   structure as often found in behavioral neuroscienc research. This
%   doesn't use a big for loop (i.e. a for loop across trials) and so
%   should be fairly quick.
%
%   Example of how this is called:
%   [AlX,AlY]=ADAlignTrials(Saccade,[-300 300],0,EyeX,EyeY);
%
%   Where Saccade is a nTr x 1 vector of saccade onset times (in ms) for 
%   each trial, EyeX and EyeY are nTr x nSampsPerTrial matrices of analog 
%   eye positions (sampled at 1 kHz) per tial in the X and Y dimensions 
%   respectively. AlX and AlY will be nTr x 601 matrices of the eye
%   position samples in the X and Y dimensions respectively from 300 ms
%   before to 300 ms after the saccade onset in every trial, thus aligned
%   on the saccade onset. t0 is the common reference time of the first
%   sample in the EyeX and EyeY input matrices that Saccade is also
%   appropriately referenced to. 
%
%   The program will align every input AD data matrix in the varargin to
%   the same AlignEv each time it is run, so the number of output matrices
%   will be the same as the number of input matrices in varargin.
%
%   Presently this assumes a sampling rate of 1kHz for the AD data for ease
%   of mental math, but allowing for different sampling rates could easily
%   be done by scaling the time inputs (win, t0, AlignEv). If the aligned 
%   time windows go beyond the extent of the input matrices for a given
%   trial, the beginning or end of the output for that trial wis padded 
%   with Nans.
%
%   This is written not to accept NaNs in the input for AlignEv. 
%
%   written 2007-07-11 by Matthew John Nelson
%   nelsonmj@caltech.edu

if nargin<4 
    error(['nargin is only: ' num2str(nargin) '. You need at least 4 arguments.']); 
end
AlignEv=round(AlignEv);     win=round(win);   t0=round(t0);

if size(AlignEv,1)>size(AlignEv,2)  
    AlignEv=AlignEv';   
end
    
maxTrTime=t0+size(varargin{1},2)-1;
nTrs=length(AlignEv);

TimeLims=minmax(AlignEv)+win;
FrontPad=min([t0 TimeLims(1)]);
EndPad=max([maxTrTime TimeLims(2)]);
tmpnsamps=EndPad-FrontPad+1;

if FrontPad<t0   
    disp('Warning- win(1) went before AD sample for some trials. Padding beginning of these with NaN''s'); 
end
if EndPad>maxTrTime   
    disp('Warning- win(2) went beyond AD sample for some trials. Padding ends of these with NaN''s'); 
end

varargout=cell(nargin-3,1);
t=repmat((FrontPad:EndPad)',1,nTrs)-repmat(AlignEv,tmpnsamps,1);
for iAD=1:nargin-3
    curAD=varargin{iAD}';
    if FrontPad<t0
        curAD=[NaN*ones(t0-FrontPad,nTrs); curAD];
    end
    if EndPad>maxTrTime
        curAD=[curAD; NaN*ones(EndPad-maxTrTime,nTrs)];
    end
            
    varargout{iAD}=reshape(curAD(isbetween(t,win)),win(2)-win(1)+1,nTrs)';
end