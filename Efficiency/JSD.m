%% Distance
InfDistE2O=zeros(1,lenName);
InfDistO2E=zeros(1,lenName);
UnionProb=zeros(len,len);
for FixNo=1:lenName
    for i=1:len
        if (InfChange(i,FixNo)~=0 && InfCount(i,FixNo)~=0)
            InfDistE2O(FixNo)=InfDistE2O(FixNo)+InfChange(i,FixNo)*log2(InfChange(i,FixNo)/InfCount(i,FixNo));
            InfDistO2E(FixNo)=InfDistO2E(FixNo)+InfCount(i,FixNo)*log2(InfCount(i,FixNo)/InfChange(i,FixNo));
        end
    end
    InfDistE2O(FixNo)=InfDistE2O(FixNo)/log2(ScenesNumber(FixNo));
    InfDistO2E(FixNo)=InfDistO2E(FixNo)/log2(ScenesNumber(FixNo));
end
InfJSD=0.5*(InfDistE2O+InfDistO2E);
%% Probability Entropy
PEDistE2O=zeros(1,lenName-1);
PEDistO2E=zeros(1,lenName-1);
for FixNo=1:lenName-1
    for i=1:len
        for j=1:len
            if (TranMatrix(i,j,FixNo)~=0 && TranMatrixCount(i,j,FixNo)~=0)
                PEDistE2O(FixNo)=PEDistE2O(FixNo)+TranMatrix(i,j,FixNo)*log2(TranMatrix(i,j,FixNo)/TranMatrixCount(i,j,FixNo));
                PEDistO2E(FixNo)=PEDistO2E(FixNo)+TranMatrixCount(i,j,FixNo)*log2(TranMatrixCount(i,j,FixNo)/TranMatrix(i,j,FixNo));
            end
        end
    end
    PEDistE2O(FixNo)=InfDistE2O(FixNo)/log2(ScenesNumber(FixNo));
    PEDistO2E(FixNo)=InfDistO2E(FixNo)/log2(ScenesNumber(FixNo));
end
PEJSD=0.5*(PEDistE2O+PEDistO2E);
aINFJSD=mean(InfJSD);
aTEDJSD=mean(PEJSD);
%% Results

hold on
plot(InfJSD)
plot(PEJSD)