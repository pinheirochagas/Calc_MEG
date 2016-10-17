function [rho pval] = myCirc_corrcl_d(alpha, x)
% function [rho pval] = myCirc_corrcl_d(alpha, x)
% THIS WORKS WITH THE INPUT ANGLE IN UNTS OF DEGREES
%
% According to the circular statistics book by N. I. Fisher, a
% circular-linear corrrelation (which attempts to determine 
% E(Theta | X = x) can be done by making the linear variable by taking
% 2*atan of it, and then doing
%
% Note that the circular linear correlation offered by P Berens in the
% circStats toolbox does the reverse correlation, and attempts to determine
% E(X | Theta = theta). According to N.I. Fisher, these two are very
% different.
%
% But this code uses Berens code for the circ-circ correlation, which 
% based on what I saw was the same as what was in my Fisher circ stats 
% book for this.

alpha=alpha*pi/180;

x=2*atan(x);

[rho pval] = circ_corrcc(alpha, x);