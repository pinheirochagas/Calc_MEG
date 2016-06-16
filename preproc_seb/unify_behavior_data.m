function unify_behavior_data(subject,run)

resultFile = ['/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/results/Calc/',subject,'/', num2str(run), '_results.csv']; % Behavioral data 
stimFile = ['/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/results/Calc/',subject,'/', num2str(run), '_results.csv']; % Behavioral data 


[code_event,myEvent,onsets,response,rt] = importMEGCalcResults(cfg.databh, 2, 216);


% Convert the response to the trigger code
for i=1:length(response)
    if strcmp(response{i}(1), 'f') == 1 || strcmp(response{i}(1), 'T') == 1; 
        response_recoded(i) = 32768; % left button press
    elseif strcmp(response{i}(1), 'F') == 1 || strcmp(response{i}(1), 't') == 1;
        response_recoded(i) = 1024;  % right button press
    elseif strcmp(response{i}(1), '0') == 1;
        response_recoded(i) = 0;
    else
        response_recoded(i) = 999;
    end
end


%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


end

