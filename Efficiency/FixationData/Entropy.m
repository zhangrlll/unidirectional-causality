%% Normalised Entropy
function [e] = Entropy(P,size)
P(P==0)=eps;
% size=numel(P);
e = sum(sum(-P.*log2(P))) / log2(size);