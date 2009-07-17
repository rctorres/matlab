load pca.mat pca_all pca_seg

names = [{'PS'} {'EM1'} {'EM2'} {'EM3'} {'HD1'} {'HD2'} {'HD3'}];

figure;

for i=1:length(pca_seg),
  subplot(2,4,i);
  plotPCAcurve(pca_seg{i}.en);
  title(names{i});
  xlabel('# PCA');
  ylabel('Energy (%)');
  grid on;
end

subplot(2,4,8);
plotPCAcurve(pca_all.en);
title('ALL')
xlabel('# PCA');
ylabel('Energy (%)');
grid on;

saveas(gcf, 'carga_pca', 'fig');
