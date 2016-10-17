function out=mySetCircRng(alpha)
% Set all angles to be between -180 and +180 degrees... (i.e. 225 deg is
% converted to -135 deg, 375 deg is converted to 15 deg, etc.)

out=atan2( sin(alpha),cos(alpha) );
