function c = mutual_info(m, doNorm, doDif, nPoints, mode)
%function c = mutual_info(m, doNorm, doDif, nPoints, mode)
%Calcula a matriz de informacao mutua entre variaveis.
% - m: Matriz com a realizacao das N variaveis aleatorias (uma variavel por
%      COLUNA)
% - doNorm : Se true, normaliza a Inf. Mutua p/ ficar entre [0,1] fazendo 
%            1 - exp(-2IM).
% - doDif : Se false, calcula a MDF (discreta). Se true, calcula a PDF
%           continua. Default = false.
% - nPoints : Numero de pontos da PDF p/ estimar. Default = 128.
% - mode : modo p/ estimar a PDF. Pode ser 'hist' ou 'kernel' (default).
%
% A funcao retorna uma matriz [NxN] com a Informacao Mutua (em nats)
% entre as variaveis aleatorias.
%

  if nargin < 2, doNorm = false; end;
  if nargin < 3, doDif = false; end;
  if nargin < 4, nPoints = 128; end;
  if nargin < 5, mode = 'kernel'; end;

  m = m';
  [M,N] = size(m);
  c = zeros(M);

  for i=1:M,
    x = m(i,:);
    for j=i:M,
      y = m(j,:);
      hx = entropy(x, doDif, nPoints, mode);
      hy = entropy(y, doDif, nPoints, mode);
      hxy = entropy([x;y], doDif, nPoints, mode);
      c(i,j) = hx + hy - hxy;
    end    
  end
    
  %Componho a matriz final colocando a transposta da matriz na parte
  %inferior.q
  c = triu(c) + tril(c',-1);

  if doNorm,
    c = 1 - exp(-2*c);
  end
