function [Aout,Bout]=swap(Ain,Bin)
%function [Aout,Bout]=swap(Ain,Bin)
%
% Meant to swap the inputs Ain Bin. entire code:
% Aout=Bin;       Bout=Ain;

Aout=Bin;       Bout=Ain;

%note- a quicker way of doing this for items in an array is:
% for example to swap potitions 1 and 3 in vector A:
% A([1 3])=A([3 1]);