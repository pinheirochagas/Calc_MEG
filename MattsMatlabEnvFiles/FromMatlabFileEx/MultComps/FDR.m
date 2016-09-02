function [pID,pN] = FDR(p,q)
% FORMAT [pID,pN] = FDR(p,q)
% 
% p   - vector of p-values
% q   - False Discovery Rate level
%
% pID - p-value threshold based on independence or positive dependence
% pN  - Nonparametric p-value threshold
%______________________________________________________________________________
% $Id: FDR.m,v 1.1 2009/10/20 09:04:30 nichols Exp $
%
% NOTES by MJN: I got this from this U of Mich prof's personal website, and
% this does the exact same thing as fdr_bh which I got from the matlab file
% exchange...
%       .... though I do find fdr_bh to be a little more user friendly, so
%       i would recommend using that...
%       .... Further note that this is indeed the procedure outlined by
%       Maxwell and Delaney in their nice stats textbook- there they call
%       this the Linear Step Up procedure

p = p(fininte(p));  % Toss NaN's
p = sort(p(:));
V = length(p);
I = (1:V)';

cVID = 1;
cVN = sum(1./(1:V));

pID = p(find(p<=I/V*q/cVID, 1, 'last' ));
pN = p(find(p<=I/V*q/cVN, 1, 'last' ));


