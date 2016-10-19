function data=bst2ft_decoding_all(subj)
% bst2ft_all() - Export Brainstorm data to Fieldtrip dataset,
% grouping all conditions.
%
% Usage:
% data=bst2ft_all(subj); 
% 
% Input:
% subj : [char] subject label 
%
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

condition_labels={'devm3','devm2','devm1','dev0','devp1','devp2','devp3','devcw','devca'};

for d=1:9
%     data{d}=ns_appendftdata(bst2ft_decoding(subj,condition_labels{d}));
    data{d}=bst2ft_decoding(subj,condition_labels{d});
end;
