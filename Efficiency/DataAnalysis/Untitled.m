TG=4;     %��������ʱ��
NG=80;      %����ÿ����������
LengthG=26.6;       %�������᳤��
HeightG=2.8;        %��������߶�
WidthG=3.3;         %����������
VG=LengthG*HeightG*WidthG;      %�����������
TW=16;      %���̳���ʱ��
NW=66;
LengthW=25.5;
HeightW=3.4;
WidthW=3.3;
VW=LengthW*HeightW*WidthW;      %�������
k=zeros(1,10);
for i=1:10
    c=10^(-i+1);      %��Ⱦ����ϵ��
    k(i)=(1-(1-(c*NW/VW))^TW)/(1-(1-(c*NG/VG))^TG);    %���̸�Ⱦ����/������Ⱦ����
    
end
hold on
plot(k)
% p=zeros(1,50);
% c=10^(-8);
% for i=1:50
%     p(i)=(1-(1-(c*NW/VW))^i)/(1-(1-(c*NG/VG)));
% end
% plot(p)
