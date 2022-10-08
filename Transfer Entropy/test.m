a = load("5Bins1k1lHeadEye.mat").Data;
b = sum(sum(a(:,7,:)));
d = sum(sum(a(:,1,:)));
c = sum(a(:,7,:));

e = a(:,7,:) - a(:,3,:);


acg =  load("AvgAcc.mat").ans; 
x_size =  size(acg,1);
y_size =  size(acg,2);

% f = reshape(e,1,x_size*y_size) ;
% nucm = reshape(f,y_size,x_size).';
nucm = reshape(e,y_size,x_size).';
dic = containers.Map(nucm,acg) ;
% for i = 1:x_size
%     for j = 1:y_size
%         
%     end
% end
figure(1);

plot(cell2mat(keys(dic)));
hold on;
n = cell2mat(values(dic));
plot(1./n);
hold off;
legend('nucm','1/acc');
