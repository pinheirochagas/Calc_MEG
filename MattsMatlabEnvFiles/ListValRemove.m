function list=ListValRemove(list,Rinds)
% function list=ListValRemove(list,Rinds)
% 
% Outputs LIST after removing the values of Rinds if they appeared in the
% input list at all.


for iRi=Rinds     list=list(find(list~=iRi)); end