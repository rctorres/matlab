function plotCrossValComp(str)
%function plotCrossValComp(str)
%Recebe uma estrutura contendo uma subestrutura para cada pre-processamento
%feito. Cada subestrutura contem a estrutura retornada pelo crossVal. Eu
%plot as ROCs e o SP maximo dos casos. O maximo que a funcao suporta sao 7
%pre-processamentos, para nao estourar o numero de cores disponiveis no
%plot.
%

fields = fieldnames(str);
nFields = length(fields);

if nFields > 7,
  error('So posso trabalhar com no maximo 6 pre-processamentos por vez!')
end

colors = 'rbkmcgy';
markers = 'o*sdphx';
leg = cell(1, nFields);
handles = zeros(1, nFields);

roc = figure;
hold on;
sp = figure;
hold on;

for i=1:nFields,
  f = fields{i};
  c = colors(i);
  m = markers(i);
  
  leg{i} = f;
  
  figure(roc);
  h = plot(100*str.(f).fa', 100*str.(f).det', c);
  handles(i) = h(1);
  
  figure(sp);
  m_val = mean(str.(f).sp);
  s_val = std(str.(f).sp);
  [ei, es] = adjustErrorRanges(m_val, s_val);
  errorbar(i, 100*m_val, 100*ei, 100*es, [c m]);
end

figure(roc);
grid on;
legend(handles, leg, 'Location', 'SouthEast');
title('ROC');
xlabel('Falso Alarme (%)');
ylabel('Detecao (%)');

figure(sp);
grid on;
legend(leg, 'Location', 'Best');
title('Maximo SP Obtido');
xlabel('Caso');
ylabel('Falso Alarme (%)');
  