function C = nlcorrcoef(data)
%function C = nlcorrcoef(data)
%Calcula o coeficiente de correlacao nao-linear de data.
%Esta funcao tem funcionamento analogo ao corrcoef, so que, ao inves de
%fazer E[X'*X], esta funcao fara E[f(X')*f(X')], onde f(.) e g(.) sao duas
%funcoes nao-lineares.
%
  
N = size(data, 1);
data = data - repmat(mean(data), N, 1);
X = tanh(data);
Y = data.^3;
C = (1/N)*(X'*Y);
d = sqrt(diag(C));
C = C ./ (d*d');
