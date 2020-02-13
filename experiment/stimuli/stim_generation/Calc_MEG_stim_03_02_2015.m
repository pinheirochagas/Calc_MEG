
%% Function to generate the list of trials for the MEG CALC experiment
%
%
%% Define Problems 
op1 = [3 4 5 6];
op2 = [0 1 2 3];

% Create all possible combinations between operands
op1op2 = allcomb(op1,op2);
% Adding the results to the matrix
add = [op1op2(:,1), repmat(10,length(op1op2),1), op1op2(:,2), op1op2(:,1)+op1op2(:,2)];
sub = [op1op2(:,1), repmat(-10,length(op1op2),1), op1op2(:,2), op1op2(:,1)-op1op2(:,2)];
% For single digits
sdigit = [op1op2(:,1), repmat(99,length(op1op2),1), repmat(99,length(op1op2),1),op1op2(:,1)];

addsubUnique = [add;sub];
sdigitUnique = unique(sdigit, 'rows');

addsub = repmat(addsubUnique, 10,1); % this will produce 160 trials
sdigitrep = repmat(sdigit, 5,1); % this will produce 80 trials

% Just checking
tabulate(addsub(:,1))
tabulate(addsub(:,2))
tabulate(addsub(:,3))
tabulate(addsub(:,4))

% Separate each given operation repeated in a cell 
for i = 1:length(addsubUnique)
    AddSub{i} = addsub(ismember(addsub,addsubUnique(i,:),'rows'),:)
end

% Separate each given single digit repeated in a cell 
for i = 1:length(sdigitUnique)
    SDigit{i} = sdigitrep(ismember(sdigitrep,sdigitUnique(i,:),'rows'),:)
end


% List the possible results for the deviant trials. 
res{1} = [1 2 3 4];             % Result 0
res{2} = [2 3 4 5];             % Result 1
res{3} = [1 3 4 5 6];           % Result 2
res{4} = [1 2 4 5 6 7];         % Result 3
res{5} = [1 2 3 5 6 7 8];       % Result 4
res{6} = [1 2 3 4 6 7 8 9];     % Result 5
res{7} = [2 3 4 5 7 8 9];       % Result 6
res{8} = [3 4 5 6 8 9];         % Result 7
res{9} = [4 5 6 7 9];           % Result 8
res{10} = [5 6 7 8];            % Result 9

