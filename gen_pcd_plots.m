function gen_pcd_plots(pcd, pcd_seg, cstyle)
%function gen_pcd_plots(pcd, pcd_seg, cstyle)

if nargin < 3, cstyle = 'b*--'; end

names = [{'PS'} {'EM1'} {'EM2'} {'EM3'} {'HD1'} {'HD2'} {'HD3'}];

for i=1:length(pcd_seg.efic),
  subplot(2,4,i);
%  errorbar(pcd_seg{i}.efic.mean, pcd_seg{i}.efic.std, 'b*--');
%  hold on
  plot(100*pcd_seg.efic{i}.max, cstyle);
%  hold off
%  legend('Mean', 'Max', 'Location', 'SouthEast');
  hold on
  title(names{i});
  xlabel('# PCD');
  ylabel('SP');
  grid on;
  set(gca, 'xLim', [0 length(pcd_seg.efic{i}.max)]);
end

subplot(2,4,8);
%errorbar(pcd.efic.mean, pcd.efic.std, '*--');
%hold on;
plot(100*pcd.efic.max, cstyle);
%hold off
%legend('Mean', 'Max', 'Location', 'SouthEast');
hold on
title('ALL')
xlabel('# PCD');
ylabel('SP');
grid on;
set(gca, 'xLim', [0 length(pcd.efic.max)]);
