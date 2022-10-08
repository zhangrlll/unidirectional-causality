%% Transfer Entropy
% bin is bins in per X. X vector contains no more than 2-d when SourceLen=1 & TargetLen=1 (joint pdf's dimension no more than 6).
% SurrogateTimes obtained by Chebyshev's inequality and 2-sided test.
% by sldz zezhonglv0306@gmail.com
%% TE Computation
bin=5;  %
%PupilWindowHalfWidth=5;
% m=100;
% k=6;    % sigma test
% a=1/k^2;
SurrogateTimes=73;% N_{S} confidence level=97.3%    2/a-1;
SourceLen=1;TargetLen=1;
ScenesName={'Day';'DuskOn';'DuskOff';'Night'};  %4 scenes in all
% Data=zeros(4,8,14);
Data_lamda = zeros(48,1);
% for sNo=3:3 %number (#) of scene, 1~4 corresponding to 4 scenes
%     CurrentSceneName=ScenesName{sNo};
%     for pNo=5:5 % number of participant
for sNo=1:4
    CurrentSceneName=ScenesName{sNo};
    for pNo=3:14
        FileName=['..\EyeHeadDirc\',num2str(pNo),CurrentSceneName,'.xlsx'];
        Vec=xlsread(FileName,'AI:AM');  % excel data files AI:AM columns (including eye movement data)
        len=floor(1*size(Vec,1));

        EyeTheta=Vec(1:len,1);  %its range is [-90 degree,90 degree]
        EyePhi=Vec(1:len,2);  %its range is [-90 degree,90 degree]
%         HeadTheta=Vec(1:len,4);
%         HeadPhi=Vec(1:len,5);
        
        HeadVec=xlsread(FileName,'V:X');     % excel data files V:X columns (including head motion data)
        HeadTheta=90-atand( HeadVec(:,2)./HeadVec(:,3) );   % do translation on head values so that ranges of head and eye become the same
        HeadPhi=90-atand( HeadVec(:,1)./HeadVec(:,3) );
        
%         PupilSize=xlsread(FileName,'D:D');
%         PupilDila=PupilDilation(PupilSize,PupilWindowHalfWidth); 
%         CarVec=xlsread(FileName,'M:O');
%         CarPhi=atand( 90- CarVec(:,3)./CarVec(:,1) );
        
%         %filter
%         bandw=13;%floor(len*0.003); % odd band width
%         method='moving';    % moving lowess loess sgolay rlowess rloess
%         EyeTheta=smooth(EyeTheta,bandw,method);
%         EyePhi=smooth(EyePhi,bandw,method);
%         HeadTheta=smooth(HeadTheta,bandw,method);
%         HeadPhi=smooth(HeadPhi,bandw,method);
        
%         EyeTheta=EyeTheta(2:len)-EyeTheta(1:len-1);
%         EyePhi=EyePhi(2:len)-EyePhi(1:len-1);
%         HeadTheta=HeadTheta(2:len)-HeadTheta(1:len-1);
%         HeadPhi=HeadPhi(2:len)-HeadPhi(1:len-1);
        
%         %normalization
%         EyeTheta=EyeTheta./max(EyeTheta);
%         EyePhi=EyePhi./max(EyePhi);
%         HeadTheta=HeadTheta./max(HeadTheta);
%         HeadPhi=HeadPhi./max(HeadPhi);
        
        HeadState=[HeadPhi,HeadTheta];%PupilDila
        EyeState=[EyePhi,EyeTheta];
        
        [TEEye2Head,EREye2Head]=TransferEntropy(bin,EyeState,SourceLen,HeadState,TargetLen);
        [TEHead2Eye,ERHead2Eye]=TransferEntropy(bin,HeadState,SourceLen,EyeState,TargetLen);
        
        %% Surrogate
        SE2H=zeros(1,SurrogateTimes);
        SH2SE=zeros(1,SurrogateTimes);
        SH2E=zeros(1,SurrogateTimes);
        SE2SH=zeros(1,SurrogateTimes);
        for st=1:SurrogateTimes
            SE=Surrogate(EyeState); % surrogate time series of eye movement (currently, surrogate=randomly shuffling)
            SH=Surrogate(HeadState); % surrogate time series of head motion
            [SE2SH(1,st),ERSE2SH]=TransferEntropy(bin,SE,SourceLen,SH,TargetLen);   % SE to SH transfer entropy
            [SH2SE(1,st),ERSH2SE]=TransferEntropy(bin,SH,SourceLen,SE,TargetLen);
            [SE2H(1,st),ERSE2H]=TransferEntropy(bin,SE,SourceLen,HeadState,TargetLen);
            [SH2E(1,st),ERSH2E]=TransferEntropy(bin,SH,SourceLen,EyeState,TargetLen);
        end
        %% Normalised TE
        TEE2HBiasRemoved=(TEEye2Head-mean(SE2H))/EREye2Head;
        TEH2EBiasRemoved=(TEHead2Eye-mean(SH2E))/ERHead2Eye;
%         TEE2H=(TEEye2Head-TEHead2Eye)/(EREye2Head+ERHead2Eye);
%         TEH2E=(TEHead2Eye-TEEye2Head)/(EREye2Head+ERHead2Eye);
        %% Significance test
        sE2H=(TEEye2Head-TEHead2Eye-mean(SE2SH-SH2SE))/std(SE2SH-SH2SE);
        sH2E=(TEHead2Eye-TEEye2Head-mean(SH2SE-SE2SH))/std(SH2SE-SE2SH);
%         if TEHead2Eye-TEEye2Head>=0
%             if ( ( (TEHead2Eye-TEEye2Head) <= (max(SH2E)-min(SE2H)) ) && ( (TEEye2Head-TEHead2Eye)>=min(SH2E)-max(SE2H) ) )
%                 sH2E=0;
%             else
%                 sH2E=1;
%             end
%             sE2H=-1;
%         else
%             if ( ( (TEEye2Head-TEHead2Eye) <= (max(SE2H)-min(SH2E)) ) && ( (TEEye2Head-TEHead2Eye)>=min(SE2H)-max(SH2E) ) )
%                 sE2H=0;
%             else
%                 sE2H=1;
%             end
%             sH2E=-1;
%         end
        %% data
%         Data(sNo,:,pNo)=[TEEye2Head,EREye2Head,TEE2HBiasRemoved,sE2H,TEHead2Eye,ERHead2Eye,TEH2EBiasRemoved,sH2E];  % output result
        Data(sNo,:,pNo)=[TEE2HBiasRemoved,TEHead2Eye,ERHead2Eye,TEH2EBiasRemoved,sE2H,sH2E];  % output result
         %% Stationary test
%         dm=floor(len/m);
%         i=1;j=1;
%         TEE2H=zeros(1,1);
%         TEH2E=zeros(1,1);
%         while 1
%             TEE2H(1,j)=TransferEntropy(bin,[EyePhi(i:i+dm-1),EyeTheta(i:i+dm-1)],SourceLen,[HeadPhi(i:i+dm-1),HeadTheta(i:i+dm-1)],TargetLen);
%             TEH2E(1,j)=TransferEntropy(bin,[HeadPhi(i:i+dm-1),HeadTheta(i:i+dm-1)],SourceLen,[EyePhi(i:i+dm-1),EyeTheta(i:i+dm-1)],TargetLen);
%             i=i+dm;
%             j=j+1;
%             if i+dm>=len
%                 break;
%             end
%         end
%         sigE2H=abs(TEEye2Head-TEHead2Eye-mean(TEE2H-TEH2E))/std(TEE2H-TEH2E);
%         sigH2E=abs(TEHead2Eye-TEEye2Head-mean(TEH2E-TEE2H))/std(TEH2E-TEE2H);
    end
end