function data_cosmo = calcConvertCOSMOtf(data)
data_cosmo = cosmo_meeg_dataset(data);
% Add trialinfo to cosmo
fieldNames = fieldnames(data.trialinfo);
for f = 1:length(fieldNames)
    data_cosmo.sa.(fieldNames{f}) = data.trialinfo.(fieldNames{f});
end
end

