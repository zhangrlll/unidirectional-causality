% Pupil dilation for windows
function [PD]= PupilDilation (pupilsize,halfwidth)
len=size(pupilsize);
PD=pupilsize-mean(pupilsize);



% % window
% for i=1:halfwidth
%     PD(i)=pupilsize(i)-mean(pupilsize(1:i+halfwidth));
% end
% for i=halfwidth+1:len-halfwidth
%     PD(i)=pupilsize(i)-mean(pupilsize(i-halfwidth+1:i+halfwidth));
% end
% for i=len-halfwidth+1:len
%     PD(i)=pupilsize(i)-mean(pupilsize(i+halfwidth+1:len));
% end