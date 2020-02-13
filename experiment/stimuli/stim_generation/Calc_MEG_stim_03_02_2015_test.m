%% Define Problems
op1 = [3 4 5 6];
op2 = [0 1 2 3];
% Create all possible combinations between operands
op1op2 = allcomb(op1,op2);
% Adding the results to the matrix
add = [op1op2(:,1), repmat(10,length(op1op2),1), op1op2(:,2), op1op2(:,1)+op1op2(:,2)];
sub = [op1op2(:,1), repmat(-10,length(op1op2),1), op1op2(:,2), op1op2(:,1)-op1op2(:,2)];
sdigit = [op1op2(:,1), repmat(99,length(op1op2),1), repmat(99,length(op1op2),1),op1op2(:,1)];

addsubUnique = [add;sub];
sdigitUnique = unique(sdigit, 'rows');

addsub = repmat(addsubUnique, 10,1); % this will produce 160 trials
sdigitrep = repmat(sdigit, 5,1); % this will produce 80 trials

tabulate(addsub(:,1))
tabulate(addsub(:,2))
tabulate(addsub(:,3))
tabulate(addsub(:,4))

% tabulate(addsub(:,1))
% tabulate(addsubsd(:,2))
% tabulate(addsubsd(:,3))
% tabulate(addsubsd(:,4))



for i = 1:length(addsubUnique)
    AddSub{i} = addsub(ismember(addsub,addsubUnique(i,:),'rows'),:)
end

for i = 1:length(sdigitUnique)
    SDigit{i} = sdigitrep(ismember(sdigitrep,sdigitUnique(i,:),'rows'),:)
end


% AddSub{cellfun('length',AddSub)==12}
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

