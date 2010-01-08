function dist=jensen_shannon(P,Q, nbins)
% dist=jensen_shannon(P,Q, nbins)
%
%Calculates the jensen_shannon divergence between the P and Q random
%variables. The p.d.fs are estimated by histogramming both variables with
%the number of bins given in 'nbins'.
%
  
  xmin = min([P Q]);
  xmax = max([P Q]);
  res = abs(xmax - xmin) / nbins;
  
  xbins = xmin:res:xmax-res;
  P = histc(P,xbins);
  Q = histc(Q,xbins);
  
  
  % normalizing the P and Q
  Q = Q ./ sum(Q);
  P = P ./ sum(P);
  M = mean([P;Q]);
  d1 =  safe_sum(P.*log(P./M));
  d2 =  safe_sum(Q.*log(Q./M));

  dist = (d1 + d2) / 2;


function d = safe_sum(d)
  d(isnan(d))=0;% resolving the case when P(i)==0
  d(isinf(d))=0;% resolving the case when Q(i)==0
  d = sum(d);
