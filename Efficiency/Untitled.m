

len=10513;

sPHI=zeros(len,1);
sPHIH=zeros(len,1);
sTHETA=zeros(len,1);
sTHETAH=zeros(len,1);
sSpeed=zeros(len,1);
ww=100;
for i=2:1:10513-ww+1
    sPHI(i-1,1)=sum(PHI(i:i+ww-1))/ww;
    sPHIH(i-1,1)=sum(PHIH(i:i+ww-1))/ww;
    sTHETA(i-1,1)=sum(THETA(i:i+ww-1))/ww;
    sTHETAH(i-1,1)=sum(THETAH(i:i+ww-1))/ww;
    sSpeed(i-1,1)=sum(Speed(i:i+ww-1))/ww;
end
dPHI=zeros(len,1);
dPHIH=zeros(len,1);
dTHETA=zeros(len,1);
dTHETAH=zeros(len,1);
dSpeed=zeros(len,1);
for i=2:1:10513-ww+1
    dPHI(i-1,1)=abs(PHI(i+1)-PHI(i));
    dPHIH(i-1,1)=abs(PHIH(i+1)-PHIH(i));
    dTHETA(i-1,1)=abs(THETA(i+1)-THETA(i));
    dTHETAH(i-1,1)=abs(THETAH(i+1)-THETAH(i));
    dSpeed(i-1,1)=abs(Speed(i+1)-Speed(i));
end