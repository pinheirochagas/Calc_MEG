function data=bst2ft_all_inditems_withrun(subj)
% bst2ft_all() - Export Brainstorm data to Fieldtrip dataset,
% grouping all conditions.
%
% Usage:
% data=bst2ft_all(subj); 
% Input:
% subj : [char] subject label 
% Output:
% data : [cell] Array of Fieldtrip datasets. 
%
% Example:
% data=bst2ft('s03'); for subject 's03'.
%                                                                          
% Author: Marco Buiatti, INSERM Cognitive Neuroimaging Unit (France), 2013.

% for d=1:9
%     data{d}=ns_appendftdata(bst2ft(subj,10+d),bst2ft(subj,20+d),bst2ft(subj,30+d),bst2ft(subj,40+d));
% end;

condition_labels=...
    {'gor','ele','gir','lam','oui','per','sco','cam','vac','mou','tau','cha','cri','coq','fur','lap',...
    'asp','lav','arm','sof','mix','rev','ore', 'fuc','hel','mot','vel','can','aut','gyr','rol','bot'};

for d=1:32
    data{d}=ns_appendftdata(bst2ft_ds_singleitems_withrun(subj,condition_labels{d}));
end;