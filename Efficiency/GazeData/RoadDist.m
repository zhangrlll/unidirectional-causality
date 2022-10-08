%% Initialization
% CameraPosX(1,:)=[];CameraPosZ(1,:)=[];
% CoX=CameraPosX;CoZ=CameraPosZ;

%% Distance Computing
%   CoX(GazeNo)
%   CoZ(GazeNo)
% scenes=cell(4,1);scenes(1,1)='GDay';scenes(2,1)='GNight';scenes(3,1)='GDuskOn';scenes(4,1)='GDuskOff';
scenes={'GDay';'GDuskOn';'GDuskOff';'GNight'};
M=zeros(14,4);
Sd=zeros(14,4);
Angle=zeros(14,4);
SdAngle=zeros(14,4);
MPS=zeros(14,4);
DA=zeros(14,4);
A=zeros(14,4);
flag=0;
for PartNo=1:14
    for SceneNo=1:4
        sceneName=scenes{SceneNo};
        fname=[num2str(PartNo),sceneName,'.csv'];
        gsize=csvread(fname,1,36);
        GazeLen=size(gsize,1);
        PSize=xlsread(fname,['D2:D',num2str(GazeLen)]);
%         CoX=csvread(fname,1,9,[1 9 GazeLen 9]);
%         CoZ=csvread(fname,1,11,[1 11 GazeLen 11]);
%         DirX=csvread(fname,1,12,[1 12 GazeLen 12]);
%         DirZ=csvread(fname,1,14,[1 14 GazeLen 14]);
        PupilSizeMean=mean(PSize);
        PupilSizeMeanStd=std(PSize);
        PSChange=zeros(GazeLen-2,1);
%         for i=1:GazeLen-2
%             PSChange(i)=abs(PSize(i+1)-PSize(i));
%         end
%         MPS(PartNo,SceneNo)=mean(PSChange);
%         mpsize=mean(PSize(1:10));
%         for i=1:GazeLen-1
%             PSChange(i)=abs(PSize(i)-mpsize);
%         end
        MPS(PartNo,SceneNo)=abs(mean(PSize)-mpsize);
