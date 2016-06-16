function [trigger_bh, onsets_bh] = retrieveEventsVSA(cfg)
% Function to retrieve the events from the output of PsychoPy

% subjname = 'sub1';
% runNumber = 10;
% cfg.databh = ['/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/results/Calc/s01/1_results.csv']; % Behavioral data 


%% Calculate the total of correct responses i
% Load output file 
[code_event,myEvent,onsets,response,rt] = importMEGVSAResults(cfg.databh, 2, 157);


% Convert the response to the trigger code
for i=1:length(response)
    if strcmp(response{i}(1), 'T') == 1 || strcmp(response{i}(1), 'l') == 1; 
        response_recoded(i) = 32768; % left button press
    elseif strcmp(response{i}(1), 'L') == 1 || strcmp(response{i}(1), 't') == 1;
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

onset_op1 = onsets(1:2:length(onsets));
code_event_reshape = reshape(code_event,2,78);
onsets_reshape = reshape(onsets,2,78);

for i=1:length(code_event_reshape)
    code_event_reshape(3,i) = resp_only(i);
    onsets_reshape(3,i) = rt_resp_only(i)+onsets_reshape(2,i)
end
trigger_bh = reshape(code_event_reshape,78*3,1);
onsets_bh = reshape(onsets_reshape,78*3,1)*1000;

% Exclude 'no responses' from the behavioral triggers
% trigger_bh(trigger_bh==0) = [];
% onsets_bh(trigger_bh==0) = [];
end


