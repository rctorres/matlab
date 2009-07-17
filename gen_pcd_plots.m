function gen_pcd_plots(pcd, pcd_seg)

names = [{'PS'} {'EM1'} {'EM2'} {'EM3'} {'HD1'} {'HD2'} {'HD3'}];

figure;

for i=1:length(pcd_seg),
  subplot(2,4,i);
  errorbar(pcd_seg{i}.efic.mean, pcd_seg{i}.efic.std, 'b*--');
  hold on
  plot(pcd_seg{i}.efic.max, 'r*--');
  hold off
  legend('Mean', 'Max', 'Location', 'SouthEast');
  title(names{i});
  xlabel('# PCD');
  ylabel('SP (Norm)');
  grid on;
end

subplot(2,4,8);
errorbar(pcd.efic.mean, pcd.efic.std, '*--');
hold on;
plot(pcd.efic.max, 'r*--');
hold off
legend('Mean', 'Max', 'Location', 'SouthEast');
title('ALL')
xlabel('# PCD');
ylabel('SP (Norm)');
grid on;
