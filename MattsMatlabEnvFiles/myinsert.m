function outstr=myinsert(instr,addstr,pos)
% function outstr=myinsert(instr,addstr,pos)
%
% This will insert the values of addstr into instr to create outstr, so
% that the the first element of addstr will be at position pos in outstr.
% This can work on strings, or numeric vectors.

outstr=[instr(1:pos-1) addstr instr(pos:end)];