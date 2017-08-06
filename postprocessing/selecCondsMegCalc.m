function [conds_idx, labels] = selecCondsMegCalc(trialinfo, conds)

if strcmp(conds, 'corrResult') || strcmp(conds, 'presResult')
    conds_idx = (trialinfo.(conds) > 2 & trialinfo.(conds) < 7 & trialinfo.operator ~= 0);
    labels(:,1) = trialinfo.(conds)(conds_idx);
        
elseif strcmp(conds, 'operand1') || strcmp(conds, 'operand2')  || strcmp(conds, 'operator')
    conds_idx = trialinfo.operator ~= 0;
    labels(:,1) = trialinfo.(conds)(conds_idx);   
    
elseif strcmp(conds, 'corrResultnoZero')
    conds_idx = (trialinfo.corrResult > 2 & trialinfo.corrResult < 7 & trialinfo.operator ~= 0 & trialinfo.operand2 ~= 0);
    labels(:,1) = trialinfo.corrResult(conds_idx);
    
elseif strcmp(conds, 'calc')
    conds_idx = trialinfo.operator ~= 0;
    labels(:,1) = trialinfo.corrResult(conds_idx);   
    
elseif strcmp(conds, 'calc_noZero')
    conds_idx = trialinfo.operator ~= 0 & trialinfo.operand2 ~= 0;
    labels(:,1) = trialinfo.corrResult(conds_idx); 
    
elseif strcmp(conds, 'add')
    conds_idx = trialinfo.operator == 1;
    labels(:,1) = trialinfo.corrResult(conds_idx);      

elseif strcmp(conds, 'sub')
    conds_idx = trialinfo.operator == 1;
    labels(:,1) = trialinfo.corrResult(conds_idx);       
end
    
end

