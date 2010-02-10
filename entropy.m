function h = entropy(data, p, mode, nPoints)
%function h = entropy(data, p, mode, nPoints)
  
  if nargin < 2, p = []; end
  if nargin < 3, mode = 'kernel'; end
  if nargin < 4, nPoints = 128; end

  %We must estimate the pdf
  if isempty(p),   
    p = est_pdf(data, mode, nPoints);
  end
  
  %Calculo a entropia considerando so os valores > 0 p/ evitar valor
  %infinito do log. Valores < 0 podem acontecer por problemas de precisao
  %numerica (ex: -1e-12). Vou descartar esses caras tb, considerando que
  %sao ~= 0.
  p = p(p > 0);
  h = -sum(p .* log2(p)); %Results are in bits!
