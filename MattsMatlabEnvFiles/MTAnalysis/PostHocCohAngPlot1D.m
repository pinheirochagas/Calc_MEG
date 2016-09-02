function PostHocCohAngPlot1D(coh,f,LogFreq,TitStr,axh,fk,CLim,popts)
% PostHocCohAngPlot1D(coh,f,LogFreq,TitStr,axh,fk,CLim,popts)
%
% Created on 100316 from PostHocCohMagPlot1D
%
% If coh is complex, this plots the complex angle of coh at each point (converted to degrees)... 
% If coh is not complex, this assumes coh is already and angle and instead just plots the value directly given in coh   

if any(any( imag(coh) ))
    coh=angle(coh)*180/pi;
end

if nargin<5 || isempty(axh)
    figure;
else
    axes(axh);
end

if nargin<3 || isempty(LogFreq);     LogFreq=false;     end

if nargin>=6 && ~isempty(fk)      
    IncFreq=isbetween(f,fk);
    coh=coh(:,IncFreq);
    f=f(IncFreq);
end

[r c]=size(coh);
if r>1 && c>1
    %need to process # of signals
    nsigs=r;
    for is=1:nsigs
        if LogFreq
            if nargin>7 && ~isempty(popts)
                semilogx(f,coh(is,:),popts{is});
            else
                semilogx( f,coh(is,:) );
            end
        else
            if nargin>7 && ~isempty(popts)
                plot(f,coh(is,:),popts{is});
            else
                plot(f,coh(is,:));
            end
        end
        hold on
    end
else
    if LogFreq
        semilogx(f,coh);
    else
        plot(f,coh);
    end
end

box off
if nargin>6 && ~isempty(CLim);    
    axis([f(1) f(end) CLim(1) CLim(2)]);      
else
    axis tight
end
AddZeroLine;

%I don't think a log trans is needed for displaying coh

% numYTicks=6;
% numXTicks=6;
% freqind=round(linspace(1,length(f),numYTicks));
% freqvals=round(f(freqind));
% freqind(1)=.5;
% set(axh,'XTickLabel',freqvals);
% set(axh,'XTick',freqind);

xlabel('Frequency (Hz)')
ylabel('Angle (deg)')
if nargin>3 && ~isempty(TitStr)
    title(TitStr);
end

%title(['MT Field/Field coherence mag with ' num2str(Nms) ' ms window sliding ' num2str(dnms) ' at a time.'])