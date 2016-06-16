function trialTriggersAll = getTrialTriggers(epoch)

for e = 1:length(epoch)
    trl = epoch{e}.triggers.trl;
    alltrig = epoch{e}.triggers.alltrig;
    for i=1:1:size(trl,1) % get all triggers between each pair of triggers in the trl
        if i < size(trl,1)
        trialTriggers{e}{i}=  alltrig(alltrig(:,1) >= trl(i,1) & alltrig(:,1) < trl(i+1,1),:) ;
        else
        trialTriggers{e}{i}=  alltrig(alltrig(:,1) >= trl(i,1),:);
        end 
    end

end
trialTriggersAll = horzcat(trialTriggers{:});
end

