function [FigH,axH]=GoldRatFig(width,tallflag, OneToOneFlag)
% function FigH=GoldRatFig(width, tallflag, OneToOneFlag)
%
% Creates a 1 axis figure where the ratio of height and width of the axis
% follows the golden ratio of ~1.6 to 1.
% INPUTS
%   width:      Overall axis width, in inches. Defaults to 3.55 inches... 
%               NOTE: Because of "breathing room" around the axes in the
%               figure, the actual width othe axis will be somewhat less
%               than this value... at the default value of 3.55, the
%               resulting end position of the axis is at 3.21 inches, which
%               is close to the approximate column width for a lot of 
%               journals.
%   tallflag:   Set to 1 to make the height of the axis longer than the
%               width, or else the width will be longer than the height.
%               Defaults to 0 (a wide axis).
%   OneToOneFlag:       Set to 1 for the special case in which the axis is
%                       desired to have a 1 to 1 ratio of width and height.
%                       According to Jeff, this should only be done in
%                       special cases, with the only example we could think
%                       being when it is desired to compare something to
%                       the unity line.
%
% OUTPUTS
%   FigH:       The handle for the ouptut figure.
%   axH:        The handle for the output axis.
%
% written by MJN on 081125

if nargin<3 || isempty(OneToOneFlag);   OneToOneFlag=0;     end
if nargin<2 || isempty(tallflag);   tallflag=0;     end
if nargin<1 || isempty(width);   width=3.55;     end

if OneToOneFlag;        height=width;
elseif tallflag;        height=width*1.6;
else        height=width/1.6;
end

FigH=figure('Units','inches');
set(FigH,'Position',[2 2 width height]);
axH=axes;