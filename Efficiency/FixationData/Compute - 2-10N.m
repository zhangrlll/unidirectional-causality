%% Initialization
% FixationHitName(1,:)=[];
% Theta(1,:)=[];Phi(1,:)=[];r(1,:)=[];duration(1,:)=[];Average_CarSpeed_In_This_Fixation(1,:)=[];startTime_shijian(1,:)=[];
% StartTime=startTime_shijian;
% Speed=Average_CarSpeed_In_This_Fixation;
sc={'Day';'DuskOn';'DuskOff';'Night'};
DataM=zeros(14,14,4);
for sNo=1:4
    sceneName=sc{sNo};
    for pNo=1:14
        fileName=[num2str(pNo),sceneName,'.xlsx'];
        [raw]=xlsread(fileName);
        lenName=size(raw,1);
%         StartT=xlsread(fileName,['A2:A',num2str(lenName)]);
%         EndT=xlsread(fileName,['B2:B',num2str(lenName)]); 
        duration=xlsread(fileName,['C2:C',num2str(lenName+1)]);
        [num,FixationHitName]=xlsread(fileName,['H2:H',num2str(lenName+1)]);
%         FixationHitName=raw;
        Speed=xlsread(fileName,['I2:I',num2str(lenName+1)]);
        r=xlsread(fileName,['L2:L',num2str(lenName+1)]);
        Theta=xlsread(fileName,['J2:J',num2str(lenName+1)]);
        Phi=xlsread(fileName,['K2:K',num2str(lenName+1)]);
        FixStartT=xlsread(fileName,['G2:G',num2str(lenName+1)]);
%         Phi=(Phi-90);
%         Theta=abs(Theta-90);
%         lenName=lenName-1;
        
        %% Fixation Hit Scene Name
        Name=cell(1,1);
        % Name(1,1)=a;
        NewName=zeros(lenName,1);
        sizeofN=0;
        flag=0;
        
%         F=cell(1,1);P=zeros(1,1);Spe=zeros(1,1);dur=zeros(1,1);Th=zeros(1,1);R=zeros(1,1); j=1;cnt=0;Ft=zeros(1,1);
%         for i=1:1:lenName
% %             if (strcmp(FixationHitName(i),'FAR') || strcmp(FixationHitName(i),'Kooper') || strcmp(FixationHitName(i),'Box001'))
%             if ( strcmp(FixationHitName(i),'Kooper'))
%                 cnt=cnt+1;
%                 continue;
%             end
%             F(j,1)=FixationHitName(i);P(j)=Phi(i);Th(j)=Theta(i);dur(j)=duration(i);R(j)=r(i);Spe(j)=Speed(i);Ft(j)=FixStartT(i);
%             j=j+1;
%         end
%         FixationHitName=F;Phi=P;Theta=Th;duration=dur;Speed=Spe;r=R;FixStartT=Ft;
%         lenName=lenName-cnt;
        for i=1:1:lenName
            for j=1:1:sizeofN
                if (strcmp(FixationHitName(i),Name(j,1)))
                    NewName(i)=j;
                    %             NameCount(j,1)=NameCount(j,1)+1;
                    flag=1;
                    break;
                end
            end
            if flag==0
                sizeofN=sizeofN+1;
                Name(sizeofN,1)=FixationHitName(i);
                NewName(i)=sizeofN;
            end
            flag=0;
        end
        len=sizeofN;
        for i=1:1:len
            if ( strcmp(Name(i),'Kooper'))
                KooperNo=i;
                break;
            end
        end
