%% Normalised Entropy
function [e] = Entropy(P)
P(P==0)=eps;
P=-P.*log2(P);
% size=length(P(:));
% e = sum(P(:)) / log2(size);
e = sum(P(:));