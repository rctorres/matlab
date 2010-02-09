function [p, x, y] = est_pdf(data, mode, nPoints)
  
  if nargin < 2, mode = 'kernel'; end
  if nargin < 3, nPoints = 128; end

  if size(data,1) == 1,
    u = data(1,:);
    v = [];
  elseif size(data,1) == 2,
    u = data(1,:);
    v = data(2,:);
  elseif isempty(data),
    if nargin < 2,
     error('You must provide data points.');
    end
  end

  if strcmp(mode, 'hist'),
    [p, x, y] = get_pdf_by_hist(u, v, nPoints);
  elseif strcmp(mode, 'kernel'),
    [p, x, y] = get_pdf_by_kernel(u, v, nPoints);
  else
    error('Invalid mode! See help for options.')
  end    


function [p, x, y] = get_pdf_by_hist(u,v,nPoints)
  if isempty(v),
    [p, x] = hist(u, nPoints);
    y = [];
    
    %Normalizando p/ a integral ser 1.
    p = p ./ (abs(x(2)-x(1)) * sum(p));
  else
    desc = [min(u) max(u), nPoints; min(v), max(v), nPoints];
    p = histogram2(u,v,desc);
    
    %Normalizando p/ a integral ser 1.
    x = linspace(desc(1,1), desc(1,2), desc(1,3));
    y = linspace(desc(2,1), desc(2,2), desc(2,3));
    p = p ./ ( abs( (x(2)-x(1)) * (y(2)-y(1)) ) * sum(sum(p)) );
    x = repmat(x,nPoints,1);
    y = repmat(y',1,nPoints);
  end
  
  
function [p, x, y] = get_pdf_by_kernel(u,v,nPoints)
  if isempty(v),
    [p, x] = ksdensity(u, 'npoints', nPoints);
    y = [];
  else
    [b, p, x, y] = kde2d([u;v]', nPoints);
  end
