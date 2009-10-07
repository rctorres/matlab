function test_best_num_epochs(trnEvo)
%Este script pega cada treino com um numero insano de epocas, e, variando o
%criteriod e parada em slots de 1000, calcula a diferenca media e o
%respectivo erro em relacao ao treino usando o numero total de epocas. O
%objetivo e saber o melhor numero de epocas p/ o treino. trnEvo e um vetor 
%contendo, em cada celula, uma estrutura com a evolucao de treinamento, tal
%comor retornada pelo ntrain. A funcao plotara um grafico com o erro
%relativo obtido entro o SP maximo obtido (usando todas as epocas) e o S
%maximo obtido truncando-se o numero de epocas de treinamento.
%

res = 1000;
N = length(trnEvo);
nPt = floor(length(trnEvo{1}.epoch) / res);

sp = zeros(N,nPt);
leg = cell(1,N);

for i=1:N,
  evo = trnEvo{i};
  [spRef, I] = max(evo.sp_val);
  fprintf('SP maximo (%2.2f) ocorrido na epoca %d\n', 100*spRef, evo.epoch(I));
  leg{i} = sprintf('Max SP = %2.2f', 100*spRef);
  for j=1:nPt,
    sp(i,j) = 100*(spRef - max(evo.sp_val(1:j*res))) / spRef; 
  end
end

x = (1:res:1000*nPt);
x = repmat(x, N, 1);

figure;
plot(x', sp');
set(gca, 'xScale', 'log');
grid on;
title('Variacao do SP Maximo Obtido Com o Numero de Epocas de Treinamento');
xlabel('Numero de Epocas');
ylabel('Diferenca relativa (%)');
legend(leg);
