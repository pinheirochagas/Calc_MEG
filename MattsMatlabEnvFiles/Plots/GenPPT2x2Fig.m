function FigH=GenPPT2x2Fig(VisFlag)
% function FigH=GenPPT2x2Fig(VisFlag)
%
% We need to set VisFlag when we're cretaing the figure if we don't want it
% to capture the focus of the user with this fiugre   

if nargin<1 || isempty(VisFlag);        VisFlag='On';      end
if isnum(VisFlag) 
    if VisFlag==0;       VisFlag='Off';      else        VisFlag='On';           end
end

pos=[251         527        759         450];

FigH=figure('Position',pos,'Visible',VisFlag); 
 