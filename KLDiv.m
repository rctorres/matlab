% dist=KLDiv(P,Q, res);
%
%Calculates the Kullback-Leibler divergence between the P and Q random
%variables. The p.d.fs are estimated by histogramming both variables with
%the resolution given in 'res'.
%

function dist=KLDiv(P,Q, res);
  
  xmin = min([P Q]);
  xmax = max([P Q]);
  xbins = xmin:res:xmax-res;
  P = histc(P,xbins);
  Q = histc(Q,xbins);
  
  
  % normalizing the P and Q
  Q = Q/sum(Q);
  P = P/sum(P);
  temp =  P.*log(P./Q);
  temp(isnan(temp))=0;% resolving the case when P(i)==0
  temp(isinf(temp))=0;% resolving the case when Q(i)==0
  dist = sum(temp);

end


