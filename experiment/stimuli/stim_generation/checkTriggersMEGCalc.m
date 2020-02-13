function [events, eventsOnsets,responseCount, code_event,myEvent,onsets,response1,rt] = checkTriggersMEGCalc(subjname, runNumber)

% Function to calculate correct responses in the MEG Calc experiment

% [events, eventsOnsets, Response,code_event,myEvent,onsets,response1,rt] = checkTriggersMEGCalc('test', 2)
% subjname = 'test'
% runNumber = 1


%% Calculate the total of correct responses in

% Stimuli directory
% stimdir= sprintf('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/stimuli/Calc/%s',subjname); 
resultdir= sprintf('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/results/Calc/%s',subjname); 


% Load current run
% run = csvread([stimdir sprintf('/run%0i.csv',runNumber)]);

% Remove the 3 train trials
% run = run(4:end,:);

% Load current results
filename = [resultdir sprintf('/%0i_results.csv',runNumber)];
[code_event,myEvent,onsets,response1,rt] = importMEGCalcResults(filename, 2, 216);



events = tabulate(code_event);
events = events(events(:,2)~=0,:);

for i = 1:length(events)
    eventIdx = events(i,1);
    eventsOnsets{i} = onsets(code_event(:,1)==eventIdx);
end


% Convert the response to numbers

for i = 1:length(response1)
    letter = response1{i}; 
    letterfirst = letter(1); 
       
    if strmatch(letterfirst, '9') == 1
        Resp(i) = 99;
    elseif strmatch(letterfirst, {'F','f'}) == 1 | strmatch(letterfirst, {'F','f'}) == 2
        Resp(i) = 0;
    elseif strmatch(letterfirst, {'T','t'}) == 1 | strmatch(letterfirst, {'T','t'}) == 2
        Resp(i) = 1;
    else 
        Resp(i) = 999;
    end
end


responseCount = tabulate(Resp);
responseCount = responseCount(responseCount(:,1)<99,:);

respOnsets{1} = [onsets(Resp==0)];
respOnsets{2} = [onsets(Resp==1)];

save([resultdir sprintf('/EventsReport_run%0i.mat',runNumber)])

end


