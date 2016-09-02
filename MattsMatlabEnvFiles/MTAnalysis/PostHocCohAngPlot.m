function PostHocCohAngPlot(coh,f,t,TitStr,axh,fk,bn,IncColorBar,CLim)  
%
%
% Note- the axis is intended to have been created BEFOR this rogram is called

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
    coh=coh(:,IncFreq);
    f=f(IncFreq);
end
if nargin>=7 && ~isempty(bn)      
    IncT=isbetween(t,bn);
    coh=coh(IncT,:);
    t=t(IncFreq);
end

imagesc( angle(coh')*180/pi ); %[-8 -7.99] add 1e-8 to avoid plotting log of zero, it happens with fake data sometimes
axis xy
if IncColorBar;     colorbar;       end
if nargin>8 && ~isempty(CLim);      set(axh,'CLim',CLim);       end

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