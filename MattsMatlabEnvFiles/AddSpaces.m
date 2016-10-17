function str=AddSpaces(str,NumChars,AlignFlag)
% function AddSpaces(str,AlignFlag)
%
% Will add spaces to STR to make it the same length as NumChars. AlignFlag
% determines whether the spaces are added to the left (-1), right (1) or
% aurrounding (0) STR. AlignFlag Defaults to 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<3 AlignFlag=0;    end
if nargin<2 error('Narg to AddSpaces must be at least 2! Need to add NumChars!');    end

lstr=length(str);
if lstr>=NumChars
    warning(['In AddSpaces, Str of length: ' num2str(lstr) ' and NumChars is: ' num2str(NumChars) ' No Spaces added.'])
else
    if AlignFlag==-1
        for is=1:NumChars-lstr  
            str=[' ' str];  
        end
    elseif AlignFlag==1
        for is=1:NumChars-lstr  
            str=[str ' '];  
        end
    else
        for is=1:NumChars-lstr  
            if isodd(is)    str=[str ' '];  
            else    str=[' ' str];  end
        end
    end
end
    