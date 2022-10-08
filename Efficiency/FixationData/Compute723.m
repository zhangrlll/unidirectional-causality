%% Study between eye movement and task performance(VR driving average acceleration)
% Proposal: Information varies  by two velocities have strong correlation to performance
% also including computation and comparision of GTE, fixation rate, entropy
% rate...
% DataM stores the data: 10 indicators in lines,14 participants in raws, 4
% scenes in the 3rd dimension. The last indicator means the
% task performance(efficiency), 1/acceleration.
% by sLdZ 2020-2 in TJ

ScenesName={'Day';'DuskOn';'DuskOff';'Night'};
DataM=zeros(14,20,4);
for sNo=4:4
    CurrentSceneName=ScenesName{sNo};
    for pNo=14:14
        %% Load one participant's data
        FileName=[num2str(pNo),CurrentSceneName,'.xlsx'];
        [raw]=xlsread(FileName);
        FixationLength=size(raw,1);
        Duration=xlsread(FileName,['C2:C',num2str(FixationLength+1)]);
        [num,FixationHitName]=xlsread(FileName,['H2:H',num2str(FixationLength+1)]);
        Velocity=xlsread(FileName,['I2:I',num2str(FixationLength+1)]);
        r=xlsread(FileName,['L2:L',num2str(FixationLength+1)]);
        Theta=xlsread(FileName,['J2:J',num2str(FixationLength+1)]);
        Phi=xlsread(FileName,['K2:K',num2str(FixationLength+1)]);
        FixationStartT=xlsread(FileName,['G2:G',num2str(FixationLength+1)]);
        %% Data preprocessing
        % Fixations hit on the driver's car lead to wrong velocity computation
        % Remove fixations hit on "Kooper"
        F=cell(1,1);P=zeros(1,1);Spe=zeros(1,1);dur=zeros(1,1);Th=zeros(1,1);R=zeros(1,1);Ft=zeros(1,1);
        j=1;cnt=0;
        for i=1:1:FixationLength
            if ( strcmp(FixationHitName(i),'Kooper'))
                cnt=cnt+1;
                continue;
            end
            F(j,1)=FixationHitName(i);P(j)=Phi(i);Th(j)=Theta(i);dur(j)=Duration(i);R(j)=r(i);Spe(j)=Velocity(i);Ft(j)=FixationStartT(i);
            j=j+1;
        end
        FixationHitName=F;Phi=P;Theta=Th;Duration=dur;Velocity=Spe;r=R;FixationStartT=Ft;
        FixationLength=FixationLength-cnt;
