%TempTestFFT.m
tN=160; %s
tf=1/10+0e-2; %hz
tFs=1;
t = 0:1/tFs:tN;
t=t(1:end-1);
%length(t)

k=1:tN;
ph=0;

xn=cos(2*pi*t*tf+ph*pi/2);
for ik=1:length(k)
    for in=1:tN
        sumvals(ik,in)=xn(in)*exp(-j*2*pi*(ik-1)*((in-1)/tN));
    end
end
Xk=sum(sumvals,2);

MagX=abs(Xk(1:round(length(Xk)/2)));
[maxx,maxind]=max(MagX);

abs(Xk(max(maxind-4,1):min(maxind+4,length(Xk))))
angle(Xk(max(maxind-4,1):min(maxind+4,length(Xk))))*180/pi

figure
plot(xn)

