function [r,p,rlo,rup] = nancorrcoef(x,varargin)
%function [r,p,rlo,rup] = nancorrcoef(x,varargin);
%.... it turns out this functino is not really necessary, see the options
%for 'rows' in the help scetion for matlab's corrcoeff

if isempty(varargin)        [r,p,rlo,rup] = corrcoef(x( ~isnan(x) ));    else        [r,p,rlo,rup] = corrcoef(x( ~isnan(x) ),varargin);   end