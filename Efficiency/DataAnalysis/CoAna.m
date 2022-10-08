% load('CoData.mat', 'Data')
load('New.mat', 'New');
Data=New;
y=1;
AnaSet=[1 13 14 15 16 17 18];
s=['o','*','x'];
% JSD/, JSD, KLD/, KLD, Jeff/


xn=1;
correlation=zeros(7,10);
% p=zeros(5,10);
k=1;
for x=AnaSet
    for i=1:10
        correlation(k,i)=Data(x,xn,i);
%         p(k,i)=Data(x,xn+1,i);
    end
    k=k+1;
end


hold on
title('Pearson Correlation Coefficient')
xlabel('Percentage number of fixations (%)');
ylabel('Correlation coefficient');
% for i=1:5
    plot([10:10:100],correlation(1,:),'-ko','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[1 1 1],'MarkerSize',8);
    plot([10:10:100],correlation(2,:),'--k*','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(3,:),'-.k+','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(4,:),':kx','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(5,:),'-.ks','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(6,:),'--kd','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(7,:),':kp','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    legend('Effeciency','GTE','SGE','Saccade amplitude','Entropy rate','Fixation rate','EoFT','Location','NorthWest');
    
    plot([10],correlation(1,1),'-ko','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor',[1 1 1],'MarkerSize',8);
    plot([10:10:100],correlation(2,:),'--k*','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(3,:),'-.k+','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(4,:),':kx','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(5,:),'-.ks','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(6,:),'--kd','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor',[1 1 1],'MarkerSize',8)
    plot([10:10:100],correlation(7,:),':kp','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor',[1 1 1],'MarkerSize',8)
% end
% scatter(0.1,correlation(1,1),'o','r');
% scatter(0.1,correlation(3,1),'*','r');
% scatter(0.1,correlation(5,1),'x','r');
% scatter(0.2:0.1:1,correlation(1,2:10),'o','b');
% scatter(0.2:0.1:1,correlation(3,2:10),'*','b');
% scatter(0.2:0.1:1,correlation(5,2:10),'x','b');

    
    
    
% end
% Data(:,:,)=[]