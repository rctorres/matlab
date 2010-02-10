function c = mutual_info(m, doNorm, mode, nPoints, doDif)
%function c = mutual_info(m, doNorm, mode, nPoints, doDif)

  if nargin < 2, doNorm = false; end;
  if nargin < 3, mode = 'kernel'; end;
  if nargin < 4, nPoints = 128; end;
  if nargin < 5, doDif = false; end;

  m = m';
  [M,N] = size(m);
  c = zeros(M);

  for i=1:M,
    x = m(i,:);
    for j=i:M,
      y = m(j,:);
      hx = entropy(x, [], mode, nPoints, doDif);
      hy = entropy(y, [], mode, nPoints, doDif);
      hxy = entropy([x;y], [], mode, nPoints, doDif);
      c(i,j) = hx + hy - hxy;
    end    
  end
    
  %Componho a matriz final colocando a transposta da matriz na parte
  %inferior.
  c = triu(c) + tril(c',-1);

  if doNorm,
    c = 1 - exp(-2*c);
  end