% res1 = repmat(res1',2,1);
% res2 = repmat(res2',2,1);
% res3 = repmat(res3',2,1);
% res4 = repmat(res4',2,1);
% res5 = repmat(res5',2,1);
% res6 = repmat(res6',2,1);
% res7 = repmat(res7',2,1);
% res8 = repmat(res8',2,1);
% res9 = repmat(res9',2,1);
% 
% randsample(res1,12)
% randsample(res1,9)

niterations = 1000;
%%
tic
for rep = 1:niterations

    for i = 1:length(AddSub)
        ReSult = unique(AddSub{i}(:,4));
        distres = res{ReSult+1};
       
        if AddSub{i}(:,2) == 10
            distres = setdiff(distres,AddSub{i}(1,1)-AddSub{i}(1,3));
        else
            distres = setdiff(distres,AddSub{i}(1,1)+AddSub{i}(1,3));
        end
        
        devs = abs(distres - ReSult);

        for ii = 1:max(devs);
            vector = distres(find(devs==ii));
                if isempty(vector) == 1
                    distres_final(ii) = NaN;
                else
                    distres_final(ii) = vector(randsample(length(vector),1));
                end
        end
%         
         if length(find(devs==4))>0;
             addnumber = find(devs==4);
             distres_final = [repmat(distres_final,1,3) distres(addnumber(1))];
         end
%          
         distres_final = distres_final(~isnan(distres_final));
        
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

        clear distres_final % reset the distres to make sure it always has
                            % good size
    end
    
    
    % Concatenate all Adds and Subs
    AddSubAll{rep} = AddSub;
    AddSubFinal{rep} = vertcat(AddSub{:});
    AddSubF = AddSubFinal{rep};

%     % Calculate the sd for the frequency of the deviants in Add and Sub
%     AddSubFinalSame = AddSubF(AddSubF(:,5) == AddSubF(:,4),:);
%     AddSubFinald1 = AddSubF(abs(AddSubF(:,5) - AddSubF(:,4))==1,:);
%     AddSubFinald2 = AddSubF(abs(AddSubF(:,5) - AddSubF(:,4))==2,:);
%     AddSubFinald3 = AddSubF(abs(AddSubF(:,5) - AddSubF(:,4))==3,:);
%     AddSubFinald4 = AddSubF(abs(AddSubF(:,5) - AddSubF(:,4))==4,:);

%     AddSubstdF(rep) = std([length(AddSubFinald1),length(AddSubFinald2),...
%         length(AddSubFinald3),length(AddSubFinald4)]);
%    
%     AddSubstdFraw{rep} = [length(AddSubFinald1),length(AddSubFinald2),...
%         length(AddSubFinald3),length(AddSubFinald4)];  
%     

    % Calculate the sd for the frequency of the deviants in Add and Sub
    AddSubFinalSame = AddSubF(AddSubF(:,5) == AddSubF(:,4),:);
    AddSubFinaldM1 = AddSubF(AddSubF(:,5) - AddSubF(:,4)==-1,:);
    AddSubFinaldM2 = AddSubF(AddSubF(:,5) - AddSubF(:,4)==-2,:);
    AddSubFinaldM3 = AddSubF(AddSubF(:,5) - AddSubF(:,4)==-3,:);
    AddSubFinaldM4 = AddSubF(AddSubF(:,5) - AddSubF(:,4)==-4,:);
    AddSubFinaldP1 = AddSubF(AddSubF(:,5) - AddSubF(:,4)==1,:);
    AddSubFinaldP2 = AddSubF(AddSubF(:,5) - AddSubF(:,4)==2,:);
    AddSubFinaldP3 = AddSubF(AddSubF(:,5) - AddSubF(:,4)==3,:);
    AddSubFinaldP4 = AddSubF(AddSubF(:,5) - AddSubF(:,4)==4,:);

    AddSubstdF(rep) = std([length(AddSubFinaldM1),length(AddSubFinaldM2),...
        length(AddSubFinaldM3),length(AddSubFinaldM4),length(AddSubFinaldP1),...
        length(AddSubFinaldP2),length(AddSubFinaldP3),length(AddSubFinaldP4)]);
       
%     AddSubstdFraw{rep} = [length(AddSubFinald1),length(AddSubFinald2),...
%         length(AddSubFinald3),length(AddSubFinald4)];  
  
    
    % Calculate the sd for the frequency of the deviants in Add 
    AddFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==10,:);
    AddFinaldM1 = AddSubFinaldM1(AddSubFinaldM1(:,2)==10,:);
    AddFinaldM2 = AddSubFinaldM2(AddSubFinaldM2(:,2)==10,:);
    AddFinaldM3 = AddSubFinaldM3(AddSubFinaldM3(:,2)==10,:);
    AddFinaldM4 = AddSubFinaldM4(AddSubFinaldM4(:,2)==10,:);
    AddFinaldP1 = AddSubFinaldP1(AddSubFinaldP1(:,2)==10,:);
    AddFinaldP2 = AddSubFinaldP2(AddSubFinaldP2(:,2)==10,:);
    AddFinaldP3 = AddSubFinaldP3(AddSubFinaldP3(:,2)==10,:);
    AddFinaldP4 = AddSubFinaldP4(AddSubFinaldP4(:,2)==10,:);
    
    AddstdF(rep) = std([length(AddFinaldM1),length(AddFinaldM2),...
    length(AddFinaldM3),length(AddFinaldM4),length(AddFinaldP1),...
    length(AddFinaldP2),length(AddFinaldP3),length(AddFinaldP4)]);

    % Calculate the sd for the frequency of the deviants in Add 
    SubFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==10,:);
    SubFinaldM1 = AddSubFinaldM1(AddSubFinaldM1(:,2)==10,:);
    SubFinaldM2 = AddSubFinaldM2(AddSubFinaldM2(:,2)==10,:);
    SubFinaldM3 = AddSubFinaldM3(AddSubFinaldM3(:,2)==10,:);
    SubFinaldM4 = AddSubFinaldM4(AddSubFinaldM4(:,2)==10,:);
    SubFinaldP1 = AddSubFinaldP1(AddSubFinaldP1(:,2)==10,:);
    SubFinaldP2 = AddSubFinaldP2(AddSubFinaldP2(:,2)==10,:);
    SubFinaldP3 = AddSubFinaldP3(AddSubFinaldP3(:,2)==10,:);
    SubFinaldP4 = AddSubFinaldP4(AddSubFinaldP4(:,2)==10,:);
    
    SubstdF(rep) = std([length(SubFinaldM1),length(SubFinaldM2),...
    length(SubFinaldM3),length(SubFinaldM4),length(SubFinaldP1),...
    length(SubFinaldP2),length(SubFinaldP3),length(SubFinaldP4)]);

    % Combine the sd of the deviants for AddSub, Add and Sub
    globalDevSD(rep,1:3) = [AddSubstdF(rep) AddstdF(rep) SubstdF(rep)];
    
    % For the Single Digits
    for i = 1:length(SDigit)
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

    SDigitAll{rep} = SDigit;

    SDigitFinal{rep} = vertcat(SDigit{:});
    SDigitF = SDigitFinal{rep};

    SDigitFinalSame = SDigitF(SDigitF(:,5) == SDigitF(:,4),:);
    SDigitFinald1 = SDigitF(abs(SDigitF(:,5) - SDigitF(:,4))==1,:);
    SDigitFinald2 = SDigitF(abs(SDigitF(:,5) - SDigitF(:,4))==2,:);
    SDigitFinald3 = SDigitF(abs(SDigitF(:,5) - SDigitF(:,4))==3,:);
    SDigitFinald4 = SDigitF(abs(SDigitF(:,5) - SDigitF(:,4))==4,:);
    
    SDigitstdF(rep) = std([length(SDigitFinald1),length(SDigitFinald2),...
        length(SDigitFinald3),length(SDigitFinald4)]);
end
toc

PARE 

%%
globalDevSDSUM = sum(globalDevSD,2);
indexBestAddSub = find(globalDevSDSUM==min(globalDevSDSUM));

indexBestAddSub = find(AddSubstdF==min(AddSubstdF));
indexBestSDigit = find(SDigitstdF==min(SDigitstdF));

AddSubFinalSmallSD = AddSubFinal{indexBestAddSub};
length(AddSubFinalSmallSD)
SDigitFinalSmallSD = SDigitFinal{indexBestSDigit};
length(SDigitFinalSmallSD)

% substitute the correct result by 99
AddSubFinalSmallSD(:,4) = repmat(99,length(AddSubFinalSmallSD),1);
addsubUniqueEqual = [addsubUnique(:,1:3), repmat(99,length(addsubUnique),1)]

for i = 1:length(addsubUniqueEqual)
    AddSub_Final{i} = [AddSubFinalSmallSD(ismember(AddSubFinalSmallSD(:,1:end-1),addsubUniqueEqual(i,:),'rows'),:)]
end

sdigitmatrix = reshape(1:80, 8, 10)';

for i = 1:length(sdigitUnique)
    SDigit_Final{i} = SDigitFinalSmallSD(ismember(SDigitFinalSmallSD(:,1:end-1),sdigitUnique(i,:),'rows'),:)
end

% Shuffle each group of operations
for i = 1:length(SDigit_Final)
SDigit_Shuffle{i} = SDigit_Final{i}(shuffle(1:length(SDigit_Final{1})),:);
end

%  
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

for i = 1:length(runList)
runList_Shuffle{i}(:,6) = shuffle(repmat([0 400],1,20)');
end


% Export runs to csv in subject'folder
for i = 1:length(runList_Shuffle)
    csvwrite(sprintf('run%0i.csv',i), runList_Shuffle{i})
end


save 'stimList.mat'

%% Check consistency

for i = 1:length(runList_Shuffle)
    uniqueBlock(i) = length(unique(runList_Shuffle{i}(:,1:4), 'rows'));
end
uniqueBlock'


SDigitFinalSame = SDigitFinalSmallSD(SDigitFinalSmallSD(:,5) == SDigitFinalSmallSD(:,1),:)
SDigitFinald1 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==1,:)
SDigitFinald2 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==2,:)
SDigitFinald3 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==3,:)
SDigitFinald4 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==4,:)

[length(SDigitFinalSame),...
length(SDigitFinald1),...
length(SDigitFinald2),...
length(SDigitFinald3),...
length(SDigitFinald4)]'

% Put back the correct result in column 6
AddSubFinalSmallSD(:,6) = AddSubFinalSmallSD(:,1)+(AddSubFinalSmallSD(:,2)/10).*AddSubFinalSmallSD(:,3)
presResult = 5;
Result = 6;

tabulate(AddSubFinalSmallSD(:,6)-AddSubFinalSmallSD(:,5))

AddSubFinalSame = AddSubFinalSmallSD(AddSubFinalSmallSD(:,5) == AddSubFinalSmallSD(:,6),:)
AddSubFinald1 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,6))==1,:)
AddSubFinald2 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,6))==2,:)
AddSubFinald3 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,6))==3,:)
AddSubFinald4 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,6))==4,:)


AddFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==10,:)
AddFinald1 = AddSubFinald1(AddSubFinald1(:,2)==10,:)
AddFinald2 = AddSubFinald2(AddSubFinald2(:,2)==10,:)
AddFinald3 = AddSubFinald3(AddSubFinald3(:,2)==10,:)
AddFinald4 = AddSubFinald4(AddSubFinald4(:,2)==10,:)

SubFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==-10,:)
SubFinald1 = AddSubFinald1(AddSubFinald1(:,2)==-10,:)
SubFinald2 = AddSubFinald2(AddSubFinald2(:,2)==-10,:)
SubFinald3 = AddSubFinald3(AddSubFinald3(:,2)==-10,:)
SubFinald4 = AddSubFinald4(AddSubFinald4(:,2)==-10,:)

[length(AddSubFinalSame),...
length(AddSubFinald1),...
length(AddSubFinald2),...
length(AddSubFinald3),...
length(AddSubFinald4)]'


[length(AddFinalSame),...
length(AddFinald1),...
length(AddFinald2),...
length(AddFinald3),...
length(AddFinald4)]' 

[length(SubFinalSame),...
length(SubFinald1),...
length(SubFinald2),...
length(SubFinald3),...
length(SubFinald4)]'


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

