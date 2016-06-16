function stderr = bootstrap_stderr_of_diff(data1,data2,nIters)
%
% function stderr = bootstrap_stderr_of_diff(data1,data2,nIters)
%
% Computes the bootstrap standard error of the difference between the mean
% over data1 and data2.
%

if nargin < 3
    nIters = 100;
end

sz1 = size(data1);
sz2 = size(data2);
if ~(sz1(2)==sz2(2))
    error('Data matrices must have the same number of columns.');
end
n1=sz1(1); n2=sz2(1);
nTP = sz1(2);

ind1=[1:n1];
ind2=[1:n2];

M1 = zeros(nIters,nTP);
M2 = zeros(nIters,nTP);

for i=1:nIters
    M1(i,:) = nanmean(data1(randint(n1,1,ind1),:));
    M2(i,:) = nanmean(data2(randint(n2,1,ind2),:));
end

D = M1-M2;
stderr = std(D,0,1);

return    