%         NameCount=zeros(len,1);
%         NameDel=zeros(len,1);
%         for i=1:lenName
%             NameCount(NewName(i),1)=NameCount(NewName(i),1)+1;
%         end
%         NDC=0;nn=cell(1,1);
%         for i=1:len
%             if NameCount(i,1)<1 %0.01*lenName
%                 NameDel(i,1)=1;
%                 NDC=NDC+1;
%             end
%         end
%         
%         F=cell(1,1);P=zeros(1,1);Spe=zeros(1,1);dur=zeros(1,1);Th=zeros(1,1);R=zeros(1,1); j=1;cnt=0;
%         for i=1:1:lenName
%             if NameDel(NewName(i),1)==1
%                 cnt=cnt+1;
%                 continue;
%             end
%             F(j,1)=FixationHitName(i);P(j)=Phi(i);Th(j)=Theta(i);dur(j)=duration(i);R(j)=r(i);Spe(j)=Speed(i);
%             j=j+1;
%         end
%         FixationHitName=F;Phi=P;Theta=Th;duration=dur;Speed=Spe;r=R;
%         lenName=lenName-cnt;
%         Name=cell(1,1);
%         NewName=zeros(lenName,1);
%         sizeofN=0;
%         flag=0;
%         for i=1:1:lenName
%             for j=1:1:sizeofN
%                 if (strcmp(FixationHitName(i),Name(j,1)))
%                     NewName(i)=j;
%                     %             NameCount(j,1)=NameCount(j,1)+1;
%                     flag=1;
%                     break;
%                 end
%             end
%             if flag==0
%                 sizeofN=sizeofN+1;
%                 Name(sizeofN,1)=FixationHitName(i);
%                 NewName(i)=sizeofN;
%             end
%             flag=0;
%         end
%         len=sizeofN;
        %% States Remain
        SceneBeginEnd=zeros(len,2);
        SceneState=zeros(len,lenName);
        for nameNo=1:len
            for i=1:lenName
                if NewName(i)==nameNo
                    SceneBeginEnd(nameNo,1)=i;
                    break;
                end
            end
%             for i=lenName:-1:1
%                 if NewName(i)==nameNo
%                     SceneBeginEnd(nameNo,2)=i;
%                     break;
%                 end
%             end
            SceneBeginEnd(:,2)=lenName;
            SceneState(nameNo,SceneBeginEnd(nameNo,1):SceneBeginEnd(nameNo,2))=1;
        end
        ScenesNumber=sum(SceneState);
%         for i=1:lenName
%             if ScenesNumber(i)<=1
%                 ScenesNumber(i)=2;
%             end
%         end
        stop=floor((lenName-1)*1);
        DSpeed=0;DScnt=0;
        ASpeed=zeros(1,lenName-1);
        for i=2:stop
%             if (Speed(i+1)-Speed(i))<0
%                 DSpeed=DSpeed+abs(Speed(i+1)-Speed(i))/(duration(i+1)/2+duration(i)/2);
% %                 DSpeed=DSpeed+(duration(i+1)/2+duration(i)/2);
%                 DScnt=DScnt+1;
%             end
            ASpeed(i)=ASpeed(i-1)+abs(Speed(i)-Speed(i-1))/(duration(i)/2+duration(i-1)/2);
%             ASpeed=ASpeed+(duration(i+1)/2+duration(i)/2);
        end
        FixRate=(stop)/(FixStartT(stop)+duration(stop+1));
%         ASpeed=ASpeed/(lenName-1);
        %% Scenes' Information Varies
        s=0.5;    % sizes of the AOI
        PI=3.142;
        SpeedProj=zeros(1,lenName);
        SpeedVert=zeros(1,lenName);
        for i=1:lenName
            if NewName(i)~=KooperNo
%                 SpeedProj(1,i)=sind(Phi(i))*sind(Theta(i))*PI/r(i)*(1-1/(1+tand(2*s)^2));
%                 SpeedVert(1,i)=(1-sind(Phi(i))^2*sind(Theta(i))^2)^0.5/r(i)*PI*(0.5*sind(2*s)+s);
                SpeedProj(1,i)=sind(Phi(i))*sind(Theta(i))*tand(s)/(r(i)*(1+tand(s)^2));
                SpeedVert(1,i)=(1-sind(Phi(i))^2*sind(Theta(i))^2)^0.5/r(i);
%                 SpeedProj(1,i)=cosd(Phi(i))*cosd(Theta(i))*tand(s)/r(i)*0.5*sind(2*s);
%                 SpeedVert(1,i)=(1-cosd(Phi(i))^2*cosd(Theta(i))^2)^0.5/r(i)*0.5*(cosd(2*s)+1);
            end
        end
%         SpeedProj=SpeedProj./max(SpeedProj);
%         SpeedVert=SpeedVert./max(SpeedVert);
        Inf=(SpeedVert+SpeedProj).*duration'.*Speed';
        Inf=Inf./max(Inf);
        Inf=Inf+1;
        
        InfChange=zeros(len,lenName);
        InfCount=zeros(len,lenName);
