load pcd_seg.mat
load pcd.mat
norm = 'event';

names = [{'PS'} {'EM1'} {'EM2'} {'EM3'} {'HD1'} {'HD2'} {'HD3'}];

figure;

for i=1:length(pcd_seg.(norm)),
  subplot(2,4,i);
  errorbar(pcd_seg.(norm){i}.efic.mean, pcd_seg.(norm){i}.efic.std, 'b*--');
  hold on
  plot(pcd_seg.(norm){i}.efic.max, 'r*--');
  hold off
  legend('Mean', 'Max', 'Location', 'SouthEast');
  title(names{i});
  xlabel('# PCD');
  ylabel('SP (Norm)');
  grid on;
end

subplot(2,4,8);
errorbar(pcd.(norm).efic.mean, pcd.(norm).efic.std, '*--');
hold on;
plot(pcd.(norm).efic.max, 'r*--');
hold off
legend('Mean', 'Max', 'Location', 'SouthEast');
title('ALL')
xlabel('# PCD');
ylabel('SP (Norm)');
grid on;

saveas(gcf, 'carga_pcd', 'fig');
