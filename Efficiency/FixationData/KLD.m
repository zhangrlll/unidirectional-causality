%% Kullback-Leibler divergence
function [kld] = KLD(P,Q)
P(P==0)=eps;
Q(Q==0)=eps;
kld=sum(sum(P.*log2(P./Q)));