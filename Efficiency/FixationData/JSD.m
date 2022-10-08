%% Jensen-Shannon divergence
function [jsd] = JSD(P,Q)
M=(P+Q)/2;
jsd=(KLD(P,M)+KLD(Q,M))/2;