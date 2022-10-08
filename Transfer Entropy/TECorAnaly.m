%% TE correlation analysis
nans=ans;
% for i=1:14
% %     nans(i,:)=(ans(i,:)-min(ans(i,:)))./(max(ans(i,:))-min(ans(i,:)));
%     nans(i,:)=(ans(i,:))./(max(ans(i,:)));
% %     nans(i,:)=(ans(i,:)-mean(ans(i,:)))./std(ans(i,:));
% end
% nans(:)=(ans(:)-mean(ans(:)))./std(ans(:));

% nans=nans-min(nans(:));
% nans=eps+nans;
nans=1./nans;
% nans(2,4)=0.5;

NTEH2E=zeros(11,4);
TESH2E=zeros(11,4);
accn=14;
for i=1 :accn
%     NTEH2E(i,:)=(Data(:,5,i)./Data(:,6,i)-Data(:,1,i)./Data(:,2,i))./(Data(:,5,i)./Data(:,6,i)+Data(:,1,i)./Data(:,2,i));%./(Data(:,7,i))
    NTEH2E(i,:)=(Data(:,7,i)-Data(:,3,i));
%     NTEH2E(i,:)=(Data(:,5,i)-Data(:,1,i))./(Data(:,5,i)+Data(:,1,i));
%     NTEH2E(i,:)=(Data(:,5,i));
end
comp=[1:12];
[plcc,pp]=corr([NTEH2E(comp,1);NTEH2E(comp,2);NTEH2E(comp,3);NTEH2E(comp,4)],[nans(comp,1);nans(comp,2);nans(comp,3);nans(comp,4)],'type','Pearson');
[klcc,pk]=corr([NTEH2E(comp,1);NTEH2E(comp,2);NTEH2E(comp,3);NTEH2E(comp,4)],[nans(comp,1);nans(comp,2);nans(comp,3);nans(comp,4)],'type','kendall');
[slcc,ps]=corr([NTEH2E(comp,1);NTEH2E(comp,2);NTEH2E(comp,3);NTEH2E(comp,4)],[nans(comp,1);nans(comp,2);nans(comp,3);nans(comp,4)],'type','spearman');

% [plcc,pp]=corr([NTEH2E(comp,1);NTEH2E(comp,2);NTEH2E(comp,3);NTEH2E([1,3:14],4)],[nans(comp,1);nans(comp,2);nans(comp,3);nans([1,3:14],4)],'type','Pearson');
% [klcc,pk]=corr([NTEH2E(comp,1);NTEH2E(comp,2);NTEH2E(comp,3);NTEH2E([1,3:14],4)],[nans(comp,1);nans(comp,2);nans(comp,3);nans([1,3:14],4)],'type','kendall');
% [slcc,ps]=corr([NTEH2E(comp,1);NTEH2E(comp,2);NTEH2E(comp,3);NTEH2E([1,3:14],4)],[nans(comp,1);nans(comp,2);nans(comp,3);nans([1,3:14],4)],'type','spearman');
cor=[[plcc,pp];[klcc,pk];[slcc,ps]];

x1=[NTEH2E(comp,1);NTEH2E(comp,2);NTEH2E(comp,3);NTEH2E(comp,4)];
y=[nans(comp,1);nans(comp,2);nans(comp,3);nans(comp,4)];
% X = [ones(size(y)) x1.^(1) x1.^(-2) ];
% [b,bint,r,rint,stats] = regress(y,X);

hold on
scatter(x1,y)
P=polyfit(x1,y,1);
plot(x1,polyval(P,x1),'k','LineWidth',2);

%figure
%boxplot([TEH2E,TEE2H],'Notch','on','Labels',{'TE from Head Motion to Eye Movement','TE from Eye Movement to Head Motion'},'Whisker',4)