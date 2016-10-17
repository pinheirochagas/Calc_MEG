function th=AddZeroLinePedro(VertFlag,BoldFlag,Offset,ColorFlag)
%%%%%NOTE: use a semicolon when calling this fxn, or else it will return 
%%%%%the handle of the line to the matlab command window!!!
%
% Adds a horizontal black dashed line for the x-axis to the current plot...
% returns the handle of the line

if nargin<4 || isempty(ColorFlag);     ColorFlag=0;       end
if nargin<3 || isempty(Offset);        Offset=0;          end
if nargin<2 || isempty(BoldFlag);      BoldFlag=0;        end
if nargin<1 || isempty(VertFlag);      VertFlag=0;        end


if BoldFlag;      LW=2;     else        LW=1;       end

if VertFlag ||
    axvals=axis;
    hold on
    if BoldFlag
        th=plot([Offset Offset],[axvals(3) axvals(4)],'k-','LineWidth',LW);
    else
        th=plot([Offset Offset],[axvals(3) axvals(4)],'k:','LineWidth',LW);
    end
else
    axvals=axis;
    hold on
    if BoldFlag
        th=plot([axvals(1) axvals(2)],[Offset Offset],'k-','LineWidth',LW);
    else
        th=plot([axvals(1) axvals(2)],[Offset Offset],'k:','LineWidth',LW);
    end
    
    
    
    
end

