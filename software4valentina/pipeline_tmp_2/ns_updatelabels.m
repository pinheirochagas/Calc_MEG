function datanew=ns_updatelabels(dataold)
datanew=dataold;
% update old sensor label convention
if strcmp(datanew.label{1},'0113')
    disp('Old label format: MEG suffix added for layout compatibility.');
    load('/neurospin/meg/meg_tmp/tools_tmp/pipeline/SensorClassification.mat');
    datanew.label = All2';
else
    disp('Correct label format including MEG suffix: nothing done.');
end;
