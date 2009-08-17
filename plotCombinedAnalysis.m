function gen_plots()
  load fisher_nn.mat fisher_nn
  load net_nn.mat net_nn
  load ../../globals.mat DATAPATH
  colors = ['b', 'r', 'k', 'm', 'c', 'g', 'y'];
  
  net = net_nn;
  fisher = fisher_nn;
  normType = fieldnames(net_nn);

  fig_roc = figure;
  leg_nn = cell(1, length(normType));
  leg_fisher = cell(1, length(normType));

  for n=1:length(normType)
    norm = normType{n};
    col = colors(n);
    
    load(sprintf('%snn-data-%s', DATAPATH, norm), 'eTst', 'jTst');
  
    figure;
    plotAnalysis(fisher.(norm).net, fisher.(norm).trnEvo, eTst, jTst, sprintf('%s Fisher', norm));
    saveas(gcf, sprintf('analysis-%s-Fisher',norm), 'fig');
  
    figure;
    plotAnalysis(net.(norm).net, net.(norm).trnEvo, eTst, jTst, sprintf('%s Net', norm));
    saveas(gcf, sprintf('analysis-%s-Net',norm), 'fig');
  
    data = {eTst.rings jTst.rings};
    clear eTst jTst;
  
    %ROCs combinadas.
    figure(fig_roc);
    leg_nn{n} = getROC(net.(norm).net, data, 1, col, norm);
    leg_fisher{n} = getROC(fisher.(norm).net, data, 2, col, norm);
  end

  figure(fig_roc);
  subplot(1,2,1);
  hold off;
  title('Classificadores Nao Lineares');
  xlabel('Falso Alarme (%)');
  ylabel('Detecao (%)');
  legend(leg_nn, 'Location', 'SouthEast');
  set(gca, 'XLim', [1 12]);
  set(gca, 'YLim', [98 100]);
  grid on;

  subplot(1,2,2);
  hold off;
  title('Classificadores Lineares');
  xlabel('Falso Alarme (%)');
  ylabel('Detecao (%)');
  legend(leg_fisher, 'Location', 'SouthEast');
  set(gca, 'XLim', [1 12]);
  set(gca, 'YLim', [98 100]);
  grid on;

  saveas(gcf, 'rocs_combinadas', 'fig');
  
  
function leg = getROC(net, data, pos, col, norm)
  out = nsim(net, data);
  [spVec, cutVec, det, fa] = genROC(out{1}, out{2});
  subplot(1,2,pos);
  plot(100*fa, 100*det, col);
  hold on;
  leg = sprintf('%s (%s)', norm, getNumNodesAsText(net));


