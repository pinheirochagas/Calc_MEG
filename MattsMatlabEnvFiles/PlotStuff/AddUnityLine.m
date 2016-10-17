function th=AddUnityLine(Offset,AdjAxLimFlag)
%
% Adds a black dashed line for the unity line (i.e. y=x) to the current plot...
% You can optinally adjust teh unity line... useful when plotting linear
% regressions when it is desired to include a line with a slope of 1 with
% an offset determined by teh linear regression
%
% Set AdjAxLimFlag to 0 so the unity line added will be guaranteed not to 
% exceed the current axis limits. Defaults to 0
%
% returns the handle of the line

if nargin<1 || isempty(Offset);   Offset=0;     end
if nargin<2 || isempty(AdjAxLimFlag);   AdjAxLimFlag=0;     end

axvals=axis;
hold on

minxy=min(axvals([1 3]));
maxxy=max(axvals([2 4]));
if Offset>=0
    %th=plot([minxy-Offset maxxy],[minxy maxxy+Offset],'k:');
    th=plot([minxy maxxy-Offset],[minxy+Offset maxxy],'k:');
else
    %th=plot([minxy maxxy-Offset],[minxy+Offset maxxy],'k:');
    th=plot([minxy-Offset maxxy],[minxy maxxy+Offset],'k:');
end

if ~AdjAxLimFlag;   axis(axvals);       end

