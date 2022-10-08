%%  Surrogate Series
function [SS] = Surrogate (Origin)  % currently random shuffle
line=size(Origin,1);
NewOrder=randperm(line);
SS=Origin(NewOrder,:);