%         InfC=zeros(len,lenName);
        for sceneNo=1:len
            for i=1:lenName
                if (NewName(i,1)==sceneNo)
                    if i==1
%                         if sceneNo~=KooperNo
                            InfChange(sceneNo,i)=Inf(1,i);
%                         end
%                         InfC(sceneNo,i)=Inf(1,i);
                        InfCount(sceneNo,i)=1;
                    end
                    if (i>1)
%                         if sceneNo~=KooperNo
                            InfChange(sceneNo,i)=InfChange(sceneNo,i-1)+Inf(1,i);
%                         end
%                         InfC(sceneNo,i)=Inf(1,i);
                        %                 InfChange(sceneNo,i+1:lenName)=InfChange(sceneNo,i);
                        InfCount(sceneNo,i)=InfCount(sceneNo,i-1)+1;
                        %                 InfCount(sceneNo,i+1:lenName)=InfCount(sceneNo,i);
                    end
                end
                if NewName(i,1)~=sceneNo
                    if i==1
                        continue;
                    end
                    InfChange(sceneNo,i)=InfChange(sceneNo,i-1);
                    InfCount(sceneNo,i)=InfCount(sceneNo,i-1);
                end
            end
        end
%         for j=1:lenName
%             for i=1:len
%                 if InfCount(i,j)~=0
%                     InfChange(i,j)=InfChange(i,j)/InfCount(i,j);
%                 end
%             end
%         end
        InfChange(KooperNo,:)=10^-5;
        for i=1:lenName
            InfChange(:,i)=InfChange(:,i)./sum(InfChange(:,i));
            InfCount(:,i)=InfCount(:,i)./sum(InfCount(:,i));
        end
        
        H=zeros(1,lenName);
        HS=zeros(1,lenName);
        for i=1:lenName
            for j=1:len
                if InfChange(j,i)>0
                    H(1,i)=H(1,i)-InfChange(j,i)*log2(InfChange(j,i));
                end
                if InfCount(j,i)>0
                    HS(1,i)=HS(1,i)-InfCount(j,i)*log2(InfCount(j,i));
                end
            end
        end
        H=H./log2(ScenesNumber);
        HS=HS./log2(ScenesNumber);
        %% Entropy Rate
        MeanDT=zeros(2,len);
        for i=1:stop+1
            for j=1:len
                if NewName(i)==j
                    MeanDT(1,j)=MeanDT(1,j)+1;
                    MeanDT(2,j)=MeanDT(2,j)+duration(i);
                end
            end
        end
        DT=0;
        for i=1:len
            if MeanDT(2,i)>0
                DT=DT+MeanDT(1,i)/MeanDT(2,i);
            end
        end
%         MeanDT(3,:)=MeanDT(2,:)./MeanDT(1,:);
        ESRate=HS(stop+1)*DT;
        %% Transfer Matrix of Scenes
        scd=zeros(1,lenName-1);
        for i=1:lenName-1
            scd(i)=abs(FixStartT(i+1)-FixStartT(i)-duration(i));
            if scd(i)<10^-4
                scd(i)=scd(i-1);
            end
        end
        TranMatrix=zeros(len,len,lenName-1);
        TranMatrixCount=zeros(len,len,lenName-1);
        TranMatrixT=zeros(len,len,lenName-1);
        D=zeros(1,1);
        for i=1:lenName-1
            x1=r(i)*sind(Theta(i))*cosd(Phi(i));
            y1=r(i)*sind(Theta(i))*sind(Phi(i));
            z1=r(i)*cosd(Theta(i));
            x2=r(i+1)*sind(Theta(i+1))*cosd(Phi(i+1));
            y2=r(i+1)*sind(Theta(i+1))*sind(Phi(i+1));
            z2=r(i+1)*cosd(Theta(i+1));
%             D(i)=abs(r(i+1)-r(i));
%             D(i)=((x1-x2)^2+(y1-y2)^2+(z1-z2)^2)^0.5;
            D(i)=acosd((x1*x2+y1*y2+z1*z2)/((x1^2+y1^2+z1^2)^0.5*(x2^2+y2^2+z2^2)^0.5));
            D(i)=D(i)/scd(i);
        end
%         D=D/max(D)+1;
        dt=zeros(len,len,lenName);
        for t=1:lenName-1
            %     if NewName(t,1)~=NewName(t+1,1)
