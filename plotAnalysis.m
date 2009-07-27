function plotAnalysis(net, evo, electrons, jets, id, nROC, bE, bEta, bPhi, bOut)
%function plotAnalysis(net, evo, electrons, jets, id, nROC, bE, bEta, bPhi, bOut)
%Gera as figuras de Plots para analise. Os parametros de entrada sao:
% - net: a rede neural a ser utilizada.
% - evo: A estrutura com as informacoes sobre a evolucao do treino.
% - electrons: um conjunto de eletrons com a mesma estrutura do retorno da funcao 'get_rings'. 
% - jets: um conjunto de jatos com a mesma estrutura do retorno da funcao 'get_rings'. 
% - id (opt): Uma string com a identificacao desta rede, aser usada em todas as plots.
% - nROC (opt): O numero de pontos na ROC a ser apresentada.
% - be (opt): O numero de bims para usar no histograma de energia.
% - bEta (opt): O numero de bims para usar no histograma de eta.
% - bPhi (opt): O numero de bims para usar no histograma de phi.
% - bOut (opt): O numero de bims para usar no histograma da saida da rede.
%
%Os seguintes graficos serao gerados:
% - Variacao da deteccao e do falso alarme pela energia.
% - Variacao da deteccao e do falso alarme por eta.
% - Variacao da deteccao e do falso alarme por phi.
%

  if nargin < 5, id = ''; end
  if nargin < 6, nROC = 200; end
  if nargin < 7, bE = 50; end
  if nargin < 8, bEta = 50; end
  if nargin < 9, bPhi = 50; end
  if nargin < 10, bOut = 100; end
  
  if ~isempty(id), id = sprintf('(%s)', id); end
    
  %Training evolution.
  if ~isempty(evo),
    tstData = ~isempty(evo.mse_tst(evo.mse_tst ~= 0));
    subplot(2,3,1);
    plot(evo.epoch, evo.mse_trn, 'b-', evo.epoch, evo.mse_val, 'r-');
    hold on;
    leg = {'MSE (trn)', 'MSE (val)'};

    if tstData,
      plot(evo.epoch, evo.mse_tst, 'k-');
      leg = [leg {'MSE (tst)'}];
    end
    
    if (net.trainParam.useSP),
      plot(evo.epoch, evo.sp_val, 'm-');    
      leg = [leg {'SP (val)'}];
      if tstData,
        plot(evo.epoch, evo.sp_tst, 'g-');
        leg = [leg {'SP (tst)'}];
      end
    end
    hold off;
    legend(leg, 'Location', 'East');
    title('Training Evolution');
    xlabel('Epoch');
    ylabel('MSE / SP');
    set(gca, 'xScale', 'log');
    grid on;
  end
  
  %Calculating net Output
  oE = nsim(net, electrons.rings);
  mean_oE = mean(oE);
  std_oE = std(oE);
  oJ = nsim(net, jets.rings);
  mean_oJ = mean(oJ);
  std_oJ = std(oJ);
  
  %Calculating ROC
  [spVec, cutVec, detVec, faVec] = genROC(oE, oJ, nROC);
  [maxSP, Isp] = max(spVec);
  cut = cutVec(Isp);
  
  %Histogram with network outputs.
  subplot(2,3,2);
  [inOut, supOut, cOut] = getBimRanges(-1, 1, bOut);
  eHist = hist(oE, cOut);
  jHist = hist(oJ, cOut);
  bar(cOut,eHist,'b');
  hold on;
  bar(cOut,jHist,'r');
  plot([cut cut], [0 max([eHist jHist])], 'k--');
  hold off;
  title(sprintf('Network Output %s', id));
  xlabel('Output value');
  ylabel('Frequency');
  eTxt = sprintf('Electron (%2.2f%%) out: %1.3f +- %1.3f', 100*detVec(Isp), mean_oE, std_oE);
  jTxt = sprintf('Jet (%2.2f%%) out: %1.3f +- %1.3f', 100*(1-faVec(Isp)), mean_oJ, std_oJ);
  trhTxt = sprintf('Threshold (%1.3f)', cut);
  legend(eTxt, jTxt, trhTxt, 'Location', 'North');
