%% Joint Distribution
function [hist] = JointDist(bins,x,xHistory,y,yHistory)
BinUpper=floor(log10(bins))+1;
len=size(x,1);
histlen=[num2str(bins)];
for i=2:1+xHistory+yHistory
    histlen=strcat(num2str(bins),histlen);
end
histlen=str2num(histlen);
hist=zeros(1,histlen);
xmax=max(x);xmin=min(x);
ymax=max(y);ymin=min(y);
dx=(xmax-xmin)/bins;
dy=(ymax-ymin)/bins;
xtLabel=zeros(len,1);
xhLabel=zeros(1,xHistory);
yhLabel=zeros(1,yHistory);
for i=1+max(xHistory,yHistory):len
    for xb=1:bins
        if ( x(i)>=xmin+(xb-1)*dx && x(i)<=xmin+(xb)*dx )
            xtLabel=xb;
            break;
        end
    end
    if xtLabel==0
        if abs(x(i)-xmin)>abs(x(i)-xmax)
            xtLabel=bins;
        else
            xtLabel=1;
        end
    end
    xtL=N2SDZ(xtLabel,BinUpper);
    % x history
    xhL=nan;
    for j=1:xHistory
        for xb=1:bins
            if ( x(i-j)>=xmin+(xb-1)*dx && x(i-j)<=xmin+(xb)*dx )
                xhLabel(1,j)=xb;
                break;
            end
        end
        if xhLabel(1,j)==0
            if abs(x(i-j)-xmin)>abs(x(i-j)-xmax)
                xhLabel(1,j)=bins;
            else
                xhLabel(1,j)=1;
            end
        end
        if j==1
            xhL=N2SDZ(xhLabel(1,j),BinUpper);
            continue;
        end
        xhL=strcat(N2SDZ(xhLabel(1,j),BinUpper),xhL);
    end
    % y history
    yhL=nan;
    for j=1:yHistory
        for yb=1:bins
            if ( y(i-j)>=ymin+(yb-1)*dy && y(i-j)<=ymin+(yb)*dy )
                yhLabel(1,j)=yb;
                break;
            end
        end
        if yhLabel(1,j)==0
            if abs(y(i-j)-ymin)>abs(y(i-j)-ymax)
                yhLabel(1,j)=bins;
            else
                yhLabel(1,j)=1;
            end
        end
        if j==1
            yhL=N2SDZ(yhLabel(1,j),BinUpper);
            continue;
        end
        yhL=strcat(N2SDZ(yhLabel(1,j),BinUpper),yhL);
    end
    index=str2num(strcat(yhL,xhL,xtL));
    hist(1,index)=hist(1,index)+1;
end
delete=zeros(1,1);j=1;
for i=1:histlen
    ss=N2SDZ(i,BinUpper*(xHistory+yHistory+1));
    for k=1:xHistory+yHistory+1
        if str2num(ss((xHistory+yHistory+1-k)*BinUpper+1:(xHistory+yHistory+1-k+1)*BinUpper))>bins
            delete(1,j)=i;
            j=j+1;
            break;
        end
        if str2num(ss((xHistory+yHistory+1-k)*BinUpper+1:(xHistory+yHistory+1-k+1)*BinUpper))==0
            delete(1,j)=i;
            j=j+1;
            break;
        end
    end
end
hist(delete(1,:))=[];
newshape=zeros(1,1+xHistory+yHistory);
newshape(:)=bins;
hist=reshape(hist,newshape);
hist=hist+eps;
hist=hist./sum(hist(:));

