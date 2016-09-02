% isvar.m; not function out=isvar(VarList)
% Funny, this actually has to be a script m file, not a function because 
% you cannot use who or any other way that I'm aware of to test the 
% workspace outside of the function's workspace during a function call
%
% This script checks to see if the string in VarList (in the workspace that
% calls it) is a variable in the workspace that calls it. Do NOT call isvar
% with any input arguments. The output is put in the numeric vector VarAns.
%
% VarList can also be a a 1D cell array of variables to look for, with a 1 
% or 0 output in the numeric column vector VarAns corresponding to each variable
%
% created by MJN 060514

VarListw=who;
if iscell(VarList)
    VarAns=zeros(length(VarList),1);
    for iVarList=1:length(VarList)
        for iVarListw=1:length(VarListw)      
            if strcmp(VarListw{iVarListw},VarList{iVarList})
                VarAns(iVarList) = 1;
                break
            end
        end

    end
else
    VarAns=0;
    for iVarListw=1:length(VarListw)
        if strcmp(VarListw{iVarListw},VarList)
            VarAns = 1;
            break
        end
    end
end 

clear iVarListw iVarList VarListw 