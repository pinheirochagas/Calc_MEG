%function [stimList, Events, plugged_events, spourious_events, wrong_events,missing_events] = checkTriggersMEGCalc(subjname, runNumber)

% Function to calculate check the triggers of the MEG Calc experiment

% [events, eventsOnsets,Response,code_event,myEvent,onsets,response,rt] = checkTriggersMEGCalc('test', 2)

% [plugged_events, spourious_events, wrong_events,missing_events] = checkTriggersMEGCalc('s01', 1)
clear all

subjname = 'sub1';
runNumber = 10;


%% Calculate the total of correct responses in

% Define paths
stimdir= sprintf('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/stimuli/Calc/%s',subjname); 
resultdir= sprintf('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/results/Calc/%s',subjname); 

% Load current run
% run = csvread([stimdir sprintf('/run%0i.csv',runNumber)]);

% Remove the 3 train trials
% run = run(4:end,:);

% Load current results
filenameResult = [resultdir sprintf('/%0i_results.csv',runNumber)];
[code_event,myEvent,onsets,response,rt] = importMEGCalcResults(filenameResult, 2, 216);

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
onset_1op = onsets(1:5:length(onsets));
code_event_reshape = reshape(code_event,5,43);

for i=1:length(code_event_reshape)
    code_event_reshape(6,i) = resp_only(i);
end
trigger_bh = reshape(code_event_reshape,43*6,1);



