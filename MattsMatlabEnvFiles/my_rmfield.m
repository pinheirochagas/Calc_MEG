function t = my_rmfield(s,field)
%function t = my_rmfield(s,field)
%
% This function calls matlab's rmfield, but checks first to see that the
% field name exists before doing so... (matlab's rmfield returns an error
% if you try to remove a field that doesn't exist

if iscell(field)
    for ic=1:length(field)
        field2={};
        if isfield(s, field{ic})
            field2{end+1}=field{ic};
        end
    end
    
    if ~isempty(field2)
        t=rmfield(s,field2);
    else
        t=s;
    end
else
    if isfield(s, field)
        t=rmfield(s,field);
    else
        t=s;
    end
end
