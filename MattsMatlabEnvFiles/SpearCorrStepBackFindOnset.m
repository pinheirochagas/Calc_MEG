function OnT=SpearCorrStepBackFindOnset(sdf,t)
%This follows the Spearman correlation procedure described in Woodman,
%Kang, Thompson + Schall (2008) in Psych Science 
%
%It is assumed this sdf is movement aligned
%
%Note- the way this code is written, there's no reason to input the sdf
%at a time point later thna 0 (i.e. movement onset)
%
%written by MJN on 090512
%
%Note- I really don't like this method, it's negatively biased... try the
%simple simulation:
%
%A=randn(200,1);
%A(end-50:end)=A(end-50:end)+[1:51]';
%OnT=SpearCorrStepBackFindOnset(A)
%
% This reports the onset time as -66, not -50...

%change sdf to column (for speed)
[r c]=size(sdf);
if c>r; sdf=sdf';   end

if nargin<2
    ZerSamp=length(sdf);
else
    ZerSamp=find(t==0);
end
PeriSaccFR=mean(sdf(ZerSamp-20:ZerSamp));

WinLen=20;  %ms (or samples)- this the length on either side of the window center... so the total Window Length is really 2 times this...
wint=[1:2*WinLen+1]';
NonSigCorrDurReq=20;    %the number of ms during which the spearman corr must remain nonsig...

FoundOnset=0;
WinCen=-20;
OnT=NaN;
while ~FoundOnset && ZerSamp+WinCen-WinLen>0
    [rho,p]=corr(wint,sdf( ZerSamp+WinCen-WinLen:ZerSamp+WinCen+WinLen ),'type','Spearman');
    if p>.05 || rho<0
        if isnan(OnT)
            if mean(sdf( ZerSamp+WinCen-WinLen:ZerSamp+WinCen+WinLen ))<PeriSaccFR
                OnT=WinCen;
            end
        elseif OnT-WinCen==NonSigCorrDurReq
            FoundOnset=1;
        end
    else 
        if ~isnan(OnT)
            OnT=NaN;
        end
    end
    WinCen=WinCen-1;
end
            
%need to do a last check in case the length of data ran out in the midst of
%potential Found Onset, btu before the 20 ms of non-sig correlation could
%be completed...
if ~isnan(OnT) && ZerSamp+OnT-WinLen<=NonSigCorrDurReq
    disp('In SpearCorrStepBackFindOnset, ran out of data during possible Onset block. Need more data to find onset.')
    OnT=NaN;
end