%function [stimList, Events, plugged_events, spourious_events, wrong_events,missing_events] = checkTriggersMEGVSA(subjname, runNumber)

% Function to calculate check the triggers of the MEG Calc experiment

% [events, eventsOnsets,Response,code_event,myEvent,onsets,response,rt] = checkTriggersMEGVSA('test', 2)

% [plugged_events, spourious_events, wrong_events,missing_events] = checkTriggersMEGVSA('s01', 1)
clear all

 subjname = 's02'
 runNumber = 4


%% Calculate the total of correct responses in



% Stimuli directory
% stimdir= sprintf('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/stimuli/Calc/%s',subjname); 
% resultdir= sprintf('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/results/Calc/%s',subjname); 
stimdir= sprintf('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/%s/VSA/stimuli',subjname); 
resultdir= sprintf('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/behavior/%s/VSA/results',subjname); 


% Load current run
% run = csvread([stimdir sprintf('/run%0i.csv',runNumber)]);

% Remove the 3 train trials
% run = run(4:end,:);

% Load current results
if subjname == 's01'
    filenameResult = [resultdir sprintf('/%0i_results_original.csv',runNumber)];
    [code_event,myEvent,onsets,response,rt] = importMEGVSAResults_inverted(filenameResult, 2, 157);
else
    filenameResult = [resultdir sprintf('/%0i_results.csv',runNumber)];
    [code_event,myEvent,onsets,response,rt] = importMEGVSAResults(filenameResult, 2, 157);

end

    
    
% myEventReshape = reshape(myEvent,5,43)'; 
% code_eventReshape = reshape(code_event,5,43)'; 

countCodeEvent = tabulate(code_event) 
countCodeEvent = countCodeEvent(countCodeEvent(:,2)~=0,1:2)

% Load current stimuli
filenameStimuli = [stimdir sprintf('/run%0i.csv',runNumber)];
[Cue,Letter,Position,Delay,Congruency] = importMEGVSAStimuli(filenameStimuli, 2, 79);


stimListFull = [code_event onsets]


% Convert the response to numbers
% if subjname == 's01'
    if runNumber == 1 | runNumber == 2
       asw = 1;
    else
       asw = 2;
    end
% end

for i = 1:length(response)
    letter = response{i}; 
    letterfirst = letter(1); 
    
    if asw == 1;
                if strmatch(letterfirst, '0') == 1
                    Resp(i) = 99;
                elseif strmatch(letterfirst, {'L','l'}) == 1 | strmatch(letterfirst, {'L','l'}) == 2 
                    Resp(i) = 1024; % left
                elseif strmatch(letterfirst, {'T','t'}) == 1 | strmatch(letterfirst, {'T','t'}) == 2
                       Resp(i) = 32768; % right                 
                else 
                       Resp(i) = 999;
                end
   else
                if strmatch(letterfirst, '0') == 1
                    Resp(i) = 99;
                elseif strmatch(letterfirst, {'L','l'}) == 1 | strmatch(letterfirst, {'L','l'}) == 2 
                    Resp(i) = 32768;
                elseif strmatch(letterfirst, {'T','t'}) == 1 | strmatch(letterfirst, {'T','t'}) == 2
                       Resp(i) = 1024;                 
                else 
                       Resp(i) = 999;
                end
        end        
end

% Count the responses
countResp = tabulate(Resp);
countResp = countResp(countResp(:,2)~=0,:);
countResp = countResp(ismember(countResp(:,1), [1024 32768]),1:2);

% Combine counting of events and responses
countEvents = [countCodeEvent; countResp];


%% Counting events from brainstorm 
eventdir = sprintf('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/correct_events/%s',subjname); 

% load event file
% load([eventdir sprintf('/events_calc%0i_sss_bandpass.mat',runNumber)]);
% This is because the name of the object inside this matfile has the same
% name as a matlab function 'events'. So I'm accesing the matfile first and
% then saving the object with a different name. 

% m = matfile([eventdir sprintf('/events_calc%0i_sss_bandpass.mat',runNumber)]);
m = matfile([eventdir sprintf('/events_vsa%0i_sss.mat',runNumber)]);


Events = m.events;

% Count events 

for i = 1:length(Events)
    eventLabel = str2num(Events(i).label);
    if isempty(eventLabel) == 1 
        btEvents(i,1) = 999999;
    else
        btEvents(i,1) = eventLabel;
    end
    
    btEvents(i,2) = length(Events(i).times);
end

%% Plug behavior events to brainstorm events
plugged_events = [countEvents btEvents(ismember(btEvents(:,1),countEvents(:,1)),2)];
plugged_events(:,4) = plugged_events(:,3)-plugged_events(:,2)

wrong_events = btEvents(~ismember(btEvents(:,1),countEvents(:,1)),:);
wrong_events = wrong_events(wrong_events(:,1) ~= 999999,:)

spourious_events = plugged_events(plugged_events(:,4)>0,[1 4])

missing_events = plugged_events(plugged_events(:,4)<0,[1 4])


%%

% 
% 
% %%
% 
% 
% responseCount = tabulate(Resp);
% responseCount = responseCount(responseCount(:,1)<99,:);
% 
% respOnsets{1} = [onsets(Resp==0)];
% respOnsets{2} = [onsets(Resp==1)];
% 
% save([resultdir sprintf('/EventsReport_run%0i.mat',runNumber)])

%end