%         An=zeros(1,GazeLen);
%         for i=1:GazeLen
%             if (DirZ(i)>=0 && DirX(i)>0)
%                 An(i)=atand(DirZ(i)/DirX(i));
%                 continue;
%             end
%             if (DirZ(i)>=0 && DirX(i)<0)
%                 An(i)=360+atand(DirZ(i)/DirX(i));
%                 continue;
%             end
%             if (DirZ(i)<0 && DirX(i)<0)
%                 An(i)=180+atand(DirZ(i)/DirX(i));
%                 continue;
%             end
%             if (DirZ(i)<0 && DirX(i)>0)
%                 An(i)=90-atand(DirZ(i)/DirX(i));
%                 continue;
%             end
%             if  (DirX(i)==0 && DirZ(i)<0)
%                 An(i)=270;
%             end
%             if  (DirX(i)==0 && DirZ(i)>=0)
%                 An(i)=90;
%             end
%         end
%         
%         AnD=zeros(GazeLen,1);cnt=0;
%         for i=1:GazeLen
%             AnD(i)=min(min(abs(An(i)-0),abs(An(i)-90)),min(min(abs(An(i)-180),abs(An(i)-270)),abs(An(i)-360)));
%             if AnD(i)>10
%                 cnt=cnt+1;
% %                 AnD(i)=AnD(i-1);
%             end
%         end
%         Angle(PartNo,SceneNo)=cnt/GazeLen;
%         SdAngle(PartNo,SceneNo)=std(AnD);
% %         Time=csvread(fname,1,0,[1 0 GazeLen 0]);
% %         Speed=csvread(fname,1,27,[1 27 GazeLen 27]);
% %         DSpeed=0;DScnt=0;ASpeed=0;
% %         for i=1:GazeLen-1
% %             if (Speed(i+1)-Speed(i))<0
% %                 DSpeed=DSpeed+abs(Speed(i+1)-Speed(i))/(Time(i+1)-Time(i));
% %                 DScnt=DScnt+1;
% %             end
% %             ASpeed=ASpeed+abs(Speed(i+1)-Speed(i));
% %         end
% %         DA(PartNo,SceneNo)=DSpeed/DScnt;
% %         A(PartNo,SceneNo)=ASpeed/(GazeLen-1);
%         Dist=zeros(GazeLen,1);
%         for GazeNo=1:1:GazeLen
%             if ( -500.6 < CoX(GazeNo) && CoX(GazeNo) < -216.6 && 360.2 < CoZ(GazeNo) && CoZ(GazeNo) < 379.2 )
%                 Dist(GazeNo)=abs(CoZ(GazeNo)-(379.2+360.2)/2);
%                 continue;
%             end
%             if ( -216.6 < CoX(GazeNo) && CoX(GazeNo) < -180.6 && 344.2 < CoZ(GazeNo) && CoZ(GazeNo) < 379.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)-344.2)^2+(CoX(GazeNo)+216.6)^2)^0.5-0.25*(abs(379.2-344.2)+abs(-180.6+216.6)));
%                 continue;
%             end
%             
%             if ( -199.6 < CoX(GazeNo) && CoX(GazeNo) < -180.6 && 304.2 < CoZ(GazeNo) && CoZ(GazeNo) < 344.2 && flag==1)
%                 Dist(GazeNo)=abs(CoX(GazeNo)-(-199.6-180.6)/2);
%                 continue;
%             end
%             if ( -214.6 < CoX(GazeNo) && CoX(GazeNo) < -180.6 && 279.2 < CoZ(GazeNo) && CoZ(GazeNo) < 304.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)-304.2)^2+(CoX(GazeNo)+214.6)^2)^0.5-0.25*(abs(304.2-279.2)+abs(-180.6+214.6)));
%                 continue;
%             end
%             
%             if ( -464.6 < CoX(GazeNo) && CoX(GazeNo) < -214.6 && 275.2 < CoZ(GazeNo) && CoZ(GazeNo) < 294.2 )
%                 Dist(GazeNo)=abs(CoZ(GazeNo)-(275.2+294.2)/2);
%                 continue;
%             end
%             if ( -510.6 < CoX(GazeNo) && CoX(GazeNo) < -464.6 && 266.2 < CoZ(GazeNo) && CoZ(GazeNo) < 294.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)-266.2)^2+(CoX(GazeNo)+464.6)^2)^0.5-0.25*(abs(294.2-266.2)+abs(-464.6+510.6)));
%                 continue;
%             end
%             
%             if ( -510.6 < CoX(GazeNo) && CoX(GazeNo) < -479.6 && 233.2 < CoZ(GazeNo) && CoZ(GazeNo) < 266.2 && flag==1)
%                 Dist(GazeNo)=abs(CoX(GazeNo)-(-510.6-479.6)/2);
%                 continue;
%             end
%             if ( -510.6 < CoX(GazeNo) && CoX(GazeNo) < -464.6 && 207.2 < CoZ(GazeNo) && CoZ(GazeNo) < 233.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)-233.2)^2+(CoX(GazeNo)+464.6)^2)^0.5-0.25*(abs(233.2-207.2)+abs(-464.6+510.6)));
%                 continue;
%             end
%             
%             if ( -464.6 < CoX(GazeNo) && CoX(GazeNo) < -214.6 && 205.2 < CoZ(GazeNo) && CoZ(GazeNo) < 224.2 )
%                 Dist(GazeNo)=abs(CoZ(GazeNo)-(205.2+224.2)/2);
%                 continue;
%             end
%             if ( -214.6 < CoX(GazeNo) && CoX(GazeNo) < -180.6 && 195.2 < CoZ(GazeNo) && CoZ(GazeNo) < 222.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)-195.2)^2+(CoX(GazeNo)+214.6)^2)^0.5-0.25*(abs(222.2-195.2)+abs(-180.6+214.6)));
%                 continue;
%             end
%             
%             if ( -199.6 < CoX(GazeNo) && CoX(GazeNo) < -180.6 && 165.2 < CoZ(GazeNo) && CoZ(GazeNo) < 195.2 && flag==1)
%                 Dist(GazeNo)=abs(CoX(GazeNo)-(-180.6-199.6)/2);
%                 continue;
%             end
%             if ( -214.6 < CoX(GazeNo) && CoX(GazeNo) < -180.6 && 127.2 < CoZ(GazeNo) && CoZ(GazeNo) < 165.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)-165.2)^2+(CoX(GazeNo)+214.6)^2)^0.5-0.25*(abs(165.2-127.2)+abs(-180.6+214.6)));
%                 continue;
%             end
%             
%             if ( -394.6 < CoX(GazeNo) && CoX(GazeNo) < -214.6 && 127.2 < CoZ(GazeNo) && CoZ(GazeNo) < 152.2 )
%                 Dist(GazeNo)=abs(CoZ(GazeNo)-(127.2+152.2)/2);
%                 continue;
%             end
%             if ( -430.6 < CoX(GazeNo) && CoX(GazeNo) < -394.6 && 115.2 < CoZ(GazeNo) && CoZ(GazeNo) < 152.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)-115.2)^2+(CoX(GazeNo)+394.6)^2)^0.5-0.25*(abs(152.2-115.2)+abs(-394.6+430.6)));
%                 continue;
%             end
%             
%             if ( -430.6 < CoX(GazeNo) && CoX(GazeNo) < -409.6 && 45.2 < CoZ(GazeNo) && CoZ(GazeNo) < 152.2 )
%                 Dist(GazeNo)=abs(CoX(GazeNo)-(-409.6-430.6)/2);
%                 continue;
%             end
%             if ( -430.6 < CoX(GazeNo) && CoX(GazeNo) < -394.6 && 9.2 < CoZ(GazeNo) && CoZ(GazeNo) < 45.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)-45.2)^2+(CoX(GazeNo)+394.6)^2)^0.5-0.25*(abs(45.2-9.2)+abs(-394.6+430.6)));
%                 continue;
%             end
%             
%             if ( -394.6 < CoX(GazeNo) && CoX(GazeNo) < -324.6 && 9.2 < CoZ(GazeNo) && CoZ(GazeNo) < 32.2 )
%                 Dist(GazeNo)=abs(CoZ(GazeNo)-(32.2+9.2)/2);
%                 continue;
%             end
%             if ( -324.6 < CoX(GazeNo) && CoX(GazeNo) < -287.6 && -5.8 < CoZ(GazeNo) && CoZ(GazeNo) < 32.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)+5.8)^2+(CoX(GazeNo)+324.6)^2)^0.5-0.25*(abs(32.2+5.8)+abs(-287.6+324.6)));
%                 continue;
%             end
%             
%             if ( -309.6 < CoX(GazeNo) && CoX(GazeNo) < -287.6 && -35.8 < CoZ(GazeNo) && CoZ(GazeNo) < -5.8 && flag==1)
%                 Dist(GazeNo)=abs(CoX(GazeNo)-(-287.6-309.6)/2);
%                 continue;
%             end
%             if ( -309.6 < CoX(GazeNo) && CoX(GazeNo) < -274.6 && -70.8 < CoZ(GazeNo) && CoZ(GazeNo) < -35.8 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)+35.8)^2+(CoX(GazeNo)+274.6)^2)^0.5-0.25*(abs(-35.8+70.8)+abs(-274.6+309.6)));
%                 continue;
%             end
%             
%             if ( -274.6 < CoX(GazeNo) && CoX(GazeNo) < -214.6 && -70.8 < CoZ(GazeNo) && CoZ(GazeNo) < -50.8 )
%                 Dist(GazeNo)=abs(CoZ(GazeNo)-(-50.8-70.8)/2);
%                 continue;
%             end
%             if ( -214.6 < CoX(GazeNo) && CoX(GazeNo) < -179.6 && -70.8 < CoZ(GazeNo) && CoZ(GazeNo) < -35.8 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)+35.8)^2+(CoX(GazeNo)+214.6)^2)^0.5-0.25*(abs(-35.8+70.8)+abs(-179.6+214.6)));
%                 continue;
%             end
%             
%             if ( -199.6 < CoX(GazeNo) && CoX(GazeNo) < -179.6 && -35.8 < CoZ(GazeNo) && CoZ(GazeNo) < 114.2 )
%                 Dist(GazeNo)=abs(CoX(GazeNo)-(-179.6-199.6)/2);
%                 continue;
%             end
%             if ( -199.6 < CoX(GazeNo) && CoX(GazeNo) < -164.6 && 114.2 < CoZ(GazeNo) && CoZ(GazeNo) < 149.2 && flag==1)
%                 Dist(GazeNo)=abs(((CoZ(GazeNo)-114.2)^2+(CoX(GazeNo)+164.6)^2)^0.5-0.25*(abs(149.2-114.2)+abs(-164.6+199.6)));
%                 continue;
%             end
%             
%             if ( -164.6 < CoX(GazeNo) && CoX(GazeNo) < -60.6 && 129.2 < CoZ(GazeNo) && CoZ(GazeNo) < 149.2 )
%                 Dist(GazeNo)=abs(CoZ(GazeNo)-(149.2+129.2)/2);
%                 continue;
%             end
%         end
%         Dist(Dist==0)=[];
% %         cnt=0;
% %         DistF=zeros(1,1);
% %         for i=1:GazeLen
% %             if (Dist(i)>2.5)
% %                 DistF(i,1)=0;
% %                 cnt=cnt+1;
% %                 continue;
% %             end
% %             DistF(i,1)=Dist(i,1);
% %         end
% %         M(PartNo,SceneNo)=sum(DistF)/(GazeLen-cnt);
% %         Dist(Dist>2.5)=[];
%         M(PartNo,SceneNo)=mean(Dist);
%         Sd(PartNo,SceneNo)=std(Dist);
%         
    end
end
% StdDist=Sd;
% save(['D:\DrivingAny\DataAnalysis\','StdDist.mat'],'StdDist');
% save(['D:\DrivingAny\DataAnalysis\','StdAngle.mat'],'SdAngle');
% save(['D:\DrivingAny\DataAnalysis\','Angle.mat'],'Angle');
save(['D:\DrivingAny\DataAnalysis\','MPS.mat'],'MPS');
% hold on
% plot(Dist)
% plot(DistF)
% FiltedDist=zeros(GazeLen,1);
% w=100;
% for i=w+1:GazeLen
% %     if abs(Dist(i)-Dist(i-1))>1
%         if i>=GazeLen-w
%            
% Dist(i)=mean(Dist(i-w:GazeLen));
%             continue;
%         end
%         Dist(i)=mean(Dist(i-w:i+w));
% %         continue;
% %     end
% %     FiltedDist(i)=Dist(i);
% end
% plot(Dist)