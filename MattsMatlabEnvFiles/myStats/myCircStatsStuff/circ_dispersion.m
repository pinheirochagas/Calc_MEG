function out=circ_dispersion(alpha,dim)
%function out=circ_dispersion(alpha)
%Note that this is NOT the circ_std ...

if nargin<2 || isempty(dim);        dim=1;      end

n = sum(~isnan(alpha),dim);
len=size(alpha,dim);

mu=circ_mean(alpha,[],dim);

%on 120117 I checked, and changing the circular 'range' (i.e. adding any
%multiples of 360 degrees of the inputs AND/OR the difference from the mean
%value did NOT affect this at all...
rs=ones(1,ndims(alpha));
rs(dim)=len;

rho2=(1./n).*nansum( cos( 2*(alpha- repmat(mu,rs)) ),dim );
out=(1-rho2)./(2* (circ_r(alpha)).^2 );