%             if Inf(t+1)-Inf(t)>0
%                 dt(NewName(t,1),NewName(t+1,1),t)=D(t);
%             end
%             if Inf(t+1)-Inf(t)<=0
%                 dt(NewName(t,1),NewName(t+1,1),t)=D(t)/(Inf(t)-Inf(t+1));
%             end
            if t==1
                TranMatrix(NewName(t,1),NewName(t+1,1),t)=D(t);
                TranMatrixT(NewName(t,1),NewName(t+1,1),t)=scd(t);
                TranMatrixCount(NewName(t,1),NewName(t+1,1),t)=1;
                continue;
            end
            dt(NewName(t,1),NewName(t+1,1),t)=D(t);
            TranMatrix(:,:,t)=TranMatrix(:,:,t-1)+dt(:,:,t);
            dt(NewName(t,1),NewName(t+1,1),t)=1;
            TranMatrixCount(:,:,t)=TranMatrixCount(:,:,t-1)+dt(:,:,t);
%             if FixStartT(t+1)-FixStartT(t)-duration(t)>10^-5
                dt(NewName(t,1),NewName(t+1,1),t)=scd(t);
%             else
%                 dt(NewName(t,1),NewName(t+1,1),t)=0;
%             end
            TranMatrixT(:,:,t)=TranMatrixT(:,:,t-1)+dt(:,:,t);
            %     end
        end
%         for t=1:lenName-1
%             for i=1:len
%                 TranMatrix(i,i,t)=0;
%                 TranMatrixCount(i,i,t)=0;
%             end
%         end
        for t=1:lenName-1
            for i=1:len
                for j=1:len
                    if (TranMatrixCount(i,j,t)>0 && TranMatrixT(i,j,t)>0)
                        TranMatrixT(i,j,t)=TranMatrixCount(i,j,t)/TranMatrixT(i,j,t);
                    end
                end
            end
        end
        for t=1:lenName-1
            if sum(sum(TranMatrix(:,:,t)))>0
                TranMatrix(:,:,t)=TranMatrix(:,:,t)./sum(sum(TranMatrix(:,:,t)));
                TranMatrixCount(:,:,t)=TranMatrixCount(:,:,t)./sum(sum(TranMatrixCount(:,:,t)));
            end
        end
%         TM=TranMatrix;
        PEDistE2O=zeros(1,lenName-1);
        PEDistO2E=zeros(1,lenName-1);
        TEDistE2O=zeros(1,lenName-1);
        TEDistO2E=zeros(1,lenName-1);
        for FixNo=1:lenName-1
            for i=1:len
                for j=1:len
                    if (TranMatrix(i,j,FixNo)>0 && TranMatrixCount(i,j,FixNo)>0)
                        PEDistE2O(FixNo)=PEDistE2O(FixNo)+TranMatrix(i,j,FixNo)*log(TranMatrix(i,j,FixNo)/0.5/(TranMatrixCount(i,j,FixNo)+TranMatrix(i,j,FixNo)));
                        PEDistO2E(FixNo)=PEDistO2E(FixNo)+TranMatrixCount(i,j,FixNo)*log(TranMatrixCount(i,j,FixNo)/0.5/(TranMatrixCount(i,j,FixNo)+TranMatrix(i,j,FixNo)));
                        TEDistE2O(FixNo)=TEDistE2O(FixNo)+TranMatrix(i,j,FixNo)*log(TranMatrix(i,j,FixNo)/TranMatrixCount(i,j,FixNo));
                        TEDistO2E(FixNo)=TEDistO2E(FixNo)+TranMatrixCount(i,j,FixNo)*log(TranMatrixCount(i,j,FixNo)/TranMatrix(i,j,FixNo));
                    end
                end
            end
            %             PEDistE2O(FixNo)=PEDistE2O(FixNo)/log2(ScenesNumber(FixNo));
            %             PEDistO2E(FixNo)=PEDistO2E(FixNo)/log2(ScenesNumber(FixNo));
        end
        PEJSD=0.5*(PEDistE2O+PEDistO2E);
        TEJSD=TEDistO2E;%+TEDistE2O
        Hij=zeros(1,lenName-1);
        for t=1:lenName-1
            for i=1:len
                for j=1:len
                    if (TranMatrix(i,j,t)>0 && TranMatrixCount(i,j,t)>0)
                        Hij(t)=Hij(t)-TranMatrixCount(i,j,t)*log(TranMatrixCount(i,j,t));
                    end
                end
            end
        end
        Hij=Hij./log2(ScenesNumber(1:lenName-1));
        ERate=Hij(stop)*sum(sum(TranMatrixT(:,:,stop)));

        for t=1:lenName-1
            for i=1:len
                if sum(sum(TranMatrix(i,:,t)))>0
                    TranMatrix(i,:,t)=TranMatrix(i,:,t)./sum(sum(TranMatrix(i,:,t)));
                    TranMatrixCount(i,:,t)=TranMatrixCount(i,:,t)./sum(sum(TranMatrixCount(i,:,t)));
                end
            end
        end
         
        HTran=zeros(len,lenName-1);
        HTranS=zeros(len,lenName-1);
        for p=1:lenName-1
            for i=1:len
                for j=1:len
                    if TranMatrix(i,j,p)>0
                        HTran(i,p)=HTran(i,p)-TranMatrix(i,j,p)*log2(TranMatrix(i,j,p));
                    end
                    if TranMatrixCount(i,j,p)>0
                        HTranS(i,p)=HTranS(i,p)-TranMatrixCount(i,j,p)*log2(TranMatrixCount(i,j,p));
                    end
                end
            end
