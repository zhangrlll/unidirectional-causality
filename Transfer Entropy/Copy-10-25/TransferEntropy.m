%% Transfer Entropy
function [TE,EntropyRate] = TransferEntropy(bin,Source,SHistory,Target,THistory)
TargetLen=size(Target,1);
SourceLen=size(Source,1);
xwidth=size(Target,2);
% Source=Norm(Source,SourceLen);
% Target=Norm(Target,TargetLen);
% HistTarget=Grid(Target,THistory,bin);
jointLen=TargetLen-max(SHistory,THistory);
xt=Target(TargetLen-jointLen+1:TargetLen,:);
xh=zeros(jointLen,THistory*xwidth);
for i=1:THistory
    xh(:,(i-1)*xwidth+1:i*xwidth)=Target(TargetLen-jointLen-i+1:TargetLen-i,1:xwidth);
end
ywidth=size(Source,2);
yh=zeros(jointLen,SHistory*ywidth);
for i=1:SHistory
    yh(:,(i-1)*ywidth+1:i*ywidth)=Source(SourceLen-jointLen-i+1:SourceLen-i,1:ywidth);
end
HistJoint=JointP(bin,[xt,xh,yh]);
% HistTargetJointTargetHistory=squeeze(sum(HistJoint,3));
% HistTargetHistory=squeeze(sum(HistTargetJointTargetHistory,2));
% HistTargetHistoryJointSourceHistory=squeeze(sum(HistJoint,1));
HistTargetHistory=JointP(bin,xh);
HistTargetHistoryJointSourceHistory=JointP(bin,[xh,yh]);
HistTargetJointTargetHistory=JointP(bin,[xt,xh]);
EntropyRate=Entropy(HistTargetJointTargetHistory)-Entropy(HistTargetHistory);
TE=Entropy(HistTargetHistoryJointSourceHistory)+Entropy(HistTargetJointTargetHistory)-Entropy(HistTargetHistory)-Entropy(HistJoint);