%         delRatio=0.5;begDel=floor(0.3*FixationLength);endDel=floor(FixationLength*(0.3+delRatio));
%         FixationHitName(begDel:endDel,:)=[];
%         Phi(begDel:endDel)=[];Theta(begDel:endDel)=[];
%         Duration(begDel:endDel)=[];Velocity(begDel:endDel)=[];r(begDel:endDel)=[];FixationStartT(begDel:endDel)=[];
%         FixationLength=FixationLength-(endDel-begDel+1);
        %% Transfer AOI names from strings to numbers
        AOIName=cell(1,1);  % Store AOI string names shown already
        AOINumName=zeros(FixationLength,1); % New AOI names in number
        AOINumber=0;    % Amount of AOI
        flag=0;
        for i=1:1:FixationLength
            for j=1:1:AOINumber
                if (strcmp(FixationHitName(i),AOIName(j,1)))
                    AOINumName(i)=j;
                    flag=1;
                    break;
                end
            end
            if flag==0
                AOINumber=AOINumber+1;
                AOIName(AOINumber,1)=FixationHitName(i);
                AOINumName(i)=AOINumber;
            end
            flag=0;
        end
        %% AOI amount during one test(for entropy's normalization log(N))
        AOIBeginEnd=zeros(AOINumber,2);
        AOIState=zeros(AOINumber,FixationLength);
        for nameNo=1:AOINumber
            for i=1:FixationLength
                if AOINumName(i)==nameNo
                    AOIBeginEnd(nameNo,1)=i;
                    break;
                end
            end
            AOIBeginEnd(:,2)=FixationLength;
            AOIState(nameNo,AOIBeginEnd(nameNo,1):AOIBeginEnd(nameNo,2))=1;
        end
        AOIAmount=sum(AOIState);
        %% Breakpoints at "stop" to show the DATA till then
        stop=floor((FixationLength-1)*1);
        %% Saccad duration from one fixation end to the next's begining
        SaccadDuration=zeros(1,FixationLength-1);
        for i=1:FixationLength-1
            SaccadDuration(i)=abs(Duration(i)+Duration(i+1));
            if SaccadDuration(i)<10^-4  % Some durations are so small that lead to bugs
                SaccadDuration(i)=SaccadDuration(i-1);
            end
        end
        %% Average acceleration
        Acceleration=zeros(1,FixationLength-1);
        Acceleration(1)=abs(Velocity(2)-Velocity(1))/(FixationStartT(2)-FixationStartT(1)-Duration(1)/2+Duration(2)/2);
        for i=2:FixationLength-1
            Acceleration(i)=Acceleration(i-1)+abs(Velocity(i)-Velocity(i+1))/(FixationStartT(i+1)-FixationStartT(i)-Duration(i)/2+Duration(i+1)/2);
        end
        %% FR(Fixation Rate)
        FR=(stop)/(FixationStartT(stop)+Duration(stop+1));
        %% View scene information varies in two kinds of velocity
        VisualAngleHalf=0.5;    
        PI=3.142;
        VelocityProj=zeros(1,FixationLength);  % Projection velocity of the direction parrallel with the sight line
        VelocityTangential=zeros(1,FixationLength);  % Projection velocity of the direction vertical to the sight line
        for i=1:FixationLength
            VelocityProj(1,i)=sind(Phi(i))*sind(Theta(i))*tand(VisualAngleHalf)/(r(i)*(1+tand(VisualAngleHalf)^2));
            VelocityTangential(1,i)=(1-sind(Phi(i))^2*sind(Theta(i))^2)^0.5/r(i);
        end
        InfChange=(VelocityTangential+VelocityProj).*Duration.*Velocity;
       
        %% AOI distribution by information varies and showing up frequency respectively
        
        InfDistribution=zeros(AOINumber,FixationLength); % Information varies (Pi')
        AOIDistribution=zeros(AOINumber,FixationLength); % Frequency (Pi)
        for sceneNo=1:AOINumber
            for i=1:FixationLength
                if (AOINumName(i,1)==sceneNo)
                    if i==1
                        InfDistribution(sceneNo,i)=InfChange(1,i);
                        AOIDistribution(sceneNo,i)=1;
                    end
                    if (i>1)
                        InfDistribution(sceneNo,i)=InfDistribution(sceneNo,i-1)+InfChange(1,i);
                        AOIDistribution(sceneNo,i)=AOIDistribution(sceneNo,i-1)+1;
                    end
                end
                if AOINumName(i,1)~=sceneNo
                    if i==1
                        continue;
                    end
                    InfDistribution(sceneNo,i)=InfDistribution(sceneNo,i-1);
                    AOIDistribution(sceneNo,i)=AOIDistribution(sceneNo,i-1);
                end
            end
        end
        % Normalization
        for i=1:FixationLength
            InfDistribution(:,i)=InfDistribution(:,i)./sum(InfDistribution(:,i));
            AOIDistribution(:,i)=AOIDistribution(:,i)./sum(AOIDistribution(:,i));
        end
        %% AOI Transition Matrix
        TranMatrix=zeros(AOINumber,AOINumber,FixationLength-1);   % Transfer matrix enhanced bu saccad angle (Pij')
        TranMatrixCount=zeros(AOINumber,AOINumber,FixationLength-1);   % Transfer matrix by frequency (Pij)
        TranMatrixDuration=zeros(AOINumber,AOINumber,FixationLength-1);    % Transfer duration matrix (PDij)
        dt=zeros(AOINumber,AOINumber,FixationLength);
        for t=1:FixationLength-1
            if t==1
                TranMatrix(AOINumName(t,1),AOINumName(t+1,1),t)=InfDistribution(t);
                TranMatrixDuration(AOINumName(t,1),AOINumName(t+1,1),t)=SaccadDuration(t);
                TranMatrixCount(AOINumName(t,1),AOINumName(t+1,1),t)=1;
                continue;
            end
            dt(AOINumName(t,1),AOINumName(t+1,1),t)=InfDistribution(t);
            TranMatrix(:,:,t)=TranMatrix(:,:,t-1)+dt(:,:,t);
            dt(AOINumName(t,1),AOINumName(t+1,1),t)=1;
            TranMatrixCount(:,:,t)=TranMatrixCount(:,:,t-1)+dt(:,:,t);
            dt(AOINumName(t,1),AOINumName(t+1,1),t)=SaccadDuration(t);
            TranMatrixDuration(:,:,t)=TranMatrixDuration(:,:,t-1)+dt(:,:,t);
        end
        % Harmonic mean of saccad duration in matrix
        for t=1:FixationLength-1
            for i=1:AOINumber
                for j=1:AOINumber
                    if (TranMatrixCount(i,j,t)>0 && TranMatrixDuration(i,j,t)>0)
                        TranMatrixDuration(i,j,t)=TranMatrixCount(i,j,t)/TranMatrixDuration(i,j,t);
                    end
                end
            end
        end
        % Normalization of Pij and Pij'
        for t=1:FixationLength-1
            if sum(sum(TranMatrix(:,:,t)))>0
                TranMatrix(:,:,t)=TranMatrix(:,:,t)./sum(sum(TranMatrix(:,:,t)));
                TranMatrixCount(:,:,t)=TranMatrixCount(:,:,t)./sum(sum(TranMatrixCount(:,:,t)));
            end
        end
%         THellingerD=0.5*sum(sum((TranMatrix(:,:,stop).^0.5-TranMatrixCount(:,:,stop).^0.5).^2));

        
        %% SGE(Stationary gaze entropy) of Pi and Pi'
        SGEEnhanced=zeros(1,FixationLength);    % SGE Pi'
        SGE=zeros(1,FixationLength);
        for i=1:FixationLength
            SGEEnhanced(1,i)=Entropy(InfDistribution(:,i),AOIAmount(i));
            SGE(1,i)=Entropy(AOIDistribution(:,i),AOIAmount(i));
        end
        %% SER(Stationary Entropy Rate) = SGE * Sigma(1/AOIDuration)
        AOIMeanDuration=zeros(2,AOINumber);
        for i=1:stop+1
            for j=1:AOINumber
                if AOINumName(i)==j
                    AOIMeanDuration(1,j)=AOIMeanDuration(1,j)+1;
                    AOIMeanDuration(2,j)=AOIMeanDuration(2,j)+Duration(i);
                end
            end
        end
        HarmonicMeanAOIDuration=0;
        for i=1:AOINumber
            if AOIMeanDuration(2,i)>0
                HarmonicMeanAOIDuration=HarmonicMeanAOIDuration+AOIMeanDuration(1,i)/AOIMeanDuration(2,i);
            end
        end
        SER=SGE(stop+1)*HarmonicMeanAOIDuration;
        %% Saccad 3D angle from one fixation to another
        SaccadAngle=zeros(1,1);
        for i=1:FixationLength-1
            x1=sind(Theta(i))*cosd(Phi(i));
            y1=sind(Theta(i))*sind(Phi(i));
            z1=cosd(Theta(i));
            x2=sind(Theta(i+1))*cosd(Phi(i+1));
            y2=sind(Theta(i+1))*sind(Phi(i+1));
            z2=cosd(Theta(i+1));
            SaccadAngle(i)=acosd((x1*x2+y1*y2+z1*z2)/((x1^2+y1^2+z1^2)^0.5*(x2^2+y2^2+z2^2)^0.5));
        end

        %% ER(Entropy Rate) = Pij Entropy * Sigma(PDij)
        TranSGE=zeros(1,FixationLength-1);
        for t=1:FixationLength-1
            TranSGE(t)=Entropy(TranMatrixCount(:,:,t),AOIAmount(t));
        end
        ER=TranSGE(stop)*sum(sum(TranMatrixDuration(:,:,stop)));
       %% JSD between Pi and Pi'
        AOIJSD=zeros(1,FixationLength-1);
        AOIKLDE2O=zeros(1,FixationLength-1);
        AOIKLDO2E=zeros(1,FixationLength-1);
        for FixNo=1:FixationLength
            AOIJSD(FixNo)=JSD(InfDistribution(:,FixNo),AOIDistribution(:,FixNo));
            AOIKLDE2O(FixNo)=KLD(InfDistribution(:,FixNo),AOIDistribution(:,FixNo));
            AOIKLDO2E(FixNo)=KLD(AOIDistribution(:,FixNo),InfDistribution(:,FixNo));
        end
        %% JSD between Pij and Pij'
        TranJSD=zeros(1,FixationLength-1);
        TMKLDE2O=zeros(1,FixationLength-1);
        TMKLDO2E=zeros(1,FixationLength-1);
        for FixNo=1:FixationLength-1
            TranJSD(FixNo)=JSD(TranMatrix(:,:,FixNo),TranMatrixCount(:,:,FixNo));
            TMKLDE2O(FixNo)=KLD(TranMatrix(:,:,FixNo),TranMatrixCount(:,:,FixNo));
            TMKLDO2E(FixNo)=KLD(TranMatrixCount(:,:,FixNo),TranMatrix(:,:,FixNo));
        end
        %% GTE(Gaze Transition Entropy)
        % Normalization in line to fit GTE's computation
        for t=1:FixationLength-1
            for i=1:AOINumber
                if sum(sum(TranMatrixCount(i,:,t)))>0
                    TranMatrixCount(i,:,t)=TranMatrixCount(i,:,t)./sum(sum(TranMatrixCount(i,:,t)));
                end
            end
        end
        % GTE
        TranEntropy=zeros(AOINumber,FixationLength-1);
        for p=1:FixationLength-1
            for i=1:AOINumber
                TranEntropy(i,p)=Entropy(TranMatrixCount(i,:,p),AOIAmount(p));
            end
        end
        GTE=sum(TranEntropy.*AOIDistribution(:,1:FixationLength-1));
       %% Data
        DataM(pNo,:,sNo)=[AOIJSD(stop+1)/TranJSD(stop),(AOIKLDO2E(stop+1)+AOIKLDE2O(stop+1))/(TMKLDO2E(stop)+TMKLDE2O(stop)),AOIKLDO2E(stop+1)/TMKLDO2E(stop),AOIKLDO2E(stop+1)/TMKLDE2O(stop),AOIKLDE2O(stop+1)/TMKLDO2E(stop),AOIKLDE2O(stop+1)/TMKLDE2O(stop),AOIJSD(stop+1),AOIKLDO2E(stop),AOIKLDE2O(stop),TranJSD(stop),TMKLDO2E(stop),TMKLDE2O(stop),GTE(stop),SGE(stop),sum(SaccadAngle(1:stop))/stop,ER,FR,TranSGE(stop),SGEEnhanced(stop+1),stop/Acceleration(stop)];
    end
end
%% Saving data by different scenes respectively
save(['D:\DrivingDataAnalysis\Efficiency\DataAnalysis\','DataM.mat'],'DataM');
Day=DataM(:,:,1);
save(['D:\DrivingDataAnalysis\Efficiency\DataAnalysis\','Day.mat'],'Day');
DuskOn=DataM(:,:,2);
save(['D:\DrivingDataAnalysis\Efficiency\DataAnalysis\','DuskOn.mat'],'DuskOn');
DuskOff=DataM(:,:,3);
save(['D:\DrivingDataAnalysis\Efficiency\DataAnalysis\','DuskOff.mat'],'DuskOff');
Night=DataM(:,:,4);
save(['D:\DrivingDataAnalysis\Efficiency\DataAnalysis\','Night.mat'],'Night');