%             HTran(:,p)=HTran(:,p)./log2(ScenesNumber(p));
%             HTranS(:,p)=HTranS(:,p)./log2(ScenesNumber(p));
        end
%         TIS=sum(HTranS.*InfChange(:,1:lenName-1))./log2(ScenesNumber(1:lenName-1));
%         TIC=sum(HTran.*InfCount(:,1:lenName-1))./log2(ScenesNumber(1:lenName-1));
%         TI=sum(HTran.*InfChange(:,1:lenName-1))./log2(ScenesNumber(1:lenName-1));
        TIO=sum(HTranS.*InfCount(:,1:lenName-1))./log2(ScenesNumber(1:lenName-1));
        
%         TranMatrix=zeros(len,len,lenName-1);
%         TranMatrixCount=zeros(len,len,lenName-1);
%         for t=1:lenName-1
%             for i=1:len
%                 for j=1:len
%                     if Inf(t+1)-Inf(t)>0
%                         TranMatrix(i,j,t)=Inf(t+1)-Inf(t);
%                     end
%                 end
%             end
%         end
%         dt=zeros(len,len,lenName);
%         for t=1:lenName-1
%             %     if NewName(t,1)~=NewName(t+1,1)
% %             if Inf(t+1)-Inf(t)>0
% %                 dt(NewName(t,1),NewName(t+1,1),t)=(Inf(t+1)-Inf(t));
% %             end
% %             if Inf(t+1)-Inf(t)<=0
% %                 dt(NewName(t,1),NewName(t+1,1),t)=D(t)/(Inf(t)-Inf(t+1));
% %             end
%             if t==1
% %                 TranMatrix(:,:,t)=dt(:,:,t);
%                 TranMatrixCount(NewName(t,1),NewName(t+1,1),t)=1;
%                 continue;
%             end
% %             TranMatrix(:,:,t)=TranMatrix(:,:,t-1)+dt(:,:,t);
%             dt(NewName(t,1),NewName(t+1,1),t)=1;
%             TranMatrixCount(:,:,t)=TranMatrixCount(:,:,t-1)+dt(:,:,t);
%             %     end
%         end
%         for t=1:lenName-1
%             TranMatrix(:,:,t)=TranMatrix(:,:,t)./sum(sum(TranMatrix(:,:,t)));
%             TranMatrixCount(:,:,t)=TranMatrixCount(:,:,t)./sum(sum(TranMatrixCount(:,:,t)));
%         end
%         PEDistE2O=zeros(1,lenName-1);
%         PEDistO2E=zeros(1,lenName-1);
%         for FixNo=1:lenName-1
%             for i=1:len
%                 for j=1:len
%                     if (TranMatrix(i,j,FixNo)>0 && TM(i,j,FixNo)>0)
%                         PEDistE2O(FixNo)=PEDistE2O(FixNo)+TranMatrix(i,j,FixNo)*log(TranMatrix(i,j,FixNo)/0.5/(TM(i,j,FixNo)+TranMatrix(i,j,FixNo)));
%                         PEDistO2E(FixNo)=PEDistO2E(FixNo)+TM(i,j,FixNo)*log(TM(i,j,FixNo)/0.5/(TM(i,j,FixNo)+TranMatrix(i,j,FixNo)));
%                     end
%                 end
%             end
%             %             PEDistE2O(FixNo)=PEDistE2O(FixNo)/log2(ScenesNumber(FixNo));
%             %             PEDistO2E(FixNo)=PEDistO2E(FixNo)/log2(ScenesNumber(FixNo));
%         end
%         TEJSD=0.5*(PEDistE2O+PEDistO2E);
        
