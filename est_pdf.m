function [p, x, y] = est_pdf(data, mode, nPoints, doDif)
%function [p, x, y] = est_pdf(data, mode, nPoints, doDif)
  
  if nargin < 2, mode = 'kernel'; end
  if nargin < 3, nPoints = 128; end
  if nargin < 4, doDif = false; end

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
    [p, x, y] = get_pdf_by_hist(u, v, nPoints, doDif);
  elseif strcmp(mode, 'kernel'),
    [p, x, y] = get_pdf_by_kernel(u, v, nPoints, doDif);
  else
    error('Invalid mode! See help for options.')
  end
  

function [p, x, y] = get_pdf_by_hist(u,v,nPoints,doDif)
  gain = 1; %Used if discrete PDF.

  if isempty(v),
    [p, x] = hist(u, nPoints);
    y = [];
    if doDif, gain = abs(x(2)-x(1)); end  
  else
    desc = [min(u) max(u), nPoints; min(v), max(v), nPoints];
    p = histogram2(u,v,desc);
    x = repmat(linspace(desc(1,1), desc(1,2), desc(1,3)), nPoints, 1);
    y = repmat(linspace(desc(2,1), desc(2,2), desc(2,3))', 1, nPoints);
    if doDif, gain = abs(x(1,2)-x(1,1))*abs(y(2,1)-y(1,1)); end
  end
  
  p = p ./ (gain*sum(sum(p)));
  
  
function [p, x, y] = get_pdf_by_kernel(u,v,nPoints,doDif)
  if isempty(v),
    [p, x] = ksdensity(u, 'npoints', nPoints);
    y = [];
  else
    [b, p, x, y] = kde2d([u;v]', nPoints);
  end

  if ~doDif, p = p ./ sum(sum(p));  end
