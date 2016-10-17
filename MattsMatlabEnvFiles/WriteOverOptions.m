%WriteOverOptions.m
%
% Taken from CorrectData, this script will take the fields from the
% structure options, and make each field a variable in the workspace, set
% to whatever that field was set to.

fieldlist=fieldnames(options);
for ifld=1:length(fieldlist)
    if length(options.(fieldlist{ifld}))>1
        eval([fieldlist{ifld} '=[' num2str(options.(fieldlist{ifld})) '];']);
    else
        eval([fieldlist{ifld} '=' num2str(options.(fieldlist{ifld})) ';']);
    end
end