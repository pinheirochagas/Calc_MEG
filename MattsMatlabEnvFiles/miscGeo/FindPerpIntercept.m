function [IntPos,Orients]=FindPerpIntercept(varargin)
%   function IntPos=FindPerpIntercept(varargin)
%       of the form:
%   function IntPos=FindPerpIntercept(LPos1,LPos2,P)
%       NOTE-can also accept:   IntPos=FindPerpIntercept(LPos,P)
%       where LPos is 
%
%   P is assumed to be an (NSacs x 2) array (or a 1x2 vector)
%
%   This will return the point- i.e.(xpos,ypos)- at which a line- defined
%   by LPos(xpos,ypos) and LPos2(xpos,ypos) intersect with a
%   perpendicular line to it that runs through P(xpos,ypos), which is
%   the line defining the shortest possible distance between that point and
%   the original line. 
%
%   It also optionally return Orients if each point is CCW (+1) or CW (-1) 
%   of the line, or 0 if it's on the line
%
%   This is called by p_saccdetMatt for use in defining the curvature of a
%   saccade, where LinePos1 and LinePos2 are the end points of a Sacc, and 
%   Point could be any point along the actual Sacc trajectory.. The output 
%   of this is put into GetTotVAng to return a total visual angle, assuming
%   all inputs are in units of visual angles.
%
%   created on 070715 by MJN

if nargin==2
    LPos1=varargin{1}(1:2);
    LPos2=varargin{1}(3:4);
    P=varargin{2};
else
    LPos1=varargin{1};
    LPos2=varargin{2};
    P=varargin{3};
end


m1=(LPos2(2)-LPos1(2))/(LPos2(1)-LPos1(1));
m2=-1/m1;
b1=LPos1(2)-m1*LPos1(1);
b2=P(:,2)-m2*P(:,1);
IntPos(:,1)=(b1-b2)/(m2-m1);
IntPos(:,2)=m2*IntPos(1)+b2;

%note- here order counts
Orients=zeros(size(P,1),1);
Orients( ( GetEyeDir(P(:,1)-LPos1(1),P(:,2)-LPos1(2)) ) > GetEyeDir(LPos2(1)-LPos1(1),LPos2(2)-LPos1(2)) )=1;
Orients( ( GetEyeDir(P(:,1)-LPos1(1),P(:,2)-LPos1(2)) ) < GetEyeDir(LPos2(1)-LPos1(1),LPos2(2)-LPos1(2)) )=-1;
