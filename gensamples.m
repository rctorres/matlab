function ret = gensamples(p, x, N)
%function ret = gensamples(p, x, N)
% Gera N realizacoes de uma variavel aleatoria x, regida pela PDF p.
%
  
  %Callulando a CDF
  nPt = length(p);
  cdf = zeros(1,nPt);
  for i=1:nPt,
    cdf(i) = abs(x(2)-x(1)) * sum(p(1:i));
  end

  %Este trecho de codigo e p/ que o interp reclame que existem valores
  %repetidos.
  [cdf, I] = unique(cdf);
  
  ret = interp1(cdf, x(I), rand(1, N), 'linear');
