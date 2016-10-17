function list=ListRemove(list,Rinds)
% function list=ListRemove(list,Rinds)
% 
% Outputs LIST after removing the indices Rinds of the input list.
%
% Note- there is a better way to do this that I later discovered-
%
% list(Rinds)=[];

list(Rinds)=[];

% t=1:length(list);
% t(Rinds)=0;
% list=list(logical(t));