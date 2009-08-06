function compare_efic_trn_val_tst(netVec, trn, val, tst)
%Este script vai calcular o SP e as RoCs obtidas quando se passa os conjuntos de treino, validacao
%e teste. O objetivo e testar se existem grandes discrepancias entre os resultados, mostrando
%deficiencia de estatistica, ou ma distribuicao dos conjuntos em treino, validacao e teste.
%

  data = {trn val tst};
  leg = {'Treino', 'Validacao', 'Teste'};
  color = {'b', 'r', 'k'};
  marker = {'b*', 'ro', 'kd'};

  for i=1:3,
    [sp, det, fa] = getPlots(netVec, data{i});
    subplot(1,2,1);
    plot(fa.mean, det.mean, color{i});
    hold on;

    subplot(1,2,2);
    errorbar(i, sp.mean, sp.std, marker{i});
    hold on;
  end

  subplot(1,2,1);
  hold off;
  
  title('ROC Media de cada Dataset');
  xlabel('Falso Alarme (%)');
  ylabel('Prob. de Deteccao (%)');
  grid on;
  set(gca, 'XLim', [0.001 12]);
  set(gca, 'YLim', [95 100]);
  legend(leg, 'Location', 'SouthEast');
  
  subplot(1,2,2);
  hold off;
  title('SP Maximo de cada Dataset');
  xlabel('Dataset');
  ylabel('SP');
  grid on;
  legend(leg);


function [sp, det, fa] = getPlots(netVec, data)
  N = length(netVec);
  NROC = 400;

  detVec = zeros(N,NROC);
  faVec = zeros(N,NROC);
  spVec = zeros(1,N);
  
  for i=1:N,
    out = nsim(netVec{i}, data);
    [spV, aux, detVec(i,:), faVec(i,:)] = genROC(out{1}, out{2}, NROC);
    spVec(i) = 100*max(spV);
  end

  detVec = 100*detVec;
  faVec = 100*faVec;
  sp.mean = mean(spVec);
  sp.std = std(spVec);
  det.mean = mean(detVec);
  det.std = std(detVec);
  fa.mean = mean(faVec);
  fa.std = std(faVec);
