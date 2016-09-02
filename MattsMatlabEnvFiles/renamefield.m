function struc=renamefield(struc,oldfield,newfield)
%
% Duplicates the old field in new field, then removes the old field.
% Unfortunately the newfield will appear at the bottom of field listrs, but
% what can you do...

struc.(newfield)=struc.(oldfield);
struc=rmfield(struc,oldfield);