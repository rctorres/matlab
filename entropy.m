function h = entropy(data, doDif, nPoints, mode)
%function h = entropy(data, doDif, nPoints, mode)
%Calcula a entropia.
% - data: Se for uma matriz, de conter as realizacoes da variavel 
%         aleatoria (uma variavel por linha).Maximo de 2 variaveis 
%         aleatorias. Se ao inves de realizacoes, vc quiser passar uma PDF
%         ou MDF previamente calculada, data deve ser uma estrutura
%         contendo os seguintes campos:
%         - p : o valor da probabildiade em cada ponto onde ela 
%               foi estimada.
%         - x : Vetor (1 var. aleatoria) ou matriz (2 var aleatorias) 
%               com os pontos de x onde a probabilidade foi estimada.
%         - y : omitido (1 var. aleatoria) ou matriz (2 var aleatorias) 
%               com os pontos de y onde a probabilidade foi estimada.
%         Se vc passar a PDF ja calculada, os parametros mode e nPoints sao
%         ignorados. x e y, na estrutura, so precisam ser definidos se a
%         entropia for diferencial.
% - doDif : Se false, calcula a MDF (discreta). Se true, calcula a PDF
%           continua. Default = false.
% - nPoints : Numero de pontos da PDF p/ estimar. Default = 128.
% - mode : modo p/ estimar a PDF. Pode ser 'hist', 'em' ou 'kernel' (default).
%
% A funcao retorna a entropia calculada, em nats.
%

  if nargin < 2, doDif = false; end
  if nargin < 3, nPoints = 128; end
  if nargin < 4, mode = 'kernel'; end
  

  %We must estimate the pdf
  if isstruct(data),
    p = data.p;
    if isfield(data, 'x'), x = data.x; end
    if isfield(data, 'y'), y = data.y; end
  else
    [p, x, y] = est_pdf(data, doDif, nPoints, mode);
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
  