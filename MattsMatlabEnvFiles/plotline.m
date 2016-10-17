% function plotline(lims,val,plotopts,vflag)
% % function plotline(xlims,yval,plotopts)
% %
% % This just adds a line to the current plot. For a horizontal line, it
% % draws the line from lims(1) to lims(2) on the x-axis at the y-axis value 
% % of val. If vflag is input as 1, it does the same for a vertical line, 
% % using lims as the vertical limits, and val as the x-axis value. Lines are
% % drawn using the plot options in the string plotopts.
% %
% % oblique lines can also be drawn using
% %
% % plotopts defaults to 'r:'
% 
% hold on
% plot([f(1) f(end)], [0 0],plotopts)

%I decide dthis wasn't useful, but still didn't want to delete it