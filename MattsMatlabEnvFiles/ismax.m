function out = ismax(in,dim)
%%% this code was not completed


% function out = ismax(in,dim)
% 
% Returns array out the same size as in, with out set to 1 whereever A is
% maximal along dimension dim, and 0 everywhere else

out =zeros(size(in));
[~,inds]=max(in,[],dim);

% matlab;s indexing is fucking annoying here for this...
out( inds )=1;
