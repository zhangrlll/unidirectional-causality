%% Transfer from Number to String with default '0'
function [s] = N2SDZ(a,zeroUpper)
s=[];
for exp=1:zeroUpper
    if a<power(10,exp)
        if exp==zeroUpper
            s=num2str(a);
            break;
        end
        for zerodefault=1:zeroUpper-exp
            s=strcat('0',s);
        end
        s=strcat(s,num2str(a));
        break;
    end
end