%         aMGTE=mean(TIS);
        % for i=1:lenName-1
        %     if sum(HTran(:,i))>0
        %         HTran(:,i)=HTran(:,i)./sum(HTran(:,i));
        %     end
        %     if sum(HTranS(:,i))>0
        %         HTranS(:,i)=HTranS(:,i)./sum(HTranS(:,i));
        %     end
        % end
        % for i=1:len
        %     for j=1:len
        %         for t=1:lenName-1
        %             if (NewName(t,1)==i && NewName(t+1,1)==j)
        %                 TranMatrix(t,i,j)=TranMatrix(t,i,j)+D(t);
        %                 TranMatrixCount(t,i,j)=TranMatrixCount(i,j)+1;
        %             end
        %         end
        %     end
        % end
        % for i=1:len
        %     for j=1:len
        %         if TranMatrixCount(i,j)>0
        %             TranMatrixAvg(i,j)=TranMatrix(i,j)/TranMatrixCount(i,j);
        %         end
        %     end
        % end
        % TranMatrixAvg=TranMatrix./TranMatrixCount;
        % for i=1:len
        %     TranMatrixAvg(i,i)=0;
        %     TranMatrix(i,i)=0;
        % end

        %% Entropy of Transfer Matrix
        %% JSD of SGE
        k=1;
        InfDistE2O=zeros(1,lenName);
        InfDistO2E=zeros(1,lenName);
        TInfDistE2O=zeros(1,lenName);
        TInfDistO2E=zeros(1,lenName);
%         InfKLDE2O=zeros(1,lenName);
%         sChange=zeros(1,lenName);
%         sCount=zeros(1,lenName);
%         for i=1:lenName
%             for j=1:len
%                 if j~=KooperNo
%                     sChange=sChange+InfChange(j,i);
%                     sCount=sCount+InfCount(j,i);
%                 end
%             end
%         end
        for FixNo=1:lenName
            for i=1:len
                if (InfChange(i,FixNo)>0 && InfCount(i,FixNo)>0)
                    InfDistE2O(FixNo)=InfDistE2O(FixNo)+InfChange(i,FixNo)*log(InfChange(i,FixNo)/0.5/(InfCount(i,FixNo)+InfChange(i,FixNo)));
                    InfDistO2E(FixNo)=InfDistO2E(FixNo)+InfCount(i,FixNo)*log(InfCount(i,FixNo)/0.5/(InfChange(i,FixNo)+InfCount(i,FixNo)));
                    TInfDistE2O(FixNo)=TInfDistE2O(FixNo)+InfChange(i,FixNo)*log(InfChange(i,FixNo)/InfCount(i,FixNo));
                    TInfDistO2E(FixNo)=TInfDistO2E(FixNo)+InfCount(i,FixNo)*log(InfCount(i,FixNo)/InfChange(i,FixNo));
                end
            end
%             InfDistE2O(FixNo)=InfDistE2O(FixNo)/log2(ScenesNumber(FixNo));
%             InfDistO2E(FixNo)=InfDistO2E(FixNo)/log2(ScenesNumber(FixNo));
        end
        InfJSD=0.5*(InfDistE2O+InfDistO2E);
        TInfJSD=TInfDistE2O;%+TInfDistO2E;
        %% JSD of Transfer Matrix
