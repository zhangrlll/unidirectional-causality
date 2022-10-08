%% Grid
function [hist] = Grid(x,xHistory,bins)
hist=zeros(1,bins);
xmax=max(x);xmin=min(x);
d=(xmax-xmin)/bins;
len=size(x);
for i=len-xHistory+1:len
    for j=1:bins
        if (x(i)<=xmin+j*d && x(i)>xmin+(j-1)*d)
            hist(j)=hist(j)+1;
            break;
        end
    end
end
hist=hist./sum(hist);