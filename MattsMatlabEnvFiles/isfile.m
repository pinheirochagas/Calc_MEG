function out = isfile(file)
% function out = isfile(file)
%
% Returns a one if there is a file or directory of that name in the present
% working directory. file can be a string or a 1D cell array of variables to
% look for.

if iscell(file)
    for ifl=1:length(file)
        a = dir(file{ifl});
        
        if length(a)
            out(ifl) = 1;
        else
            out(ifl) = 0;
        end
    end
else
    a = dir(file);
    
    if length(a)
        out = 1;
    else
        out = 0;
    end
end