% Define the number of itarations (number of lists to be generated)
niterations = 1000;
%%
tic
for rep = 1:niterations
    % Select the result of the current operation    
    for i = 1:length(AddSub)
        ReSult = unique(AddSub{i}(:,4));
        % Chose the list of possible results of the gi
        distres = res{ReSult+1};
        
        % Remove possible result of an operation when sign is inverted
        if AddSub{i}(:,2) == 10
            distres = setdiff(distres,AddSub{i}(1,1)-AddSub{i}(1,3));
        else
            distres = setdiff(distres,AddSub{i}(1,1)+AddSub{i}(1,3));
        end
        
        % Transfor the list of possible results in abslute deviants
        devs = abs(distres - ReSult);
        
        % Make sure all deviants are going to be chosen 
        for ii = 1:max(devs);
            vector = distres(find(devs==ii));
                if isempty(vector) == 1
                    distres_final(ii) = NaN;
                else
                    distres_final(ii) = vector(randsample(length(vector),1));
                end
        end
        distres_final = distres_final(~isnan(distres_final));

        % Compensate for the lower probability of deviant 4
        if length(find(devs==4))>0;
            addnumber = find(devs==4);
            distres_final = [repmat(distres_final,1,3) distres(addnumber(1))];
        end
        
        % Select the deviants and place then into the operation cell
        AddSub{i}(1:5,5) = repmat(AddSub{i}(1,4),1) ;    
        if length(distres_final) >= 5
           AddSub{i}(6:end,5) = [randsample(distres_final,5)'];
        elseif  length(distres_final) == 4
            AddSub{i}(6:end,5) = [randsample(distres_final,4)';randsample(distres_final,1)'];
        elseif length(distres_final) == 3                                                                 % In this case, I take the 4 avaiables and an additional 1. 
            AddSub{i}(6:end,5) = [randsample(distres_final,3)';randsample(distres_final,2)'];
        elseif length(distres_final) == 2                                                                 % In this case, I take the 4 avaiables and an additional 1. 
            AddSub{i}(6:end,5) = [randsample(distres_final,2)';randsample(distres_final,2)';randsample(distres_final,1)'];
        end
%         i
%         abs(AddSub{i}(:,5)-AddSub{i}(:,4)) 
        % Reset the distres to make sure it always has the correct size
        clear distres_final 
    end
    
    
    % Concatenate all Adds and Subs
    AddSubAll{rep} = AddSub;
    AddSubFinal{rep} = vertcat(AddSub{:});
    AddSubF = AddSubFinal{rep};

    % Calculate the sd for the frequency of the deviants in Add and Sub
    AddSubFinalSame = AddSubF(AddSubF(:,5) == AddSubF(:,4),:);
    AddSubFinald1 = AddSubF(abs(AddSubF(:,5) - AddSubF(:,4))==1,:);
    AddSubFinald2 = AddSubF(abs(AddSubF(:,5) - AddSubF(:,4))==2,:);
    AddSubFinald3 = AddSubF(abs(AddSubF(:,5) - AddSubF(:,4))==3,:);
    AddSubFinald4 = AddSubF(abs(AddSubF(:,5) - AddSubF(:,4))==4,:);

    AddSubstdF(rep) = std([length(AddSubFinald1),length(AddSubFinald2),...
        length(AddSubFinald3),length(AddSubFinald4)]);
    AddSubstdFraw{rep} = [length(AddSubFinald1),length(AddSubFinald2),...
        length(AddSubFinald3),length(AddSubFinald4)];  
        
    % Calculate the sd for the frequency of the deviants in Add 
    AddFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==10,:);
    AddFinald1 = AddSubFinald1(AddSubFinald1(:,2)==10,:);
    AddFinald2 = AddSubFinald2(AddSubFinald2(:,2)==10,:);
    AddFinald3 = AddSubFinald3(AddSubFinald3(:,2)==10,:);
    AddFinald4 = AddSubFinald4(AddSubFinald4(:,2)==10,:);
   
    AddstdF(rep) = std([length(AddFinald1),length(AddFinald2),...
    length(AddFinald3),length(AddFinald4)]);

    % Calculate the sd for the frequency of the deviants in Add 
    SubFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==10,:);
    SubFinald1 = AddSubFinald1(AddSubFinald1(:,2)==10,:);
    SubFinald2 = AddSubFinald2(AddSubFinald2(:,2)==10,:);
    SubFinald3 = AddSubFinald3(AddSubFinald3(:,2)==10,:);
    SubFinald4 = AddSubFinald4(AddSubFinald4(:,2)==10,:);
    
    SubstdF(rep) = std([length(SubFinald1),length(SubFinald2),...
    length(SubFinald3),length(SubFinald4)]);

    % Combine the sd of the deviants for AddSub, Add and Sub
    globalDevSD(rep,1:3) = [AddSubstdF(rep) AddstdF(rep) SubstdF(rep)];
    
    % For the Single Digits
    for i = 1:length(SDigit)
        % Select the result of the single digit    
        distres = res{unique(SDigit{i}(:,4))+1};
        SDigit{i}(1:10,5) = repmat(SDigit{i}(1,4),1) ;    
        if  length(distres) > 5
            SDigit{i}(11:end,5) = [randsample(distres,6)';randsample(distres,4)'];
        elseif length(distres) == 5                                                                 % In this case, I take the 4 avaiables and an additional 1. 
            SDigit{i}(11:end,5) = [randsample(distres,5)';randsample(distres,5)'];
        elseif length(distres) == 4                                                                 % In this case, I take the 4 avaiables and an additional 1. 
            SDigit{i}(11:end,5) = [randsample(distres,4)';randsample(distres,4)';randsample(distres,2)];
        end
    end

    % Concatenate all single digits
    SDigitAll{rep} = SDigit;
    SDigitFinal{rep} = vertcat(SDigit{:});
    SDigitF = SDigitFinal{rep};

    % Calculate the sd for the frequency of the deviants in single digits 
    SDigitFinalSame = SDigitF(SDigitF(:,5) == SDigitF(:,4),:);
    SDigitFinald1 = SDigitF(abs(SDigitF(:,5) - SDigitF(:,4))==1,:);
    SDigitFinald2 = SDigitF(abs(SDigitF(:,5) - SDigitF(:,4))==2,:);
    SDigitFinald3 = SDigitF(abs(SDigitF(:,5) - SDigitF(:,4))==3,:);
    SDigitFinald4 = SDigitF(abs(SDigitF(:,5) - SDigitF(:,4))==4,:);
   
    SDigitstdF(rep) = std([length(SDigitFinald1),length(SDigitFinald2),...
        length(SDigitFinald3),length(SDigitFinald4)]);
