function accuracyMEGCalc(subjname, runNumber)

% Function to calculate correct responses in the MEG Calc experiment

% accuracyMEGCalc('ainaf', 1)
% subjname = 'ainaf'
% runNumber = 5


%% Calculate the total of correct responses in

% Stimuli directory
stimdir= sprintf('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/stimuli/Calc/%s',subjname); 
resultdir= sprintf('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/results/Calc/%s',subjname); 


% Load current run
run = csvread([stimdir sprintf('/run%0i.csv',runNumber)]);

% Remove the 3 train trials
run = run(4:end,:);

% Load current results
filename = [resultdir sprintf('/%0i_results.csv',runNumber)];
[code_event,myEvent,onsets,response1,rt] = importMEGCalcResults(filename, 17, 216);

% Check event codes 
eventInt = 5:5:200;

% Check code events
codeEvent = reshape(code_event, 5,40)'; 
CodeEventCheck = [codeEvent(:,1)-1 codeEvent(:,2) codeEvent(:,3)-21 codeEvent(:,4) codeEvent(:,5)-31];
CodeEventCheck(CodeEventCheck(:,2)==51,2) = -10;
CodeEventCheck(CodeEventCheck(:,2)==53,2) = 10;
CodeEventCheck(CodeEventCheck(:,2)==54,2) = 99;
CodeEventCheck(CodeEventCheck(:,3)==33,3) = 99;
CodeEventCheck(CodeEventCheck(:,4)==55,4) = 99;
CodeEventCheck(CodeEventCheck(:,5)>=10,5) = CodeEventCheck(CodeEventCheck(:,5)>=10,5)-10;

MyEvent = reshape(myEvent, 5,40)';
checkEventCodes = sum(MyEvent == CodeEventCheck)/40

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

Response = Resp(eventInt)'; 

%% Calculate accuracy

% Recover the correct result
Result = MyEvent(:,1) + MyEvent(:,2)/10 .* MyEvent(:,3);
Result(Result>10) = MyEvent(MyEvent(:,2)==99,1);
MyEventResult = [MyEvent Result];

% Read the correct result
CorrectResult = MyEventResult(:,5) == MyEventResult(:,6);

accuracy = [sum(CorrectResult == Response) sum(CorrectResult == Response)/40*100]
miss = [sum(Response == 999) sum(Response == 999)/40*100]

CorrectResps = CorrectResult == Response;
InCorrectResps = CorrectResult ~= Response; 


%% Calculate Reaction Time
RT = rt(eventInt);

Mean_SD_RT_Correct = [mean(RT(CorrectResps)) std(RT(CorrectResps))]
Mean_SD_RT_InCorrect = [mean(RT(InCorrectResps)) std(RT(InCorrectResps))]

save([resultdir sprintf('/report_run%0i.mat',runNumber)])

end


