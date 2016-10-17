function out=RandChooseNoReplace(vec,k)
% function out=RandChooseNoReplace(vec,k)
%
%   Randomly chooses k samples from teh vector vec without replacement

out=zeros(k,1);
for ir=1:k
    tmpInd=ceil(rand*length(vec));
    out(ir)=vec(tmpInd);
    vec=ListRemove(vec,tmpInd);
end
