function conditions = defineConditionsERF(data)
% All
conditions.all.operand1 = unique(data.trialinfoCustom.operand1);
conditions.all.operator = unique(data.trialinfoCustom.operator);
conditions.all.operand2 = unique(data.trialinfoCustom.operand2);
conditions.all.corrResult = unique(data.trialinfoCustom.corrResult);
conditions.all.presResult = unique(data.trialinfoCustom.presResult);
conditions.all.deviant = unique(data.trialinfoCustom.deviant);
conditions.all.absdeviant = unique(data.trialinfoCustom.absdeviant);
conditions.all.delay = unique(data.trialinfoCustom.delay);
conditions.all.respSide = unique(data.trialinfoCustom.respSide);

% Comparison
conditions.comp = conditions.all;
conditions.comp.operator = 0;
conditions.comp.operand2 = 33;

conditions.add = conditions.all;
conditions.add.operator = 1;
conditions.add.operand2 = 0:3;

conditions.sub = conditions.add;
conditions.sub.operator = -1;

conditions.addsub = conditions.add;
conditions.addsub.operator = [-1 1];
end
