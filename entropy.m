function h = entropy(data, p, mode, nPoints, doDif)
%function h = entropy(data, p, mode, nPoints, doDif)
%Calcula a entropia.
% - data: realizacoes da variavel aleatoria (uma variavel por linha).
%         Maximo de 2 variaveis aleatorias.
% - p : um vetor (ou matriz) de probabilidades pre-calculadas. Neste caso,
%       data ddeve ser []. p pode ser SOMENTE uma MDF (discreta).
% - mode : modo p/ estimar a PDF. Pode ser 'hist' ou 'kernel' (default).
% - nPoints : Numero de pontos da PDF p/ estimar. Default = 128.
% - doDif : Se false, calcula a MDF (discreta). Se true, calcula a PDF
%           continua. Default = false.
%
% A funcao retorna a entropia calculada, em nats.
%
  
  if nargin < 2, p = []; end
  if nargin < 3, mode = 'kernel'; end
  if nargin < 4, nPoints = 128; end
  if nargin < 5, doDif = false; end
  

  %We must estimate the pdf
  if isempty(p),
    [p, x, y] = est_pdf(data, mode, nPoints, doDif);
  end
  
  %Calculo a entropia considerando so os valores > 0 p/ evitar valor
  %infinito do log. Valores < 0 podem acontecer por problemas de precisao
  %numerica (ex: -1e-12). Vou descartar esses caras tb, considerando que
  %sao ~= 0.
  p = p(p > 0);
  h = -sum(p .* log(p)); %Results are in nats!
  
  %Se for p/ calcular a entropia deferencial
  if doDif,
    if size(data,1) == 1,
      h = abs(x(2)-x(1)) * h;
    else
      h = abs(x(1,2)-x(1,1)) * abs(y(2,1)-y(1,1)) * h;
    end
  end
  