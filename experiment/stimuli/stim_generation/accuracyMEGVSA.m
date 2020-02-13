function accuracyMEGVSA(subjname, runNumber)

% Function to calculate correct responses in the MEG Calc experiment

% accuracyMEGVSA('ainaf', 1)
% subjname = 'ainaf'
% runNumber = 2


%% Calculate the total of correct responses in

% Stimuli directory
stimdir= sprintf('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/stimuli/VSA/%s',subjname); 
resultdir= sprintf('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/results/VSA/%s',subjname); 
stimFile = [stimdir sprintf('/run%0i.csv',runNumber)];
resultFile = [resultdir sprintf('/%0i_results.csv',runNumber)];

% Load current run
[Cue,Letter,Position,Delay,Congruency] = importMEGVSAStim(stimFile, 5, 79);

% Load current results
[code_event,myEvent,onsets,response,rt] = importMEGVSAResults(resultFile, 8, 157);

% Convert response to upper case
response = upper(response);

% Define events of interest
eventInt = 2:2:150;
MyEvent = myEvent(eventInt);
MyEvent = cell2mat(MyEvent);

Response = response(eventInt);
Response = cell2mat(Response);

% Calculate accuracy
accuracy = [sum(MyEvent == Response) sum(MyEvent == Response)/75*100]
miss = [sum(Response == '0') sum(Response == '0')/75*100]

RT = rt(eventInt);
RT(RT==0) = NaN;

% Calculate Mean and SD reaction time
Mean_SD_RT = [nanmean(RT) nanstd(RT)]

save([resultdir sprintf('/report_run%0i.mat',runNumber)])

end