end
toc

%% Select the operation list with smaller variance in deviants
globalDevSDSUM = sum(globalDevSD,2);
% Here it is possible to find more the one min, it will take the first! 
indexBestAddSub = find(globalDevSDSUM==min(globalDevSDSUM));
indexBestSDigit = find(SDigitstdF==min(SDigitstdF));

AddSubFinalSmallSD = AddSubFinal{indexBestAddSub};
length(AddSubFinalSmallSD)
SDigitFinalSmallSD = SDigitFinal{indexBestSDigit};
length(SDigitFinalSmallSD)

% Substitute the correct result by 99
AddSubFinalSmallSD(:,4) = repmat(99,length(AddSubFinalSmallSD),1);
addsubUniqueEqual = [addsubUnique(:,1:3), repmat(99,length(addsubUnique),1)];

% Put each operation in a separated cell AGAIN 
for i = 1:length(addsubUniqueEqual)
    AddSub_Final{i} = [AddSubFinalSmallSD(ismember(AddSubFinalSmallSD(:,1:end-1),addsubUniqueEqual(i,:),'rows'),:)]
end

% Put each single digit in a separated cell AGAIN 
% sdigitmatrix = reshape(1:80, 8, 10)';
for i = 1:length(sdigitUnique)
    SDigit_Final{i} = SDigitFinalSmallSD(ismember(SDigitFinalSmallSD(:,1:end-1),sdigitUnique(i,:),'rows'),:)
end

% Shuffle each group of single digit
for i = 1:length(SDigit_Final)
SDigit_Shuffle{i} = SDigit_Final{i}(shuffle(1:length(SDigit_Final{1})),:);
end


%  Split single digits in 10 blocks
sdigitmatrix = reshape(1:20, 2, 10)';
sdigitmatrix2 = reshape(1:8, 2, 4)';
for i = 1:10
    for e = 1:4 
        SDigit_split{i}(sdigitmatrix2(e,:),:) = SDigit_Shuffle{e}(sdigitmatrix(i,:),:);
    end
end


% Shuffle each group of operations
for i = 1:length(AddSub_Final)
AddSub_Shuffle{i} = AddSub_Final{i}(shuffle(1:10),:);
end


% Create 10 runs. Each run contains 32 operations (one of each) + 8 sd
% digits
% runList = zeros(40,5);
for e = 1:10
    for i = 1:length(AddSub_Shuffle)
        runList{e}(i,:) = [AddSub_Shuffle{i}(e,:)];
    end
    runListFinal{e} = [runList{e};SDigit_split{e}];
%     runList{e}(33:40,:) = SDigitFinalSmallSDShuflle(1:8,:)
end

% Shuffle order in each run
for i = 1:length(runList)
runList_Shuffle{i} = runListFinal{i}(shuffle(1:40),:);
end

