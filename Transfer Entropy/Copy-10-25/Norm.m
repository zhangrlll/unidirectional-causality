%% Source Data Normalisation
function [r] = Norm(in,len)
% r=zeros(1,1);
m=90;%mean(in);
for i=1:len
    if in(i,:)<0
        in(i,:)=0;
    end
    if in(i,:)>180
        in(i,:)=180;
    end
    r(i,:)=(in(i,:)-m);
end