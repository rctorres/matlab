function h = entropy(data, p, mode, nPoints)
  
  if nargin < 2, p = []; end
  if nargin < 3, mode = 'kernel'; end
  if nargin < 4, nPoints = 128; end

  if size(data,1) == 1,
    u = data(1,:);
    v = [];
  elseif size(data,1) == 2,
    u = data(1,:);
    v = data(2,:);
  elseif isempty(data),
    if nargin < 2,
     error('You must provide either a data or a pdf value.');
    end
  end

  if isempty(p), %We must estimate the pdf   
    %Calculando a estimativa da PDF pelo modo desejado.
    if strcmp(mode, 'hist'),
      p = get_pdf_by_hist(u, v, nPoints);
    elseif strcmp(mode, 'kernel'),
      p = get_pdf_by_kernel(u, v, nPoints);
    else
      error('Invalid mode! See help for options.')
    end    
  end
  
  %Calculo a entropia considerando so os valores > 0 p/ evitar valor
  %infinito do log. Valores < 0 podem acontecer por problemas de precisao
  %numerica (ex: -1e-12). Vou descartar esses caras tb, considerando que
  %sao ~= 0.
  p = p(p > 0);
  h = -sum(p .* log2(p)); %Results are in bits!


function p = get_pdf_by_hist(u,v,nPoints)
  if isempty(v),
    p = hist(u, nPoints);
  else
    desc = [min(u) max(u), nPoints; min(v), max(v), nPoints];
    p = histogram2(u,v,desc);
  end
  
  %Normalizando p/ o somatorio ser 1.
  p = p ./ sum(sum(p));

  
  
function p = get_pdf_by_kernel(u,v,nPoints)
  if isempty(v),
    p = ksdensity(u, 'npoints', nPoints);
  else
    [b,p] = kde2d([u;v]', nPoints);
  end
