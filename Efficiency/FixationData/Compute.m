%% Study between eye movement and task performance (VR driving average acceleration)
% Proposal: Information varies  by two velocities have strong correlation to performance
% also including computation and comparision of GTE, fixation rate, entropy
% rate...
% DataM stores the data: 10 indicators in lines,14 participants in raws, 4
% scenes in the 3rd dimension. The last indicator means the
% task performance(efficiency), 1/acceleration.
% by sLdZ 2020-2 sldz0306@sina.com

ScenesName={'Day';'DuskOn';'DuskOff';'Night'};
DataM=zeros(14,9,4);
DataSA=zeros(14,1,4);
for sNo=1:4
    CurrentSceneName=ScenesName{sNo};
    for pNo=1:14
        %% Load one participant's data
        FileName=[num2str(pNo),CurrentSceneName,'.xlsx'];
        [raw]=xlsread(FileName);
        FixationLength=size(raw,1);
        %% Breakpoints at "stop" to show the DATA till then
        sstop=1;    % output the results based on first sstop*100% fixation data (first * percent data; for example, sstop=0.9 means the first 90% data) 
        stop=floor((FixationLength)*sstop); % stop=the number of fixations used for computation    
        
        Duration=xlsread(FileName,['C2:C',num2str(stop+1)]);
        [num,FixationHitName]=xlsread(FileName,['H2:H',num2str(stop+1)]);
        Velocity=xlsread(FileName,['I2:I',num2str(stop+1)]);
        r=xlsread(FileName,['L2:L',num2str(stop+1)]);
        Theta=xlsread(FileName,['J2:J',num2str(stop+1)]);
        Phi=xlsread(FileName,['K2:K',num2str(stop+1)]);
        FixationStartT=xlsread(FileName,['G2:G',num2str(stop+1)]);
        %% Data preprocessing
        % Fixations hit on the driver's car lead to wrong velocity computation
        % Remove fixations hit on the car ( "Kooper")
        F=cell(1,1);P=zeros(1,1);Spe=zeros(1,1);dur=zeros(1,1);Th=zeros(1,1);R=zeros(1,1);Ft=zeros(1,1);
        j=1;cnt=0;
        for i=1:1:stop
            if ( strcmp(FixationHitName(i),'Kooper'))
                cnt=cnt+1;
                continue;
            end
            F(j,1)=FixationHitName(i);P(j)=Phi(i);Th(j)=Theta(i);dur(j)=Duration(i);R(j)=r(i);Spe(j)=Velocity(i);Ft(j)=FixationStartT(i);
            j=j+1;
        end
        FixationHitName=F;Phi=P;Theta=Th;Duration=dur;Velocity=Spe;r=R;FixationStartT=Ft;
        stop=stop-cnt;        
        %% Transfer AOI names from strings to numbers
        AOIName=cell(1,1);  % Store AOI string names shown already
        AOINumName=zeros(stop,1); % New AOI names in number
        AOINumber=0;    % Amount of AOI
        flag=0;
        for i=1:1:stop
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
        %% N=number of AOIs during a trial(for entropy's normalization log(N))
        AOIBeginEnd=zeros(AOINumber,2);
        AOIState=zeros(AOINumber,FixationLength);
        for nameNo=1:AOINumber
            for i=1:stop
                if AOINumName(i)==nameNo
                    AOIBeginEnd(nameNo,1)=i;
                    break;
                end
            end
            AOIBeginEnd(:,2)=FixationLength;
            AOIState(nameNo,AOIBeginEnd(nameNo,1):AOIBeginEnd(nameNo,2))=1;
        end
        AOIAmount=sum(AOIState);
        
        %% Saccad duration from one fixation end to the next's begining
        SaccadDuration=zeros(1,stop-1);
        for i=1:stop-1
            SaccadDuration(i)=abs(Duration(i)+Duration(i+1));
            if SaccadDuration(i)<10^-4  % Some durations are so small that lead to bugs
                SaccadDuration(i)=SaccadDuration(i-1);
            end
        end
        %% Average acceleration for a trial
        Acceleration=zeros(1,stop-1);
%         Acceleration(1)=abs(Velocity(2)-Velocity(1))/(FixationStartT(2)-FixationStartT(1)-Duration(1)/2+Duration(2)/2);
        for i=1:stop-1
            Acceleration(i)=abs(Velocity(i)-Velocity(i+1))/(FixationStartT(i+1)-FixationStartT(i)-Duration(i)/2+Duration(i+1)/2);
        end
        %% FR(Fixation Rate)
        FR=(stop)/sum(Duration(1:stop));
        %% Visual motion for each fixation
        VisualAngleHalf=1;
        PI=3.142;
        VelocityProj=zeros(1,stop);  % Projection velocity of the direction parrallel with the sight line
        VelocityTangential=zeros(1,stop);  % Projection velocity of the direction vertical to the sight line
        for i=1:stop
%             VelocityProj(1,i)=sind(Phi(i))*sind(Theta(i))*tand(VisualAngleHalf)/(r(i)*(1+tand(VisualAngleHalf)^2));
            VelocityTangential(1,i)=(1-sind(Phi(i))^2*sind(Theta(i))^2)^0.5/r(i);
        end
        InfChange=(VelocityTangential+VelocityProj).*Duration.*Velocity;    %InfChange=visual motion for all fixations
        %% Fixation Transition Matrix
        TranMatrix=zeros(AOINumber,AOINumber);   % Transition matrix enhanced by visual motion (Pij')
        TranMatrixCount=zeros(AOINumber,AOINumber);   % Transition matrix by fixation (Pij)
        TranMatrixDuration=zeros(AOINumber,AOINumber);    % Transition matrix by duration  (PDij)
        for t=1:stop-1
            TranMatrix(AOINumName(t,1),AOINumName(t+1,1))=TranMatrix(AOINumName(t,1),AOINumName(t+1,1))+InfChange(t);
            TranMatrixCount(AOINumName(t,1),AOINumName(t+1,1))=TranMatrixCount(AOINumName(t,1),AOINumName(t+1,1))+1;
            TranMatrixDuration(AOINumName(t,1),AOINumName(t+1,1))=TranMatrixDuration(AOINumName(t,1),AOINumName(t+1,1))+SaccadDuration(t);
        end
%         minnum=10^(-2);
%         TranMatrix(TranMatrix==0)=sum(TranMatrix(:)).*minnum;
%         TranMatrixCount(TranMatrixCount==0)=sum(TranMatrixCount(:)).*minnum;
        for i=1:AOINumber
            for j=1:AOINumber
                if (TranMatrixCount(i,j)>0 && TranMatrixDuration(i,j)>0)
                    TranMatrixDuration(i,j)=TranMatrixCount(i,j)/TranMatrixDuration(i,j);
                end
            end
        end
        if sum(sum(TranMatrix(:,:)))>0
            TranMatrix=TranMatrix./sum(TranMatrix(:));
            TranMatrixCount=TranMatrixCount./sum(TranMatrixCount(:));
        end
        %% AOI distribution by information varies and showing up frequency respectively
        InfDistribution=sum(TranMatrix,1)'; % Information varies (Pi')
        AOIDistribution=sum(TranMatrixCount,1)';
%         InfDistribution=zeros(AOINumber,1); % Information varies (Pi')
%         AOIDistribution=zeros(AOINumber,1); % Frequency (Pi)
%         for sceneNo=1:AOINumber
%             for i=1:stop
%                 if (AOINumName(i,1)==sceneNo)
%                     InfDistribution(sceneNo)=InfDistribution(sceneNo)+InfChange(1,i);
%                     AOIDistribution(sceneNo)=AOIDistribution(sceneNo)+1;
%                 end
%             end
%         end
%         % Normalization
%         InfDistribution=InfDistribution./sum(InfDistribution(:));
%         AOIDistribution=AOIDistribution./sum(AOIDistribution(:));
        %% SGE(Stationary gaze entropy) of Pi and Pi'
        SGEEnhanced=Entropy(InfDistribution,AOIAmount(stop));
        SGE=Entropy(AOIDistribution,AOIAmount(stop));
        %% Saccad 3D angle from one fixation to another
        SaccadAngle=zeros(1,1);
        for i=1:stop-1
            x1=sind(Theta(i))*cosd(Phi(i));
            y1=sind(Theta(i))*sind(Phi(i));
            z1=cosd(Theta(i));
            x2=sind(Theta(i+1))*cosd(Phi(i+1));
            y2=sind(Theta(i+1))*sind(Phi(i+1));
            z2=cosd(Theta(i+1));
            SaccadAngle(i)=acosd((x1*x2+y1*y2+z1*z2)/((x1^2+y1^2+z1^2)^0.5*(x2^2+y2^2+z2^2)^0.5));
        end
        SaccadAmp=sum(SaccadAngle)/(stop-1);
        %% ER(Entropy Rate) = Pij Entropy * Sigma(PDij)
        TranSGE=Entropy(TranMatrixCount,AOIAmount(stop-1));
        ER=TranSGE*sum(TranMatrixDuration(:));
        %% JSD between Pi and Pi'
        AOIJSD=JSD(InfDistribution,AOIDistribution);    %visual scanning efficiency (VSE)
        %% JSD between Pij and Pij'
        TranJSD=JSD(TranMatrix,TranMatrixCount);
        %% GTE(Gaze Transition Entropy)
        % Normalization in line to fit GTE's computation
        for i=1:AOINumber
            if sum(sum(TranMatrixCount(i,:)))>0
                TranMatrixCount(i,:)=TranMatrixCount(i,:)./sum(sum(TranMatrixCount(i,:)));
            end
        end
        TranEntropy=zeros(AOINumber,1);
        for i=1:AOINumber
            TranEntropy(i)=Entropy(TranMatrixCount(i,:),AOIAmount(stop));
        end
        GTE=sum(TranEntropy.*AOIDistribution);
        %% Data
%         Uniform=zeros(AOINumber,1);
%         Uniform(1:AOINumber,1)=1/AOINumber;
%         DataM(pNo,:,sNo)=[log2(AOIJSD)/log2(TranJSD),AOIJSD,GTE,SGE,ER,FR,TranSGE,SaccadAmp(stop-1),(stop-1)/sum(Acceleration)]; %std(Velocity)
%         DataM(pNo,:,sNo)=[2.^log2(AOIJSD)/2.^log2(TranJSD),TranJSD,AOIJSD,GTE,SGE,ER,FR,TranSGE,(stop-1)/sum(Acceleration)]; %std(Velocity)
          DataM(pNo,:,sNo)=[2.^TranSGE,TranJSD,AOIJSD,GTE,SGE,ER,FR,TranSGE,(stop-1)/sum(Acceleration)]; %std(Velocity)
%         DataSA(pNo,:,sNo)=[SaccadAmp(stop-1)]; %del SGE PZ
        %log2(AOIJSD)/log2(TranJSD)=cognitive load measure(CEM);AOIJSD=VSE;
    end
end
%% Saving data by different scenes respectively
save(['C:\Users\knight\Desktop\master\data\DrivingDataAnalysis\Efficiency\DataAnalysis\','DataM.mat'],'DataM');
Day=DataM(:,:,1);
save(['C:\Users\knight\Desktop\master\data\DrivingDataAnalysis\Efficiency\DataAnalysis\','Day.mat'],'Day');
DuskOn=DataM(:,:,2);
save(['C:\Users\knight\Desktop\master\data\DrivingDataAnalysis\Efficiency\DataAnalysis\','DuskOn.mat'],'DuskOn');
DuskOff=DataM(:,:,3);
save(['C:\Users\knight\Desktop\master\data\DrivingDataAnalysis\Efficiency\DataAnalysis\','DuskOff.mat'],'DuskOff');
Night=DataM(:,:,4);
save(['C:\Users\knight\Desktop\master\data\DrivingDataAnalysis\Efficiency\DataAnalysis\','Night.mat'],'Night');
