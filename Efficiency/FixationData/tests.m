sp=0.1;
sq=0.1;

J=zeros(100,100);
i=1;j=1;
for p=0.01:0.01:1-sp
    for q=0.01:0.01:1-sq
        J(i,j)=JSD(p,q)-(JSD(sp+p,sq+q)-JSD(sp,sq));
        j=j+1;
    end
    j=1;
    i=i+1;
end
bar3(J);