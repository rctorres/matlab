function plot_scatter(x, y, color, drawXeqY)
  plot(x,y,[color '.']);
  
  if drawXeqY,
    xlim = get(gca, 'XLim');
    ylim = get(gca, 'YLim');
    hold on;
    plot(xlim, ylim, 'k--')
    hold off;
  end
end


