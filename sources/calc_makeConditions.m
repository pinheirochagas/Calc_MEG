function [filter] = calc_makeConditions(params, data)
%% This function selects a subset of trials based on behavioral/conditional
trialinfo = data.trialinfo;

%Select the conditions (addition, subtraction, comparison, etc)
cond.add = trialinfo.operator == 1;
cond.sub = trialinfo.operator == -1;
cond.addsub = trialinfo.operator ~= 0;
cond.comp = trialinfo.operator == 0;

%Select the operand of interest
op.opall = trialinfo.operand1 > 0;

op.op1_3 = trialinfo.operand1 == 3;
op.op1_4 = trialinfo.operand1 == 4;
op.op1_5 = trialinfo.operand1 == 5;
op.op1_6 = trialinfo.operand1 == 6;
op.op2_0 = trialinfo.operand2 == 0;
op.op2_1 = trialinfo.operand2 == 1;
op.op2_2 = trialinfo.operand2 == 2;
op.op2_3 = trialinfo.operand2 == 3;
op.cRes_3 = trialinfo.operand1 == 3;
op.cRes_4 = trialinfo.operand1 == 4;
op.cRes_5 = trialinfo.operand1 == 5;
op.cRes_6 = trialinfo.operand1 == 6;

%Select all compatible trials
filter = cond.(params.cond_lab ) & op.(params.op_lab);

end


   



 



