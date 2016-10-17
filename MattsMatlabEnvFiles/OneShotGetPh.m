function ph = OneShotGetPh(sig,f,Fs)
%function ph = OneShotGetPh(sig,f,Fs)
%
% Gives the phase (in degrees) for a given signal at gievn frequency by
% correlating it with a sine and a cosine wave at the same frequency, and
% comparing the relative contributions of each.
%
% Inputs:
%   sig:        The signal. At this point assumed to be any 1 dimensional
%               vector.
%   f:          The frequency at which to measure the input (units of Hz). 
%               Defaults to the frequency such that one period comprises 
%               the entire length of the signal.
%   Fs:         Sampling rate (units of Hz). Defaults to 1000.
%        
%   Outputs:
%   ph:         The phase of the signal at the given frequency, in degrees.
%
% Theory behind this- we take the 2D projection of the signal in the complex plane.
% The x-axis is the correlation with a cosine. The y-axis is NOT the
% correlation with a sine, but rather the correlation of a cosine advanced
% 90 degrees- this could be a NEGATIVE sine or just cos with a +90 degree
% phase shift. Because a sine wave is a cosine shifted BACK by 90 degrees, 
% taking this naive correlation gives teh negative phase angle.   

np = length(sig);
if nargin<3 || isempty(Fs);        Fs=1000;        end
if nargin<2 || isempty(f);      
    FreqPer=np/Fs;      %units of seconds
else
    FreqPer=1/f;    %units of seconds
end

t=0: 1/Fs: (np-1)/Fs;  %in seconds

%%%%Either one of eth lines below for csin work- explanation for theory of this above     
%csin = -sin( 2 * pi * t / FreqPer );   
csin = cos( 2 * pi * t / FreqPer + pi/2);   
ccos = cos( 2 * pi * t / FreqPer );

ph = 180/pi * atan2(sum(sig .* csin),  sum(sig .* ccos));

%%%Debug options
% figure
% plot(sig)
% open atan2
% hold on
% plot(csin,'r')
% plot(ccos,'g')
% disp(['ccos: ' num2str( sum(sig .* ccos) ) '    csin: ' num2str( sum(sig .* csin) )])

