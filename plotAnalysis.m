function plotAnalysis(net, cut, electrons, jets, bE, bEta, bPhi, showError, id)
%function plotAnalysis(net, cut, electrons, jets, bE, bEta, bPhi, id)
%Gera as figuras de Plots para analise. Os parametros de entrada sao:
% - net: a rede neural a ser utilizada.
% - cut: o Corte (threshold) de decisao da rede neural.
% - electrons: um conjunto de eletrons com a mesma estrutura do retorno da funcao 'get_rings'. 
% - jets: um conjunto de jatos com a mesma estrutura do retorno da funcao 'get_rings'. 
% - be: O numero de bims para usar no histograma de energia.
% - bEta: O numero de bims para usar no histograma de eta.
% - bPhi: O numero de bims para usar no histograma de phi.
% - id: Uma string com a identificacao desta rede, aser usada em todas as plots.
%
%Os seguintes graficos serao gerados:
% - Variacao da deteccao e do falso alarme pela energia.
% - Variacao da deteccao e do falso alarme por eta.
% - Variacao da deteccao e do falso alarme por phi.
% - Variacao da deteccao e do falso alarme num grafico Et x Eta.
%

  %Doing energy analysis.
  [inE, supE, cE] = getBimRanges(7000, 80000, bE);
  [pd, pfa, ne, nj] = getProbabilities(net, cut, electrons.rings, jets.rings, electrons.et, jets.et, inE, supE);
  figure;
  bar(cE,pd,'b');
  hold on;
  bar(cE,pfa,'r');
  hold off;
  title(sprintf('Detection Efficiency over E_t (%s)', id));
  xlabel('E_t (Mev)');
  ylabel('Efficiency (%)');
  legend('Detection', 'False Alarm', 'Location', 'East');
  for i=1:bE,
    txt = sprintf('E=%d / J=%d', ne(i), nj(i));
%    text(cE(i),floor(pd(i)-10),txt,'FontSize',8, 'Rotation', 90, 'HorizontalAlignment', 'right', 'Color', 'y', 'FontUnits', 'normalized');
  end
  
  %Doing eta.
  [inEta, supEta, cEta] = getBimRanges(-2.5, 2.5, bEta);
  [pd, pfa, ne, nj] = getProbabilities(net, cut, electrons.rings, jets.rings, electrons.lvl2_eta, jets.lvl2_eta, inEta, supEta);
  figure;
  bar(cEta,pd,'b');
  hold on;
  bar(cEta,pfa,'r');
  hold off;
  title(sprintf('Detection Efficiency over eta (%s)', id));
  xlabel('\eta');
  ylabel('Efficiency (%)');
  legend('Detection', 'False Alarm', 'Location', 'East');
  for i=1:bEta,
    txt = sprintf('E=%d / J=%d', ne(i), nj(i));
%    text(cEta(i),floor(pd(i))-10,txt,'FontSize',8, 'Rotation', 90, 'HorizontalAlignment', 'right', 'Color', 'y', 'FontUnits', 'normalized');
  end

  %Doing phi.
  [in, sup, c] = getBimRanges(-pi, pi, bPhi);
  [pd, pfa, ne, nj] = getProbabilities(net, cut, electrons.rings, jets.rings, electrons.lvl2_phi, jets.lvl2_phi, in, sup);
  figure;
  bar(c,pd,'b');
  hold on;
  bar(c,pfa,'r');
  hold off;
  title(sprintf('Detection Efficiency over phi (%s)', id));
  xlabel('\phi');
  ylabel('Efficiency (%)');
  legend('Detection', 'False Alarm', 'Location', 'East');
  for i=1:bPhi,
    txt = sprintf('E=%d / J=%d', ne(i), nj(i));
%    text(c(i),floor(pd(i)-10),txt,'FontSize',8, 'Rotation', 90, 'HorizontalAlignment', 'right', 'Color', 'y', 'FontUnits', 'normalized');
  end

function show(x,y,e,c,error)
  if error,
    errorbar(x,y,e,c);
  else
    plot(x,y,c);
  end

   