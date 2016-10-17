%myEvalOptsStructScript.m
%Evals the field of the structure Opts, and puts them into the current
%workspace as variables

fieldlist=fieldnames(Opts);
for ifld=1:length(fieldlist)
    if isstr(Opts.(fieldlist{ifld}))
        eval([fieldlist{ifld} '=''' Opts.(fieldlist{ifld}) ''';']);
    elseif isstruct(Opts.(fieldlist{ifld}))
        eval([fieldlist{ifld} '=Opts.' (fieldlist{ifld}) ';'])
    elseif length(Opts.(fieldlist{ifld}))>1
        eval([fieldlist{ifld} '=[' num2str(Opts.(fieldlist{ifld})) '];']);
    else
        eval([fieldlist{ifld} '=' num2str(Opts.(fieldlist{ifld})) ';']);
    end
end