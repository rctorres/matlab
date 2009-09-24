function gen_pca_plots(pca, pca_seg, marker)
%function gen_pca_plots(pca, pca_seg, marker)
%Plota a curva de carga das PCAs de todas as camadas, mas a do evento
%nao-segmentado usando o marcador marker ('b*--', etc.) pca deve ser uma
%estrutura contendo o campo 'en', e pca_seg, um vetor de celulas, onde cada
%celula e uma estrutura contendo o campo 'en'.
%

if nargin < 3, marker = 'b*--'; end

names = [{'PS'} {'EM1'} {'EM2'} {'EM3'} {'HD1'} {'HD2'} {'HD3'}];

for i=1:length(pca_seg),
  hold on;
  pcRet = size(pca_seg{i}.W,1);
  subplot(2,4,i);
  plotPCAcurve(pca_seg{i}.en, marker);
  hold on;
  title(names{i});
  xlabel('# PCA');
  ylabel('Energy (%)');
  set(gca, 'xLim', [0, (length(pca_seg{i}.en)+1)]);
  grid on;
end

subplot(2,4,8);
hold on;
plotPCAcurve(pca.en, marker);
title('ALL')
xlabel('# PCA');
ylabel('Energy (%)');
grid on;
