function PostHocSpecPlot(S,f,t,TitStr,axh,fk,bn,IncColorBar,CLim,SymmCLimDef)                      
%   
% Note for SpecPlot: CLim should be of the raw data, not the log10 of it...
%
% Note- the axis is intended to have been created BEFOR this rogram is called

%Using SymmCLimDef=1 is recommended if and only if you use this fxn to plot the ratio of two spectra  
if nargin<10 || isempty(SymmCLimDef);        SymmCLimDef=0;      end    %here we DON'T want the defualt to be 1 (unlike PostHocCohSpecDiffPlot) because we won't often need this      
if nargin<9                                 CLim=[];      end
if nargin<8 || isempty(IncColorBar);        IncColorBar=true;       end
if nargin<5 || isempty(axh)
    figure;
    axh=axes;
else
    if gca~=axh
        axes(axh);  %accoridng to matlab, calling axes w/o output arg can be slow... so we don't call it unless we have to  
    end
end

if nargin>=6 && ~isempty(fk)      
    IncFreq=isbetween(f,fk);
    S=S(:,IncFreq);
    f=f(IncFreq);
end
if nargin>=7 && ~isempty(bn)      
    IncT=isbetween(t,bn);
    S=S(IncT,:);
    t=t(IncFreq);
end

imagesc(log10(S'+1e-8)); %[-8 -7.99] add 1e-8 to avoid plotting log of zero, it happens with fake data sometimes
axis xy
if IncColorBar;     colorbar;       end
if ~isempty(CLim)       set(axh,'CLim',log10(CLim+1e-8));
elseif SymmCLimDef
    tmpm=max(max( abs(log10(S+1e-8)) ));
    set(axh,'CLim',[-tmpm tmpm]);
end

%I don't think a log trans is needed for displaying coh

numYTicks=min(6,length(f));
numXTicks=min(6,length(t));
freqind=round(linspace(1,length(f),numYTicks));
freqvals=round(f(freqind));
freqind(1)=.5;
set(axh,'YTickLabel',freqvals);
set(axh,'YTick',freqind);

tind=round(linspace(1,length(t),numXTicks));
tvals=t(tind);
tind(1)=.5;
set(axh,'XTickLabel',tvals);
set(axh,'XTick',tind);

ylabel('Frequency (Hz)')
xlabel('Center of Time window (ms)')
if nargin>3 && ~isempty(TitStr)
    title(TitStr)
end
%title(['MT Field/Field coherence mag with ' num2str(Nms) ' ms window sliding ' num2str(dnms) ' at a time.'])