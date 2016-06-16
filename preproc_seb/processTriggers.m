function[trialInfo] = processTriggers(trl,alltrig)



for i=1:1:size(trl,1) % get all triggers between each pair of triggers in the trl
    if i < size(trl,1)
    trialTriggers{i}=  alltrig(alltrig(:,1) >= trl(i,1) & alltrig(:,1) < trl(i+1,1),:) ;
    else
    trialTriggers{i}=  alltrig(alltrig(:,1) >= trl(i,1),:);
    end 
end


for i=1:1:size(trialTriggers,2)
    ntrigs(i) = size(trialTriggers{i},1);
    % check that  condition triggers values makes sense (given their order)
    if trialTriggers{i}(1,2) == 5 || ( trialTriggers{i}(1,2)>=11 && trialTriggers{i}(1,2) <=30)
        valid{i}(1) = 1;
    else
        valid{i}(1) = 0 ;
    end
    if trialTriggers{i}(2,2) == 6 || ( trialTriggers{i}(2,2)>=31 && trialTriggers{i}(2,2) <=50)
        valid{i}(2) = 1;
    else
        valid{i}(2) = 0;
    end
    if trialTriggers{i}(3,2) == 7 || ( trialTriggers{i}(3,2)>=51 && trialTriggers{i}(3,2) <=54)
        valid{i}(3) = 1;
    else
        valid{i}(3) = 0;
    end
    
    
    if sum(valid{i}) == 3 % are  condition triggers ok?
        % assign condition triggers
        triggers{i}.target =trialTriggers{i}(1,2);
        triggers{i}.distractor= trialTriggers{i}(2,2);
        triggers{i}.delay = trialTriggers{i}(3,2);
        
        if size(trialTriggers{i},1) >3 % check if another triggers exists (response trigger)
            if trialTriggers{i}(4,2) == 64 ||  trialTriggers{i}(4,2) == 128 ||  trialTriggers{i}(4,2) == 256 ||  trialTriggers{i}(4,2) == 512
                valid{i}(4) = 1;
                triggers{i}.visibilityResponse = trialTriggers{i}(4,2);
            else
                valid{i}(4) = 0;
                triggers{i}.visibilityResponse = nan;
            end
        else
            valid{i}(4) = 0;
            triggers{i}.visibilityResponse = nan;
        end
    else % condition triggers were not ok
        triggers{i}.target =nan;
        triggers{i}.distractor= nan;
        triggers{i}.delay = nan;
        triggers{i}.visibilityResponse = nan;
    end
end

% transform triggers into more meaninful condition values

for i=1:1:length(triggers)
    if triggers{i}.target == 5
        trialInfo.condition.target(i) = 0;
    elseif  triggers{i}.target >=11  && triggers{i}.target  <= 30
        trialInfo.condition.target(i) = triggers{i}.target -10;
    else
        trialInfo.condition.target(i) = nan;
    end
   if triggers{i}.distractor == 6
       trialInfo.condition.distractor(i) = 0;
   elseif triggers{i}.distractor >= 31 && triggers{i}.distractor <= 50
       trialInfo.condition.distractor(i) = triggers{i}.distractor -30;
   else
       trialInfo.condition.distractor(i) = nan;
   end
   if triggers{i}.delay == 7
       trialInfo.condition.delay(i) = 0;
   elseif triggers{i}.delay >= 51 && triggers{i}.delay <=54
       trialInfo.condition.delay(i) = triggers{i}.delay-50;
   else
       trialInfo.condition.delay(i) = nan;
   end
      
   switch triggers{i}.visibilityResponse
       case 512
           trialInfo.behavior.visibility(i) =1;
       case 256
           trialInfo.behavior.visibility(i) =2;
       case 128
           trialInfo.behavior.visibility(i) = 3;
       case 64
           trialInfo.behavior.visibility(i) = 4;
       otherwise
           trialInfo.behavior.visibility(i) = nan;
   end
     
end
pause =1;   
