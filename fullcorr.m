function c = fullcorr(doPlot, A, MA, B, MB)
%function c = fullcorr(doPlot, A, MA, B, MB)
%Faz a analise completa entre duas bases (MA e MB) e suas projecoes
%(A e B). Para as bases, cada vetor de base deve ser uma linha. Para as
%projecoes cada variavel aleatoria e uma linha, e as colunas, as
%realizacoes de cada variavel. A funcao retorna uma estrutura com
%as seguintes analises:
%  - ang : Angulo entre as direcoes (normalizados p/ ficarem entre 0 e 90).
%  - corr: Coeficiente de correlacao linear entre as projecoes.
%  - dist: Distancia de Jensen-Shannon entre as projecoes.
% - im: Informacao mutua entre as projecoes.
%
% Caso B e MB sejam omitidos, sera equivalente a fazer fullcorr(doPlot, A, MA, A, MA)
%doPlot, se true, plotara o pcolor com o resultados das analises.
%

  if nargin == 3,
    B = A;
    MB = MA;
  end

  A = A';
  B = B';

  %1) Angulo entre as direcoes
  c.ang = calcAngles(MA', MB', true);

  %2) Correlacao linear entre as duas bases.
  c.corr = do_corr(A, B, @corrcoef, false);

  %3) Informacao Mutua
  c.im = do_corr(A, B, @mutual_info, true);

  %4) Distancia de Jensen-Shanon
  c.dist = do_corr(A, B, @js_div, false);


  if doPlot,
    figure;
    subplot(2,2,1);
    pcolor(format(c.ang));
    title('Angulos entre os Vetores da Base');
    xlabel('MB');
    ylabel('MA');
    colorbar;

    subplot(2,2,2);
    pcolor(format(c.corr));
    title('Correlacao Linear entre as Projecoes');
    xlabel('B');
    ylabel('A');
    colorbar;

    subplot(2,2,3);
    pcolor(format(c.im));
    title('Inf. Mutua entre as Projecoes');
    xlabel('B');
    ylabel('A');
    colorbar;

    subplot(2,2,4);
    pcolor(format(c.dist));
    title('Dist. Jensen-Shannon entre as Projecoes');
    xlabel('B');
    ylabel('A');
    colorbar;
  end


function res = mutual_info(mat)
  res = [0 information(mat(:,1)', mat(:,2)')];

  
function res = js_div(mat)
  N = 100;
  x = mat(:,1)';
  y = mat(:,2)';
  d = jensen_shannon(x,y,N);
  res = [0 d];

  
function c = do_corr(A, B, func, doNorm)
  nComp = size(A,2);
  c = zeros(nComp);
  
  %Como correlacao e sempre simetrica, eu poupo tempo fazendo so a metade
  %dos calculos
  for i=1:nComp,
    for j=i:nComp,
      aux = func([A(:,i), B(:,j)]);
      c(i,j) = abs(aux(1,2));
    end
    
    if doNorm,
      c(i,i:end) = c(i,i:end) ./ max(c(i,i:end));
    end
  end
  %Componho a matriz final colocando a transposta da matriz na parte
  %inferior.
  c = triu(c) + tril(c',-1);


function m = format(m)
  m = [m m(:,end)];
  m = [m; m(end,:)];
  