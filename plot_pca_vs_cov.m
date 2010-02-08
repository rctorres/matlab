function plot_pca_vs_cov(data, ringsDist)
%function plot_pca_vs_cov(data, ringsDist)
%Plota a energia retida (em %) pelos auto valores e pelas variancia de cada
%anel.
%

  secNames = {'PS', 'EM1', 'EM2', 'EM3', 'HD1', 'HD2', 'HD3'};

  for i=1:length(ringsDist),
    [var, eig] = getValues(getLayer(data, ringsDist, i)');
    subplot(2,4,i);
    hold on;
    plot(var, 'b*--')
    plot(eig, 'ro--');
    title(secNames{i})
    xlabel('# Anel / Componente');
    ylabel('Energia Retida (%)')
    legend('Anel', 'PCA')
  end

  [var, eig] = getValues(data');
  subplot(2,4,8);
  hold on;
  plot(var, 'b*--')
  plot(eig, 'ro--');
  title('ALL')
  xlabel('# Anel / Componente');
  ylabel('Energia Retida (%)')
  legend('Anel', 'PCA')


function [var, eig] = getValues(data)
  c = cov(data);
  var = diag(c);
  [pca, eig] = pcacov(c);
  
  var = 100 * (var ./ sum(var));
  eig = 100 * (eig ./ sum(eig));
 