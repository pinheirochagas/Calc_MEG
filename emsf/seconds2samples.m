function samples = seconds2samples(seconds,t0,SR)
%
% function samples = seconds2samples(seconds,t0,SR)
%
% Converts seconds to samples.
%

samples = round((seconds + t0) * SR);