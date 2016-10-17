% GetOptsLoop.m

fieldlist=fieldnames(opts);
for ifld=1:length(fieldlist)
    eval([fieldlist{ifld} '= opts.(fieldlist{ifld});']);
end
