function y=my_downsample(x,N)
% function y=my_downsample(x,N)
%
% this is a quick and dirty way of doing downsampling when you don't have
% access to matlab's signal processing toolbox.
% MJN 130424

y = x(1:N:end);

