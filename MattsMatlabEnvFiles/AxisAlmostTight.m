function AxisAlmostTight(ah,sprdrat,yzeromin)
% function AxisAlmostTight(ah,sprdrat,yzeromin)
%
% This will adjust the current axis lims to make it "almost" tight. Space 
% of ratio (sprdrat) times the actual spread of the data in the x and y 
% dimensions will be left around the data
%
% sprdrat defaults to .05
%
% if yzeromin is set to 1, then the lowest y val is automatically 0. This
% is useful for histograms

if nargin<3 || isempty(yzeromin)   yzeromin=0;     end
if nargin<2 || isempty(sprdrat)    sprdrat=.05;     end
if nargin<1 || isempty(ah)    ah=gca;     end

try
    axis(ah,'tight')
catch
    return
end
axvals=axis(ah);
sprd=[axvals(2)-axvals(1) axvals(4)-axvals(3)];
if yzeromin     
    tmpav=axvals + [-sprd(1)*sprdrat sprd(1)*sprdrat -sprd(2)*sprdrat sprd(2)*sprdrat];
    tmpav(3)=0;
    axis(ah,tmpav);
else    axis(ah,[axvals + [-sprd(1)*sprdrat sprd(1)*sprdrat -sprd(2)*sprdrat sprd(2)*sprdrat] ]);      end


