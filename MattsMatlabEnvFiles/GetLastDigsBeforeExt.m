function [LastDigsStr, DigStPos]=GetLastDigsBeforeExt(InStr)
%FirstDigsStr=GetLastDigsBeforeExt(InStr)
% 
% Given the input string, this returns the string for all the LAST
% characters (before a putative file extension) that are digits. 
% Useful for things like electrode labels.
%
% Also returns the start position where the ending digits were found.
%
% Inspired by GetFirstDigs.m   

epos=strfind(InStr,'.');
if isempty(epos);       
    epos=length(InStr);          
else
    epos=epos(end);
    epos=epos-1;
end

ichar=epos;
while ichar>0 && isdigit(InStr(ichar))
    ichar=ichar-1;
end
LastDigsStr=InStr(ichar+1:epos);
DigStPos=ichar+1;