function [run, uniqueBlock,lengthSD, lengthADDSUB, lengthADD, lengthSUB] = ConsistencyMEGCalcStim(subjname)
% This function checks the consitency of the trials in each block of the
% Calc MEG experiment and returns:
%
% uniqueBlock: unique operations+single digits in each block
% all black should have 36 (32 operations + 4 single digits)
%
% uniqueBlock: 
% lengthSD: 
% lengthADDSUB:
% lengthADD:
% lengthSUB:
%
% [run, uniqueBlock,lengthSD, lengthADDSUB, lengthADD, lengthSUB] = ConsistencyMEGCalcStim('sub2')


%% Check consistency

% Stimuli directory
stimdir='/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/stimuli/Calc/'; 
subfolder = [stimdir subjname];

nruns = 10;
for i = 1:nruns
    run{i} = csvread([subfolder sprintf('/run%0i.csv',i)]);
end

%Remove the 3 train trials
for i = 1:nruns
    runs{i} = run{i}(4:end,:);
end

% Count the number of unique operations
for i = 1:length(runs)
    uniqueBlock(i) = length(unique(runs{i}(:,1:4), 'rows'));
end
% Unique runs per block should be 36
uniqueBlock = uniqueBlock';

% Concatenate all runs to calculate the frequencies of deviants
AddSubSD = vertcat(runs{:});
SDigitFinalSmallSD = AddSubSD(AddSubSD(:,2)==99,:);
AddSubFinalSmallSD = AddSubSD(AddSubSD(:,2)~=99,:);

SDigitFinalSame = SDigitFinalSmallSD(SDigitFinalSmallSD(:,5) == SDigitFinalSmallSD(:,1),:);
SDigitFinald1 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==1,:);
SDigitFinald2 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==2,:);
SDigitFinald3 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==3,:);
SDigitFinald4 = SDigitFinalSmallSD(abs(SDigitFinalSmallSD(:,5) - SDigitFinalSmallSD(:,1))==4,:);

lengthSD = [length(SDigitFinalSame),...
length(SDigitFinald1),...
length(SDigitFinald2),...
length(SDigitFinald3),...
length(SDigitFinald4)]'; 

% Put back the correct result in column 6
AddSubFinalSmallSD(:,7) = AddSubFinalSmallSD(:,1)+(AddSubFinalSmallSD(:,2)/10).*AddSubFinalSmallSD(:,3)

AddSubFinalSame = AddSubFinalSmallSD(AddSubFinalSmallSD(:,5) == AddSubFinalSmallSD(:,7),:);
AddSubFinald1 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,7))==1,:);
AddSubFinald2 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,7))==2,:);
AddSubFinald3 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,7))==3,:);
AddSubFinald4 = AddSubFinalSmallSD(abs(AddSubFinalSmallSD(:,5) - AddSubFinalSmallSD(:,7))==4,:);

AddFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==10,:);
AddFinald1 = AddSubFinald1(AddSubFinald1(:,2)==10,:);
AddFinald2 = AddSubFinald2(AddSubFinald2(:,2)==10,:);
AddFinald3 = AddSubFinald3(AddSubFinald3(:,2)==10,:);
AddFinald4 = AddSubFinald4(AddSubFinald4(:,2)==10,:);

SubFinalSame = AddSubFinalSame(AddSubFinalSame(:,2)==-10,:);
SubFinald1 = AddSubFinald1(AddSubFinald1(:,2)==-10,:);
SubFinald2 = AddSubFinald2(AddSubFinald2(:,2)==-10,:);
SubFinald3 = AddSubFinald3(AddSubFinald3(:,2)==-10,:);
SubFinald4 = AddSubFinald4(AddSubFinald4(:,2)==-10,:);

lengthADDSUB = [length(AddSubFinalSame),...
length(AddSubFinald1),...
length(AddSubFinald2),...
length(AddSubFinald3),...
length(AddSubFinald4)]'; 

lengthADD = [length(AddFinalSame),...
length(AddFinald1),...
length(AddFinald2),...
length(AddFinald3),...
length(AddFinald4)]'; 

lengthSUB = [length(SubFinalSame),...
length(SubFinald1),...
length(SubFinald2),...
length(SubFinald3),...
length(SubFinald4)]'; 

consistResults = tabulate(abs(AddSubFinalSmallSD(:,end-2)-AddSubFinalSmallSD(:,end)))

end



















% %%
% for i = 1:100
%     dev1(i) = AddSubstdFraw{i}(1); 
%     dev2(i) = AddSubstdFraw{i}(2);
%     dev3(i) = AddSubstdFraw{i}(3); 
%     dev4(i) = AddSubstdFraw{i}(4); 
%     same(i) = AddSubstdFraw{i}(5);
% end
% 
% devo = [dev1;dev2;dev3;dev4]'
% sum(devo, 2)
% 
% min(dev1)
% 
% 
% 
% boxplot(devo)
% 
% 
% save
% 
% 
% for i=1:length(AddSubFinal)
%     AddSubpresent = AddSubFinal{i};
%     deviant5{i} = AddSubpresent(abs(AddSubpresent(:,5)-AddSubpresent(:,4))==5,:);
% end
% 
%     
% error = vertcat(deviant5{:})
% 
% 
% unique(error(:,1:5), 'rows')