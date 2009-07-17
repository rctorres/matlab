function gen_pca_plots(pca, pca_seg)

names = [{'PS'} {'EM1'} {'EM2'} {'EM3'} {'HD1'} {'HD2'} {'HD3'}];

for i=1:length(pca_seg),
  pcRet = size(pca_seg{i}.W,1);
  subplot(2,4,i);
  plotPCAcurve(pca_seg{i}.en, size(pca_seg{i}.W,1));  
  title(names{i});
  xlabel('# PCA');
  ylabel('Energy (%)');
  grid on;
end

subplot(2,4,8);
plotPCAcurve(pca.en, size(pca.W,1));
title('ALL')
xlabel('# PCA');
ylabel('Energy (%)');
grid on;
