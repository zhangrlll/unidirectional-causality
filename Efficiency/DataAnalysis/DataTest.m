%% Initiate ; illustration of data
% load('StdDist.mat')
% load('StdAngle.mat')
% load('Angle.mat')
load('Day.mat')
load('DuskOff.mat')
load('DuskOn.mat')
load('Night.mat')
load('MPS - std.mat')
% MM=MPS;
% load('MPS - mean.mat')

% Day(:,2)=Day(:,2).^0.5;
% DuskOn(:,2)=DuskOn(:,2).^0.5;
% DuskOff(:,2)=DuskOff(:,2).^0.5;
% Night(:,2)=Night(:,2).^0.5;

% Day(:,3)=Day(:,2)./Day(:,1);
% DuskOn(:,3)=DuskOn(:,2)./DuskOn(:,1);
% DuskOff(:,3)=DuskOff(:,2)./DuskOff(:,1);
% Night(:,3)=Night(:,2)./Night(:,1);
% 
% Day(:,1)=log(Day(:,2))./log(Day(:,3));
% DuskOn(:,1)=log(DuskOn(:,2))./log(DuskOn(:,3));
% DuskOff(:,1)=log(DuskOff(:,2))./log(DuskOff(:,3));
% Night(:,1)=log(Night(:,2))./log(Night(:,3));

% Day(:,1)=log(Day(:,2)./Day(:,3));
% DuskOn(:,1)=log(DuskOn(:,2)./DuskOn(:,3));
% DuskOff(:,1)=log(DuskOff(:,2)./DuskOff(:,3));
% Night(:,1)=log(Night(:,2)./Night(:,3));

% MPS=log(MPS);
Day(:,10)=MPS(:,1);
DuskOn(:,10)=MPS(:,2);
DuskOff(:,10)=MPS(:,3);
Night(:,10)=MPS(:,4);

% Day(:,10)=log(Day(:,10));
% DuskOn(:,10)=log(DuskOn(:,10));
% DuskOff(:,10)=log(DuskOff(:,10));
% Night(:,10)=log(Night(:,10));

DataMM(:,:,1)=Day;DataMM(:,:,2)=DuskOn;DataMM(:,:,3)=DuskOff;DataMM(:,:,4)=Night;
% Day(:,16)=Angle(:,1);
% DuskOn(:,16)=Angle(:,2);
% DuskOff(:,16)=Angle(:,3);
% Night(:,16)=Angle(:,4);
% Day(:,17)=StdDist(:,1);
% DuskOn(:,17)=StdDist(:,2);
% DuskOff(:,17)=StdDist(:,3);
% Night(:,17)=StdDist(:,4);


PartEf=2;
DrivingEf=9;

% hold on
% scatter(mean(Day(:,PartEf)),mean(Day(:,DrivingEf)))
% scatter(mean(DuskOn(:,PartEf)),mean(DuskOn(:,DrivingEf)))
% scatter(mean(Night(:,PartEf)),mean(Night(:,DrivingEf)))
% scatter(mean(DuskOff(:,PartEf)),mean(DuskOff(:,DrivingEf)))
hold on
xlabel('Efficiency of eye movement');
ylabel('Driving performance');
scatter([Day(:,PartEf);DuskOn(:,PartEf);DuskOff(:,PartEf);Night(:,PartEf)],[Day(:,DrivingEf);DuskOn(:,DrivingEf);DuskOff(:,DrivingEf);Night(:,DrivingEf)],'b')
% scatter(Day(:,PartEf),Day(:,DrivingEf))
% scatter(DuskOn(:,PartEf),DuskOn(:,DrivingEf))
% scatter(Night(:,PartEf),Night(:,DrivingEf))
% scatter(DuskOff(:,PartEf),DuskOff(:,DrivingEf))

x1=[Day(:,PartEf);DuskOn(:,PartEf);DuskOff(:,PartEf);Night(:,PartEf)];
% x2=[Day(:,11);DuskOn(:,11);DuskOff(:,11);Night(:,11)];
y=[Day(:,DrivingEf);DuskOn(:,DrivingEf);DuskOff(:,DrivingEf);Night(:,DrivingEf)];
X = [ones(size(y)) x1];
[b,bint,r,rint,stats] = regress(y,X);
text(0.05,0.8,['y = ',num2str(b(1),4),' + ',num2str(b(2),4),'x',', ( F = ',num2str(stats(2),4),', \eta^2 = ',num2str(stats(1),2),', p < 0.05 )'],'FontSize',20);

p = polyfit([Day(:,PartEf);DuskOn(:,PartEf);DuskOff(:,PartEf);Night(:,PartEf)], [Day(:,DrivingEf);DuskOn(:,DrivingEf);DuskOff(:,DrivingEf);Night(:,DrivingEf)], 1);
plot([Day(:,PartEf);DuskOn(:,PartEf);DuskOff(:,PartEf);Night(:,PartEf)], polyval(p, [Day(:,PartEf);DuskOn(:,PartEf);DuskOff(:,PartEf);Night(:,PartEf)]),'k','LineWidth',2) 

