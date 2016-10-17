% This is a script to generate mixed model ARMA polynomials and then simulated time series
% At the top of the script you can set NP=no. poles (same as no. zeros of \phi)
% NZ=no. zeros (of \theta), NPP=no. seasonal poles (zeros of \Phi) and NZZ=no. seasonal zeros
% of \Theta. Then you will use the mouse to move the cursor
% to where you want the poles to be. This program assumes that if the polynomial is
% of even order all poles (or zeros) will occur in complex conjugate pairs. If NP or
% NZ are odd, it assumes the even part will occur in conjugate pairs. If you choose
% NP=1 and NZ=0, the pole must be on the real axis so it will place the pole at the
% x component of thepoint you select. If you set NP=2 and NZ=1, you will first be 
% asked to input the pole locations. This requires you to select only one point for
% two poles because the other one is set to be the complex conjugate of the one you chose.
% Next you will be asked to input a zero and since the order is  one, it again takes the 
% real part. If you set NP=3, for example, you first will be asked to place the single
% pole on the real axis. 
%
% You first inout all the poles and zeros for the inter season dynamics and then
% all the poles and zeros for the intra season (period) dynamics

% NOTE !!!! only use NPP=0 or 1, same for NZZ 

NP=1;		% no. poles (zeros of phi) inter season dynamics
NZ=0;		% no. zeros (zeros of theta)
T=12;       % period in samples
NPP=1;		% no. poles (zeros of Phi)  intra season (period) dynamics
NZZ=0;		% no. zeros (zeros of Theta) 
NSAMP=500;  % no. samples to generate
LAM0=pi/6;  % so you can see where 30 deg is
clear phi theta Phi Theta thetaM phiM;

disp(['Simulation of multiplicative (',int2str(NP),',',int2str(NZ),') X  (',...
        int2str(NPP),',',int2str(NZZ),') model']);
 
[phi,theta]=pickpoly(NP,NZ,LAM0,0); % get the inter season dynamics
                                    % now in these polys the constant term is 1st

phi=phi/phi(1); % normalize to make first coeff 1
theta=theta/theta(1);

[Phi,Theta]=pickpoly(NPP,NZZ,LAM0,1); % get the intra season (period) dynamics
                                    % now in these polys the constant term is 1st

Phi=Phi/Phi(1); % normalize to make first coeff 1
Theta=Theta/Theta(1);
% these must be translated to coefficients of z^T
ThetaT=zeros(1,1+(length(Theta)-1)*T);
indexes=[1:T:length(ThetaT)];
ThetaT(indexes)=Theta;
for j=1:length(ThetaT)
   ThetaT(j)=sign(ThetaT(j))*(abs(ThetaT(j)))^(j-1); % scale constants to keep same radii
end

PhiT=zeros(1,1+(length(Phi)-1)*T);
indexes=[1:T:length(PhiT)];
PhiT(indexes)=Phi;
for j=1:length(PhiT)
   PhiT(j)=sign(PhiT(j))*(abs(PhiT(j)))^(j-1); % scale constants to keep same radii
end

% now build the product polynomials
thetaM=conv(theta,ThetaT);
phiM=conv(phi,PhiT);
disp(sprintf('phiM non zero coefficients'));
nzi=find(phiM);disp(sprintf('power of B: %2d  coeff: %6.3f \n',[(nzi-1)' phiM(nzi)']'));
disp(sprintf('thetaM non zero coefficients'));
nzi=find(thetaM);disp(sprintf('power of B: %2d  coeff: %6.3f \n',[(nzi-1)' thetaM(nzi)']'));
%%%%%%%%%%%%%%%%%%%%%%
% now plot the multiplicative poles and zeros
figure;
lam=[0:2*pi/100:2*pi];
ct=cos(lam);
st=sin(lam);
plot(ct,st,'-');hold on;
plot([0 cos(LAM0)],[0 sin(LAM0)],':r');
plot([0 0],[-1.5 1.5],':',[-1.5 1.5],[0 0],':');
axis('square');
hold on;
if length(phiM) > 1
    plot(roots(fliplr(phiM)),'x');   % have to flip them as matlab assumes highest power fitst
end
%   now do the zeros
if length(thetaM) > 1
    plot(roots(fliplr(thetaM)),'o');
end
title(['poles and zeros for multiplicative (',int2str(NP),',',int2str(NZ),') X  (',...
        int2str(NPP),',',int2str(NZZ),') model']);
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%% plot the 1st NSAMP values of the impulse response
figure;
x=zeros(1,NSAMP);
x(1)=1;				% make an impulse
y=filter(thetaM,phiM,x); % filter(B,A,X) is AY=BX so A is AR and B is MA
subplot(211);
plot(y);
v=axis;
title(['impulse response for (',int2str(NP),',',int2str(NZ),') \times (',...
        int2str(NPP),',',int2str(NZZ),') model']);
text(v(1)+.2*(v(2)-v(1)),v(3)+.8*(v(4)-v(3)),'polynomials are printed in the command window');
%%%%%%%%%% plot the NSAMP values of an ARMA sequence
subplot(212);
n=1024;
x=randn(n,1);
y=filter(thetaM,phiM,x); % filter(B,A,X) is AY=BX so A is AR and B is MA
out=y(512:512+NSAMP-1);
plot(y(512:512+NSAMP-1));
title([int2str(NSAMP),' samples of (',int2str(NP),',',int2str(NZ),')\times (',...
        int2str(NPP),',',int2str(NZZ),') simulation']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  plot |W(\lambda)|^2
NLAM=200;	% no. pts to plot in  [0,2\pi]
dlam=2*pi/NLAM;
lams=[0:dlam:2*pi-dlam];
e=exp(-i*lams);

thetaspec=polyval(thetaM,e);    % here we should flip the polys first for matlab
phispec=polyval(phiM,e);        % but when evaluating on e and taking | |, the result is identical

W=thetaspec./phispec;

%%%%%%%%%%%%%%  first using linear scale
figure;
plot(lams,abs(W).^2);
xlabel(' 0 \leq \lambda < 2\pi');
v=axis;
text(v(1)+.2*(v(2)-v(1)),v(3)+.8*(v(4)-v(3)),'polynomials are printed in the command window');
title(['spectral density - linear scale for (',int2str(NP),',',int2str(NZ),') \times (',...
        int2str(NPP),',',int2str(NZZ),') model']);

%%%%%%%%%%%%%%  next using log scale
figure;
semilogy(lams,abs(W).^2);
xlabel(' 0 \leq \lambda < 2\pi');
v=axis;
text(v(1)+.2*(v(2)-v(1)),v(3)+.8*(v(4)-v(3)),'polynomials are printed in the command window');
title(['spectral density - log scale for (',int2str(NP),',',int2str(NZ),') \times (',...
        int2str(NPP),',',int2str(NZZ),') model']);

%%%%%%%%%%%%%%  finally do spectral DF
figure;
plot(lams,cumsum(abs(W).^2));	% cumsum is like an integral;
xlabel(' 0 \leq \lambda < 2\pi');
v=axis;
text(v(1)+.2*(v(2)-v(1)),v(3)+.8*(v(4)-v(3)),'polynomials are printed in the command window');
title(['spectral CDF - linear scale for (',int2str(NP),',',int2str(NZ),') \times (',...
        int2str(NPP),',',int2str(NZZ),') model']);
