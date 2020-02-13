function CalcCreateRuns(id)

% Load stimuli
load('stimList.mat')

% Store each group of operation in a given cell
for i = 1:length(addsubUnique)
    AddSub_Final{i} = AddSubFinalSmallSD(ismember(AddSubFinalSmallSD(:,1:end-1),addsubUnique(i,:),'rows'),:);
end

% Shuffle each group of operations
for i = 1:length(AddSub_Final)
AddSub_Shuffle{i} = AddSub_Final{i}(shuffle(1:10),:);
end

% Create 10 runs. Each run contains 32 operations (one of each)
run1 = zeros(32,5);
for e = 1:10
    for i = 1:length(AddSub_Shuffle)
        runList{e}(i,:) = AddSub_Shuffle{i}(e,:);
    end
end

% Shuffle order in each run
for i = 1:length(runList)
runList_Shuffle{i} = runList{i}(shuffle(1:32),:);
end

% Substitute correct answer column by equal sign (99)
for i = 1:length(runList_Shuffle)
runList_Shuffle{i}(:,4) = repmat(99,32,1);
end

% Create subject's directory
if exist(id, 'dir') == 0; 
   mkdir(id)
end

% Export runs to csv
for i = 1:length(runList_Shuffle)
    csvwrite(sprintf('%0s/run%0i.csv',id,i), runList_Shuffle{i})
end

end


    
