function [trigger_bh, onsets_bh] = retrieveEventsCalc(cfg)
% Function to retrieve the events from the output of PsychoPy

% subjname = 'sub1';
% runNumber = 10;
% cfg.databh = ['/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/results/Calc/s01/1_results.csv']; % Behavioral data 


%% Calculate the total of correct responses i
% Load output file 
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



% Plug the code_events to the response_recoded
resp_only = response_recoded(response_recoded ~= 999)';
rt_resp_only = rt(rt ~= 99)/1000;

onset_1op = onsets(1:5:length(onsets));
code_event_reshape = reshape(code_event,5,43);
onsets_reshape = reshape(onsets,5,43);

for i=1:length(code_event_reshape)
    code_event_reshape(6,i) = resp_only(i);
    onsets_reshape(6,i) = rt_resp_only(i)+onsets_reshape(5,i)
end
trigger_bh = reshape(code_event_reshape,43*6,1);
onsets_bh = reshape(onsets_reshape,43*6,1)*1000;

% Exclude 'no responses' from the behavioral triggers
% trigger_bh(trigger_bh==0) = [];
% onsets_bh(trigger_bh==0) = [];
end


