c=zeros(1,1);

p11=1;p12=0;
p21=0;p22=0;
P=[p11 p12;p21 p22];p=[p11+p21 p12+p22];

% hold on
% for a=1:min(p11,p12)*100
%     for b=1:min(p21,p22)*100
%         q11=p11+a/100;q12=p12-a/100;
%         q21=p21-b/100;q22=p22+b/100;
%         Q=[q11 q12;q21 q22];q=[q11+q21 q12+q22];
%         c(a,b)=JSD(p,q)/JSD(P,Q);
%     end
% end
% bar3(c);

hold on

for a=1:100
    for b=1:100
        p1=b/100;p2=1-p1;
    q1=a/100;
    q2=1-q1;
    c(a,b)=JSD(p1+p2,q1+q2)/JSD([p1;p2],[q1;q2]);
    end
end
bar3(c);