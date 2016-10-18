% Filter trials 
function [index_filter, data_filter] = calcFilterData(data, operation, cond, level)
% data = individual data
% operation = 1 0 -1 for add, comp and sub
% condition = string: 'operand1', 'deviant', etc
% level = number: 3, 0, etc. 
    
if strmatch(operation, 'add') == 1
    index_filter = data.trialinfoCustom.operator == 1 & data.trialinfoCustom.(cond) == level; 
elseif strmatch(operation, 'sub') == 1
    index_filter = data.trialinfoCustom.operator == -1 & data.trialinfoCustom.(cond) == level; 
elseif strmatch(operation, 'comp') == 1
    index_filter = data.trialinfoCustom.operator == 0 & data.trialinfoCustom.(cond) == level; 
elseif strmatch(operation, 'addsub') == 1
    index_filter = data.trialinfoCustom.operator ~= 0 & data.trialinfoCustom.(cond) == level; 
elseif strmatch(operation, 'all') == 1
    index_filter = data.trialinfoCustom.(cond) == level; 
else
    error('You can only specify add, sub, comp, add_sub or all for operation')
end

data.sampleinfo	= data.sampleinfo(index_filter,:);
data.trial = data.trial(index_filter); 
data.time = data.time(index_filter); 
data.ECGEOG = data.ECGEOG(index_filter);
data_filter = data;
end
