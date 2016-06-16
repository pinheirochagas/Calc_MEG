function [alltrig, exctrials, alltrigNew] = correctAlltrig(alltrig, trigger_bh)


trigger_bh_reshape = reshape(trigger_bh,3,78);

% Organize behavior data in a cell array excluding "no responses" 
for i=1:78
    idxNonZeros = trigger_bh_reshape(:,i) ~= 0;
    trigger_bh_trial{i} = trigger_bh_reshape(idxNonZeros,i);    
end

% Exclude some spurious events
equal = 0;
if length(alltrig) > length(trigger_bh) && all(equal) ~= 1   
    while length(alltrig) > length(trigger_bh) && all(equal) ~= 1
        for i=1:length(trigger_bh)
            equal(i) = alltrig(i,2) == trigger_bh(i);
        end
        alltrig(min(find(equal==0)),:) = [];
    end
else
end

% Find the starting index of each trial present in behavioral data in the
% MEG trigger data
for i=1:78
    indexTrialMEG{i} = strfind(alltrig(:,2)', trigger_bh_trial{i}');
end
% Get the unique indices (some trials will repeat);
correctTrialidx = unique(horzcat(indexTrialMEG{:}));

% Recover each trial based on the index of the first element in the
% sequence
for i=correctTrialidx
    alltrigNew{i} = alltrig(i:i+2,:);
end
% Exclude empty cells
alltrigNew = alltrigNew(~cellfun(@isempty,alltrigNew));

% Exclude the last event if it is not a response
for i=1:length(alltrigNew)
    if alltrigNew{i}(end,2) < 1000
        alltrigNew{i}(end,:) = [];
    else
    end
end

exctrials = 78-length(alltrigNew);

% Concatenate MEG data back! 
alltrig = vertcat(alltrigNew{:});
end


