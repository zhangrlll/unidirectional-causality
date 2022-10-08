%% Information varing cal
lenv=size(FixationHitName,1);
VdirP=zeros(lenv,1);
VdirPSum=zeros(lenv,1);
Vdir=zeros(lenv,1);
VdirSum=zeros(lenv,1);
Vsum=zeros(lenv,1);
for i=1:lenv
    VdirP(i)=Average_CarSpeed_In_This_Fixation(i)*abs(cosd(Phi(i))*sind(Theta(i)))/(r(i)^2)*duration(i);
    Vdir(i)=Average_CarSpeed_In_This_Fixation(i)*sqrt(1-(cosd(Phi(i))*sind(Theta(i)))^2)/(r(i))*duration(i);
    if i>1
        VdirPSum(i)=VdirPSum(i-1)+VdirP(i);
        VdirSum(i)=VdirSum(i-1)+Vdir(i);
        Vsum(i)=Vsum(i-1)+VdirP(i)+Vdir(i);
    end
end