%         PEDistE2O=zeros(len,lenName-1);
%         PEDistO2E=zeros(len,lenName-1);
%         for FixNo=1:lenName-1
%             for i=1:len
%                 for j=1:len
%                     if (TranMatrix(i,j,FixNo)>0 && TranMatrixCount(i,j,FixNo)>0)
%                         PEDistE2O(i,FixNo)=PEDistE2O(i,FixNo)+TranMatrix(i,j,FixNo)*log(TranMatrix(i,j,FixNo)/0.5/(TranMatrixCount(i,j,FixNo)+TranMatrix(i,j,FixNo)));
%                         PEDistO2E(i,FixNo)=PEDistO2E(i,FixNo)+TranMatrixCount(i,j,FixNo)*log(TranMatrixCount(i,j,FixNo)/0.5/(TranMatrix(i,j,FixNo)+TranMatrixCount(i,j,FixNo)));
%                     end
%                 end
%             end
% %             PEDistE2O(FixNo)=PEDistE2O(FixNo)/log2(ScenesNumber(FixNo)^2);
% %             PEDistO2E(FixNo)=PEDistO2E(FixNo)/log2(ScenesNumber(FixNo)^2);
%         end 
%         PEJSD=0.5*(PEDistE2O+PEDistO2E);
%         PEJSD=sum(0.5*(PEDistE2O+PEDistO2E).*InfCount(:,1:lenName-1));

%         aGTEJSD=PEJSD(lenName-1);
%         PEDistO2E=0;PEDistE2O=0;
%         for i=1:len
%             for j=1:len
%                 if (TranMatrix(i,j,(lenName-1))~=0 && TranMatrixCount(i,j,(lenName-1))~=0)
%                     PEDistE2O=PEDistE2O+TranMatrix(i,j,(lenName-1))*log2(TranMatrix(i,j,(lenName-1))/TranMatrixCount(i,j,(lenName-1)));
%                     PEDistO2E=PEDistO2E+TranMatrixCount(i,j,(lenName-1))*log2(TranMatrixCount(i,j,(lenName-1))/TranMatrix(i,j,(lenName-1)));
%                 end
%             end
%         end
%         PEDistE2O=InfDistE2O/log2(len);
%         PEDistO2E=InfDistO2E/log2(len);
%         aGTEJSD=0.5*(PEDistE2O+PEDistO2E);
        %% Mutual Information of Gaze Distribution
%         JointProb=zeros(len,len);
        %% Mutual Information of Transfer Matrix
        %% Results
%         hold on
%         plot(InfJSD)
%         plot(PEJSD)
%         aGTED=sum(abs(TIS-TIO))/(lenName-1)./max(TIS);%/len;
%         aSGED=sum(abs(HS-H))/lenName./max(H);
        DataM(pNo,:,sNo)=[TInfJSD(stop+1)/TEJSD(stop),InfJSD(stop+1)/PEJSD(stop),TIO(stop),TEJSD(stop),TInfJSD(stop+1),PEJSD(stop),InfJSD(stop+1),Hij(stop),HS(stop),H(stop),ESRate,ERate,FixRate,1/ASpeed(stop)*stop];%mean(AcceleratedSpeed)
    end
end
save(['D:\DrivingAny\DataAnalysis\','DataM.mat'],'DataM');
Day=DataM(:,:,1);
save(['D:\DrivingAny\DataAnalysis\','Day.mat'],'Day');
DuskOn=DataM(:,:,2);
save(['D:\DrivingAny\DataAnalysis\','DuskOn.mat'],'DuskOn');
DuskOff=DataM(:,:,3);
save(['D:\DrivingAny\DataAnalysis\','DuskOff.mat'],'DuskOff');
Night=DataM(:,:,4);
save(['D:\DrivingAny\DataAnalysis\','Night.mat'],'Night');

% Tran=sum(TranMatrix)./sum(sum(TranMatrix));
% InfS=InfChange(:,lenName)./sum(InfChange(:,lenName));
% InfS=InfS';
% Dist=abs(Tran-InfS);
% HTran=0;HInfS=0;HDist=0;
% for i=1:len
%     if Tran(1,i)>0
%         HTran=HTran-Tran(1,i)*log2(Tran(1,i));
%     end
%     if InfS(1,i)>0
%         HInfS=HInfS-InfS(1,i)*log2(InfS(1,i));
%     end
%     if Dist(1,i)>0
%         HDist=HDist-Dist(1,i)*log2(Dist(1,i));
%     end
% end
% 
% Diff=HTran-HInfS;
% hold on
% plot(Tran)
% plot(InfS)