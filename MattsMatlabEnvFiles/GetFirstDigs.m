function FirstDigsStr=GetFirstDigs(InStr)
%FirstDigsStr=GetFirstDigs(InStr)
% 
%Given the input string, this returns the string for all the first
%characters that are digits. Useful for things like electrode labels.

len=length(InStr);
ichar=1;
while ichar<=len && isdigit(InStr(ichar)) 
    ichar=ichar+1;
end
FirstDigsStr=InStr(1:ichar-1);