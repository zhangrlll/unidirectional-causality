%%  Surrogate Series
function [SS] = Surrogate (Origin)
line=size(Origin,1);
NewOrder=randperm(line);
SS=Origin(NewOrder,:);