function [D_out,I]=shuffle(D_in,nShufflings)
%
% function [D_out,I]=shuffle(D_in,[nShufflings])
%
% D_out is assumed to be a column vector (for now).
%
if nargin<2
    nShufflings = 1;
end
    D_out = zeros(length(D_in),nShufflings);
    R = rand(length(D_in),nShufflings);
    [~,I] = sort(R,1);
    for i=1:nShufflings
        D_out(:,i) = D_in(I(:,i));
    end

return