function filename=FindDayFile(day,filepath)
%outputs the first filename in the given directory with the given day in it's name
%
%This function actually isn't called here, but it may be a useful function
%in general

d=dir(filepath);
dstr={d.name};
for ifile=1:length(dstr)
    if length(dstr{ifile})>4
        if ~isempty(strfind(dstr{ifile},day))
            filename=dstr{ifile};
            break
        end
    end
end