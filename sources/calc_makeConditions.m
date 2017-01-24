%Purpose: This function selects a subset of trials based on behavioral/conditional
%parameters.
%Project: MenRot
%Author: Darinka Truebutschek
%Date: 24 May 2016

function [filter] = calc_makeConditions(params, data)

trialinfo = data.trialInfo; 

%Select the task (rot, no rot, or both)
task.rot = trialinfo.condition.cue ~= 2;
task.noRot = trialinfo.condition.cue == 2;
task.all = trialinfo.condition.cue >= 1;

%Select the visibility rating (1, 2, 3, 4, seen, or all)
vis.v1 = trialinfo.behavior.vis == 1;
vis.v2 = trialinfo.behavior.vis == 2;
vis.v3 = trialinfo.behavior.vis == 3;
vis.v4 = trialinfo.behavior.vis == 4;
vis.seen = trialinfo.behavior.vis  > 1;
vis.all = trialinfo.behavior.vis  > 0;

%Select the target position (all, present, absent, or specific location)
pos.all = trialinfo.condition.target >= 0;
pos.present = trialinfo.condition.target > 0;
pos.absent = trialinfo.condition.target == 0;
if isnumeric(params.poslab)
    pos.pos = ismember(trialinfo.condition.target, params.poslab);
end

%Select the accuracy (all, correct, incorrect)
acc.all = ~isnan(trialinfo.behavior.unconProbe.respnPos); %include only those answers that were appropriate
acc.correct = trialinfo.behavior.unconProbe.normDis >= -2 & trialinfo.behavior.unconProbe.normDis <= 2;
acc.incorrect = trialinfo.behavior.unconProbe.normDis < -2 | trialinfo.behavior.unconProbe.normDis > 2;

%Select all compatible trials
if isnumeric(params.poslab)
    filter = task.(params.tasklab ) & vis.(params.vislab) & pos.pos & acc.(params.acc);
else
    filter = task.(params.tasklab ) & vis.(params.vislab) & pos.(params.poslab) & acc.(params.acc);
end
end


    



 


