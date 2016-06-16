function merged = concatBehVSA(trialinfo)

    all.run = []; 
    all.cue = [];
    all.targetAll = [];
    all.target = [];
    all.targetSide = [];
    all.congruency = [];
    all.rt = [];
    all.respSide = [];

        for i = 1:length(trialinfo)
            all.run = [all.run,trialinfo(i).run];
            all.cue = [all.cue,trialinfo(i).cue];
            all.targetAll = [all.targetAll,trialinfo(i).targetAll];
            all.target = [all.target,trialinfo(i).target];
            all.targetSide = [all.targetSide,trialinfo(i).targetSide];
            all.congruency = [all.congruency,trialinfo(i).congruency];
            all.rt = [all.rt,trialinfo(i).rt];
            all.respSide = [all.respSide,trialinfo(i).respSide];
        end
    
merged = all;
end
