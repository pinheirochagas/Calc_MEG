function out=GetAngDiff(ang1,ang2)
%   function out=GetAngDiff(ang1,ang2)
%
%   Returns the absolute value of teh angular differenec between ang1 and 
%   ang2. ang1 and ang2 can be scalars, vectors, or arrays

out=mod(abs(ang1-ang2),360);
out(out>180)=360-out(out>180);