%  set(gca, 'yScale', 'log');


  %ROC figure.
  subplot(2,3,3);
  plot(100*faVec, 100*detVec, 'b-', 100*faVec(Isp), 100*detVec(Isp), 'b*');
  spTxt = sprintf('max. SP (%2.2f)', 100*maxSP);
  legend('ROC', spTxt, 'Location', 'SouthEast');
  title(sprintf('ROC %s', id));
  xlabel('False Alarm (%)');
  ylabel('Detection Efficiency (%)');
  set(gca, 'XLim', [0 15]);
  set(gca, 'YLim', [95 100]);
  grid on;
  
  %Doing energy analysis.
  [inE, supE, cE] = getBimRanges(7000, 80000, bE);
  [pd, pfa, ne, nj] = getProbabilities(net, cut, electrons.rings, jets.rings, electrons.et, jets.et, inE, supE);
  subplot(2,3,4);
  bar(cE,pd,'b');
  hold on;
  bar(cE,pfa,'r');
  hold off;
  title(sprintf('Detection Efficiency over E_t %s', id));
  xlabel('E_t (Mev)');
  ylabel('Efficiency (%)');
  legend('Detection', 'False Alarm', 'Location', 'East');
%  for i=1:bE,
%    txt = sprintf('E=%d / J=%d', ne(i), nj(i));
%    text(cE(i),floor(pd(i)-10),txt,'FontSize',8, 'Rotation', 90, 'HorizontalAlignment', 'right', 'Color', 'y', 'FontUnits', 'normalized');
%  end
  
  %Doing eta.
  [inEta, supEta, cEta] = getBimRanges(-2.5, 2.5, bEta);
  [pd, pfa, ne, nj] = getProbabilities(net, cut, electrons.rings, jets.rings, electrons.lvl2_eta, jets.lvl2_eta, inEta, supEta);
  subplot(2,3,5);
  bar(cEta,pd,'b');
  hold on;
  bar(cEta,pfa,'r');
  hold off;
  title(sprintf('Detection Efficiency over eta %s', id));
  xlabel('\eta');
  ylabel('Efficiency (%)');
  legend('Detection', 'False Alarm', 'Location', 'East');
  set(gca, 'XLim', [-2.6 2.6]);
%  for i=1:bEta,
%    txt = sprintf('E=%d / J=%d', ne(i), nj(i));
%    text(cEta(i),floor(pd(i))-10,txt,'FontSize',8, 'Rotation', 90, 'HorizontalAlignment', 'right', 'Color', 'y', 'FontUnits', 'normalized');
%  end

  %Doing phi.
  [in, sup, c] = getBimRanges(-pi, pi, bPhi);
  [pd, pfa, ne, nj] = getProbabilities(net, cut, electrons.rings, jets.rings, electrons.lvl2_phi, jets.lvl2_phi, in, sup);
  subplot(2,3,6);
  bar(c,pd,'b');
  hold on;
  bar(c,pfa,'r');
  hold off;
  title(sprintf('Detection Efficiency over phi %s', id));
  xlabel('\phi');
  ylabel('Efficiency (%)');
  legend('Detection', 'False Alarm', 'Location', 'East');
  set(gca, 'XLim', [-3.2 3.2]);
%  for i=1:bPhi,
%    txt = sprintf('E=%d / J=%d', ne(i), nj(i));
%    text(c(i),floor(pd(i)-10),txt,'FontSize',8, 'Rotation', 90, 'HorizontalAlignment', 'right', 'Color', 'y', 'FontUnits', 'normalized');
%  end

  set(gcf, 'Position', [1 1 1440 800]);
  
function show(x,y,e,c,error)
  if error,
    errorbar(x,y,e,c);
  else
    plot(x,y,c);
  end

   