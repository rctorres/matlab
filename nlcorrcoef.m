function C = nlcorrcoef(data)
%function C = nlcorrcoef(data)
%Calcula o coeficiente de correlacao nao-linear de data.
%Esta funcao tem funcionamento analogo ao corrcoef, so que, ao inves de
%fazer E[X'*X], esta funcao fara E[f(X')*f(X')], onde f(.) e g(.) sao duas
%funcoes nao-lineares.
%
  
[N,M] = size(data);
data = data - repmat(mean(data), N, 1);
X = data.^3;
Y = tanh(data);
C = (1/N)*(X'*Y);
d = sqrt(diag(C));
C = C ./ (d*d');

%Fazendo o mesmo fix que o corrcoef faz, p/ garanir os resultados ente +-1.
t = find(abs(C) > 1); 
C(t) = C(t)./abs(C(t));
C(1:M+1:end) = sign(diag(C));
