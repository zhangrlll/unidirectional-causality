%% Joint Probability Distribution
function [hist] = JointP(bins,x)
% maxdim=2;   % max dim
[len,width]=size(x);
Dimensions=zeros(1,width);  
Dimensions(1,:)=bins;
hist=zeros(Dimensions);
Labels=zeros(len,width);
for i=1:width
    xmax=max(x(:,i));xmin=min(x(:,i));
    dx=(xmax-xmin)/bins;
    for j=1:len
        for xb=1:bins
            if ( x(j,i)>=xmin+(xb-1)*dx && x(j,i)<=xmin+(xb)*dx )
                Labels(j,i)=xb;
                break;
            end
        end
        if Labels(j,i)==0
            if abs(x(j,i)-xmax) > abs(x(j,i)-xmin)
                Labels(j,i)=1;
            else
                Labels(j,i)=bins;
            end
        end
    end
end

if width==1
    hist=zeros(Dimensions,1);
    for i=1:len
        % change the number if max dim changes  ,Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6)
        hist(Labels(i,1))=hist(Labels(i,1))+1;
    end
end
if width==2
    for i=1:len
        % change the number if max dim changes  ,Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6)
%         hist(sub2ind(size(hist),Labels(i,1),Labels(i,2)))=hist(sub2ind(size(hist),Labels(i,1),Labels(i,2)))+1;
        hist(Labels(i,1),Labels(i,2))=hist(Labels(i,1),Labels(i,2))+1;
    end
end
if width==3
    for i=1:len
        % change the number if max dim changes  ,Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6)
%         hist(sub2ind(size(hist),Labels(i,1),Labels(i,2),Labels(i,3)))=hist(sub2ind(size(hist),Labels(i,1),Labels(i,2),Labels(i,3)))+1;
        hist(Labels(i,1),Labels(i,2),Labels(i,3))=hist(Labels(i,1),Labels(i,2),Labels(i,3))+1;
    end
end
if width==4
    for i=1:len
        % change the number if max dim changes  ,Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6)
%         hist(sub2ind(size(hist),Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4)))=hist(sub2ind(size(hist),Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4)))+1;
        hist(Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4))=hist(Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4))+1;
    end
end
if width==5
    for i=1:len
        % change the number if max dim changes  ,Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6)
%         hist(sub2ind(size(hist),Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4),Labels(i,5)))=hist(sub2ind(size(hist),Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4),Labels(i,5)))+1;
        hist(Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4),Labels(i,5))=hist(Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4),Labels(i,5))+1;
    end
end
if width==6
    for i=1:len
        % change the number if max dim changes  ,Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6)
%         hist(sub2ind(size(hist),Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6)))=hist(sub2ind(size(hist),Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6)))+1;
        hist(Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6))=hist(Labels(i,1),Labels(i,2),Labels(i,3),Labels(i,4),Labels(i,5),Labels(i,6))+1;
    end
end

hist=hist+eps;
hist=hist./sum(hist(:));