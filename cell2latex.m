function cell2latex(mat, dblFmt, intFmt)
%cell2latex(mat, dblFmt, intFmt)
%Converte uma matriz de celulas em uma tabela em Latex.
%dblFmt and intFmt are the formating chars for double and integer numbers,
%example: %2.3f, %03d, etc...
%

  if nargin < 2, dblFmt = '%f'; end
  if nargin < 3, intFmt = '%d'; end
  

  [M,N] = size(mat);

  fprintf('\\begin{tabular}{%s}\n', ['|' repmat('c|',1,N)]);
  fprintf('\\hline\n');
  
  for i=1:M,
    for j=1:N,
      v = mat{i,j};
      if ischar(v), fprintf('%s', v);
      elseif isinteger(v), fprintf(intFmt, v);
      elseif isfloat(v), fprintf(dblFmt, v);
      else error('Invalid type!');
      end
      if j ~= N, fprintf(' & '); end
    end
    fprintf('\\\\\n\\hline\n');
  end
  
  fprintf('\\end{tabular}\n');
  
