function gen_pca_plots(pca, pca_seg, retStyle, discStyle, lineStyle)
%function gen_pca_plots(pca, pca_seg, retStyle, discStyle, lineStyle)
%

if nargin < 3, retStyle = 'bo'; end
if nargin < 4, discStyle = 'r*'; end
if nargin < 5, lineStyle = 'k--'; end

names = [{'PS'} {'EM1'} {'EM2'} {'EM3'} {'HD1'} {'HD2'} {'HD3'}];

for i=1:length(pca_seg),
  hold on;
  pcRet = size(pca_seg{i}.W,1);
  subplot(2,4,i);
  plotPCAcurve(pca_seg{i}.en, size(pca_seg{i}.W,1), retStyle, discStyle, lineStyle);
  title(names{i});
  xlabel('# PCA');
  ylabel('Energy (%)');
  set(gca, 'xLim', [0, (length(pca_seg{i}.en)+1)]);
  grid on;
end

subplot(2,4,8);
hold on;
plotPCAcurve(pca.en, size(pca.W,1), retStyle, discStyle, lineStyle);
title('ALL')
xlabel('# PCA');
ylabel('Energy (%)');
grid on;
