function c = mutual_info(m, doNorm)

  m = m';
  [M,N] = size(m);
  c = zeros(M);

  for i=1:M,
    x = m(i,:);
    for j=i:M,
      y = m(j,:);
      c(i,j) = entropy(x) + entropy(y) - entropy([x;y]);
    end
    
    if doNorm,
      c(i,i:end) = c(i,i:end) ./ max(c(i,i:end));
    end
  end
    
  
  %Componho a matriz final colocando a transposta da matriz na parte
  %inferior.
  c = triu(c) + tril(c',-1);
