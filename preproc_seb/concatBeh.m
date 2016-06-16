function merged = concatBeh(trialinfo)

all.run=[];
all.operand1 =[]; 
all.operator = [];
all.operand2 = [];
all.presResult = [];
all.delay = [];
all.corrResult = [];
all.deviant = [];
all.absdeviant = [];
all.rt = [];
all.respSide = [];

    for i = 1:length(trialinfo)
        all.run = [all.run,trialinfo(i).run];
        all.operand1 = [all.operand1,trialinfo(i).operand1];
        all.operator = [all.operator,trialinfo(i).operator];
        all.operand2 = [all.operand2,trialinfo(i).operand2];
        all.presResult = [all.presResult,trialinfo(i).presResult];
        all.delay = [all.delay,trialinfo(i).delay];
        all.corrResult = [all.corrResult,trialinfo(i).corrResult];
        all.deviant = [all.deviant,trialinfo(i).deviant];
        all.absdeviant = [all.absdeviant,trialinfo(i).absdeviant];
        all.rt = [all.rt,trialinfo(i).rt];
        all.respSide = [all.respSide,trialinfo(i).respSide];
    end
    
merged = all;
end