% yy=1;
% hold on
% boxplot([Day(:,yy),DuskOn(:,yy),Night(:,yy),DuskOff(:,yy)])
% Day with lamp off
% Dusk with lamp on
% Night with lamp on
% Dusk with lamp off



%% Plotting

Correl=zeros(6,4);
[p1,pp1]=corr(Day(:,PartEf),Day(:,DrivingEf),'type','Pearson');[p2,pp2]=corr(DuskOn(:,PartEf),DuskOn(:,DrivingEf),'type','Pearson');[p3,pp3]=corr(Night(:,PartEf),Night(:,DrivingEf),'type','Pearson');[p4,pp4]=corr(DuskOff(:,PartEf),DuskOff(:,DrivingEf),'type','Pearson');
[k1,kp1]=corr(Day(:,PartEf),Day(:,DrivingEf),'type','Kendall');[k2,kp2]=corr(DuskOn(:,PartEf),DuskOn(:,DrivingEf),'type','Kendall');[k3,kp3]=corr(Night(:,PartEf),Night(:,DrivingEf),'type','Kendall');[k4,kp4]=corr(DuskOff(:,PartEf),DuskOff(:,DrivingEf),'type','Kendall');
[s1,sp1]=corr(Day(:,PartEf),Day(:,DrivingEf),'type','Spearman');[s2,sp2]=corr(DuskOn(:,PartEf),DuskOn(:,DrivingEf),'type','Spearman');[s3,sp3]=corr(Night(:,PartEf),Night(:,DrivingEf),'type','Spearman');[s4,sp4]=corr(DuskOff(:,PartEf),DuskOff(:,DrivingEf),'type','Spearman');
Correl(1,:)=[p1,p2,p3,p4];Correl(3,:)=[k1,k2,k3,k4];Correl(5,:)=[s1,s2,s3,s4];
Correl(2,:)=[pp1,pp2,pp3,pp4];Correl(4,:)=[kp1,kp2,kp3,kp4];Correl(6,:)=[sp1,sp2,sp3,sp4];

cor=zeros(9,6);j=1;
for i=[1:9]
    PartEf=i;
    [plcc,pp]=corr([Day(:,PartEf);DuskOn(:,PartEf);DuskOff(:,PartEf);Night(:,PartEf)],[Day(:,DrivingEf);DuskOn(:,DrivingEf);DuskOff(:,DrivingEf);Night(:,DrivingEf)],'type','Pearson');
    [krocc,pk]=corr([Day(:,PartEf);DuskOn(:,PartEf);DuskOff(:,PartEf);Night(:,PartEf)],[Day(:,DrivingEf);DuskOn(:,DrivingEf);DuskOff(:,DrivingEf);Night(:,DrivingEf)],'type','Kendall');
    [srocc,ps]=corr([Day(:,PartEf);DuskOn(:,PartEf);DuskOff(:,PartEf);Night(:,PartEf)],[Day(:,DrivingEf);DuskOn(:,DrivingEf);DuskOff(:,DrivingEf);Night(:,DrivingEf)],'type','Spearman');
    cor(j,:)=[plcc,pp,krocc,pk,srocc,ps];j=j+1;
end
xind=1;
yind=2;
% per=zeros(4,13);
per=zeros(4,14);
eE=zeros(1,1);kkk=1;
for i=1:4
%     for j=1:13
    for j=1:14
        per(i,j)=DataMM(j,xind,i);
%         eE(kkk)=DataM(j,yind,i);
        eE(kkk)=MPS(j,i);
        kkk=kkk+1;
    end
end
per=[per(1,:)';per(2,:)';per(3,:)';per(4,:)'];
[EE,ESort]=sort(per(:));
% for i=1:14
% per(5,i)=mean(DataM(i,9,:));
% per(6,i)=mean(DataM(i,1,:));
% per(7,i)=mean(MPS(i,:));
% per(8,i)=mean(DataM(i,2,:));
% end
% [ee,eord]=sort(per(6,:));
% % NE1= [2 4 5 7 12 13 14];
% % NE2=[1 3 6 8 9 10 11];
% aind=7;
an1=eE([ESort(29:56)]);
an2=eE([ESort(1:28)]);
% thres=mean(per(:));
% an1=eE([per>=thres]);
% an2=eE([per<thres]);
% hold on
% anova1([an1',an2']);
% % boxplot([per(:,1),per(:,2),per(:,3),per(:,4),per(:,5),per(:,6),per(:,7),per(:,8),per(:,9),per(:,10),per(:,11),per(:,12),per(:,13),per(:,14)]);
