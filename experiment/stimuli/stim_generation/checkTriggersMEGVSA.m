function [events, eventsOnsets,code_event,myEvent,onsets,response,rt] = checkTriggersMEGVSA(subjname, runNumber)

% Function to calculate correct responses in the MEG Calc experiment

% [events, eventsOnsets,code_event,myEvent,onsets,response,rt] = checkTriggersMEGVSA('test', 1)
% subjname = 'test'
% runNumber = 1


%% Calculate the total of correct responses in

%% Calculate the total of correct responses in

% Stimuli directory
resultdir= sprintf('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/results/VSA/%s',subjname); 
resultFile = [resultdir sprintf('/%0i_results.csv',runNumber)];

% Load current results
[code_event,myEvent,onsets,response,rt] = importMEGVSAResults(resultFile, 2, 151);

events = tabulate(code_event);
events = events(events(:,2)~=0,:);

for i = 1:length(events)
    eventIdx = events(i,1);
    eventsOnsets{i} = onsets(code_event(:,1)==eventIdx);
end

save([resultdir sprintf('/EventsReport_run%0i.mat',runNumber)])

end


