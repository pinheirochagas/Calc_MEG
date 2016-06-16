function [trl,alltrig] = calc_correctTriggers(trl, alltrig, trigger_bh, onsets_bh)
% Correct triggers based on behavioral 

% Aligh onsets 

for i = 0:43
    trials{i} = alltrig(i:i+6,2)
end


reshape(alltrig, 43,6)


% Make sure that the meg trigger has more events
length(alltrig) > length(trigger_bh)

while length(alltrig) > length(trigger_bh)
    for i=1:length(trigger_bh)
        equal(i) = alltrig(i,2) == trigger_bh(i);
    end
    alltrig(min(find(equal==0)),:) = [];
end

% Check if the meg triggers matches the behavioral triggers
comp = alltrig(:,2) == trigger_bh;
find(comp == 0);

% Take the behavioral triggers as gold standard

[alltrig trigger_bh alltrig(:,2) == trigger_bh]

%%% TRICKY HERE THERE SEEMS TO BE AN EVENT MISSING CONTINUE!

end
