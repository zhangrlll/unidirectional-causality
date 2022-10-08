TG=4;     %高铁乘坐时间
NG=80;      %高铁每个车厢人数
LengthG=26.6;       %高铁车厢长度
HeightG=2.8;        %高铁车厢高度
WidthG=3.3;         %高铁车厢宽度
VG=LengthG*HeightG*WidthG;      %高铁车厢体积
TW=16;      %卧铺乘坐时间
NW=66;
LengthW=25.5;
HeightW=3.4;
WidthW=3.3;
VW=LengthW*HeightW*WidthW;      %卧铺体积
k=zeros(1,10);
for i=1:10
    c=10^(-i+1);      %感染概率系数
    k(i)=(1-(1-(c*NW/VW))^TW)/(1-(1-(c*NG/VG))^TG);    %卧铺感染概率/高铁感染概率
    
end
hold on
plot(k)
% p=zeros(1,50);
% c=10^(-8);
% for i=1:50
%     p(i)=(1-(1-(c*NW/VW))^i)/(1-(1-(c*NG/VG)));
% end
% plot(p)