% Add the delay of 0 or 400ms randomly
for i = 1:length(runList)
runList_Shuffle{i}(:,6) = shuffle(repmat([0 400],1,20)');
end

% Add additional 3 training trials in the begining of each run
% One training trial for single digit, ADD and SUB
for i = 1:length(runList)
    indexTrainSD = randsample(find(runList_Shuffle{i}(:,2)==99),1);
    indexTrainADD = randsample(find(runList_Shuffle{i}(:,2)==-10),1);
    indexTrainSUB = randsample(find(runList_Shuffle{i}(:,2)==10),1);
    indexTrain = shuffle([indexTrainSD indexTrainADD indexTrainSUB]);
    runList_Shuffle{i} = [runList_Shuffle{i}(indexTrain,:); runList_Shuffle{i}];
end

%% Export runs to csv in subject'folder
for i = 1:length(runList_Shuffle)
    csvwrite(sprintf('run%0i.csv',i), runList_Shuffle{i})
end
% Save also all the workspace just in case
save 'stimList.mat'

%%


% %% Check consistency
% 
% for i = 1:length(runList_Shuffle)
%     uniqueBlock(i) = length(unique(runList_Shuffle{i}(:,1:4), 'rows'));
% end
% uniqueBlock'
% 
% 
% SDigitFinalSame = SDigitFinalSmallSD(SDigitFinalSmallSD(:,5) == SDigitFinalSmallSD(:,1),:)
% SDigitFinald1 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==1,:)
% SDigitFinald2 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==2,:)
% SDigitFinald3 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==3,:)
% SDigitFinald4 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==4,:)
% 
% [length(SDigitFinalSame),...
% length(SDigitFinald1),...
% length(SDigitFinald2),...
% length(SDigitFinald3),...
% length(SDigitFinald4)]'
% 
% % Put back the correct result in column 6
% AddSubFinalSmallSD(:,6) = AddSubFinalSmallSD(:,1)+(AddSubFinalSmallSD(:,2)/10).*AddSubFinalSmallSD(:,3)
% 
% % Check the imbalance between deviants smaller and larger then result
% for i = 1:100
%     AddSubMP = AddSubFinal{i};
%     tabulate(AddSubMP(:,4)-AddSubMP(:,5))
% end
% 
% 
% AddSubFinalSame = AddSubFinalSmallSD(AddSubFinalSmallSD(:,5) == AddSubFinalSmallSD(:,6),:)
% AddSubFinald1 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,6))==1,:)
% AddSubFinald2 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,6))==2,:)
% AddSubFinald3 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,6))==3,:)
% AddSubFinald4 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,6))==4,:)
% 
% 
% AddFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==10,:)
% AddFinald1 = AddSubFinald1(AddSubFinald1(:,2)==10,:)
% AddFinald2 = AddSubFinald2(AddSubFinald2(:,2)==10,:)
% AddFinald3 = AddSubFinald3(AddSubFinald3(:,2)==10,:)
% AddFinald4 = AddSubFinald4(AddSubFinald4(:,2)==10,:)
% 
% SubFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==-10,:)
% SubFinald1 = AddSubFinald1(AddSubFinald1(:,2)==-10,:)
% SubFinald2 = AddSubFinald2(AddSubFinald2(:,2)==-10,:)
% SubFinald3 = AddSubFinald3(AddSubFinald3(:,2)==-10,:)
% SubFinald4 = AddSubFinald4(AddSubFinald4(:,2)==-10,:)
% 
% [length(AddSubFinalSame),...
% length(AddSubFinald1),...
% length(AddSubFinald2),...
% length(AddSubFinald3),...
% length(AddSubFinald4)]'
% 
% 
% [length(AddFinalSame),...
% length(AddFinald1),...
% length(AddFinald2),...
% length(AddFinald3),...
% length(AddFinald4)]' 
% 
% [length(SubFinalSame),...
% length(SubFinald1),...
% length(SubFinald2),...
% length(SubFinald3),...
% length(SubFinald4)]'


% tabulate(AddSubFinalSmallSD(:,5))
% tabulate(addsub(:,2))
% tabulate(addsub(:,3))
% tabulate(addsub(:,4))


% %%
% % Trial Duration
% %             1op ISI Sig ISI 2op ISI EqS ISI Resp ITI 
% trial_dur1 = (400+400+400+400+400+400+400+400+400+2000)/1000
% trial_dur2 = (400+400+400+400+400+400+400+400+800+2000)/1000
% 
% n_trials = 160+160+80
% 
% exp_dur = ((n_trials/2)*trial_dur1+(n_trials/2)*trial_dur2)/60
% 
% 
% trial_dur_vis = 3
% n_trials_vis = 300
% exp_dur_vis = (n_trials_vis*trial_dur_vis)/60

