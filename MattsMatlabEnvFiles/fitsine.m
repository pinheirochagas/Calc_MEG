function yhat = fitsine(params,X)
%
% Begun on 060928 by Matt Nelson to test nlinfit for least-squares fit of a
% sine wave. Params(1) is amplitude, params(2) is angular frequency, in
% radians per sample, params(3) is the phase, and params(4) is the DC value
% offset, typically just the mean of the data sample. X is an array of the
% independent variable values, i.e. the time stamps, or you can just make 
% it a vector fo 1 through the number of samples

yhat=params(1)*sin(params(2)*X+params(3))+params(4);