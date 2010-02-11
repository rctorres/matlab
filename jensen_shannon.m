function dist=jensen_shannon(P,Q)
% dist=jensen_shannon(P,Q)
%
%Calculates the jensen_shannon divergence between the P and Q distributions
%The p.d.fs can be estimated using the est_pdf method. P and Q must be row vectors.
%
  M = mean([P;Q]);
  d1 =  safe_sum(P.*log(P./M));
  d2 =  safe_sum(Q.*log(Q./M));

  dist = (d1 + d2) / 2;


function d = safe_sum(d)
  d(isnan(d))=0;% resolving the case when P(i)==0
  d(isinf(d))=0;% resolving the case when Q(i)==0
  d = sum(d);
