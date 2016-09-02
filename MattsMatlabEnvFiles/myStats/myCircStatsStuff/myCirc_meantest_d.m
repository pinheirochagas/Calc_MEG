function pout=myCirc_meantest_d(alpha, TestMean)
% function pout=myCirc_meantest(alpha, TestMean)
%Note- this assumes the inputs in alpha are in units of DEGREES...
%
% the p-values here seem to be perhaps a bit more agressive than what's
% suggetsed by circ_confmean in Berens's circ stats toolbox, but are 
% generally in line with it...

alpha=alpha*pi/180;

if nargin<2 || isempty(TestMean);       TestMean=0;      end

if size(alpha,2) > size(alpha,1)
	alpha = alpha';
end

n = length(alpha);

stde=sqrt( circ_dispersion(alpha) ./ n );
sampmn=circ_mean(alpha);

% compute deviation (in units of std errors) from samp mean and TestMean  
d = circ_dist(sampmn, TestMean) ./ stde;
pout=2*normcdf( -abs(d),0,1 );   %here we assume a two sided test, but this can be easily changed to one-sided by just halving the p-val I believe   
%note- with the wrapping of distributions with VERY large spreads, I'm not sure if this p-value is interpretable as such, I've only ever seen it written to be used as a confidenc interval... BUT, keeping that in mind, I think this p-val is still useful to intepret, and it would only be a problem where teh spread si too large for the data to be likely to be significant anyway...      

if d<0
    pout=-pout;
end