function Vres=VResCheck( V )
% Returns the smallest changed between samples in V (assumed to be a 1D vector) that is greater than 0.  

VDiff=abs(diff(V));
Vres=min( VDiff( VDiff~=0 ) );
