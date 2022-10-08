load('DataM.mat', 'DataM');
for sNo=1:4
    for pNo=1:14
        stop=floor((lenName-1)*0.4);
        DataM(pNo,:,sNo)=[TIO(stop),TIS(stop),TIC(stop),TI(stop),PEJSD(stop),InfJSD(stop+1),InfJSD(stop+1)/PEJSD(stop),HS(stop+1),H(stop),1/ASpeed(stop)*stop];%mean(AcceleratedSpeed)
    end
end
Day=DataM(:,:,1);
save(['D:\DrivingAny\DataAnalysis\','Day.mat'],'Day');
DuskOn=DataM(:,:,2);
save(['D:\DrivingAny\DataAnalysis\','DuskOn.mat'],'DuskOn');
DuskOff=DataM(:,:,3);
save(['D:\DrivingAny\DataAnalysis\','DuskOff.mat'],'DuskOff');
Night=DataM(:,:,4);
save(['D:\DrivingAny\DataAnalysis\','Night.mat'],'Night');