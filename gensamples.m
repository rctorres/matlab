function ret = gensamples(p, x, N)
%function ret = gensamples(p, x, N)
% Gera N realizacoes de uma variavel aleatoria x, regida pela PDF p.
%

  %Este trecho de codigo e p/ evitar descontinuidades na PDF, o que arruina
  %o calculo da integral abaixo.
  I = find(p == 0);
  for i=1:length(I),
    idx = I(i);
    p(idx) = 0.1*mean([p(idx-1) p(idx+1)]);
  end

  %Callulando a CDF
  nPt = length(p);
  cdf = zeros(1,nPt);
  for i=1:nPt,
    cdf(i) = abs(x(2)-x(1)) * sum(p(1:i));
  end
  
  ret = interp1(cdf, x, rand(1, N), 'linear');
