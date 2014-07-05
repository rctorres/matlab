function histej(e,j,bins)
%function histej(e,j,bins)
%Recebe um conjunto de eletrons e jatos e os plota, com coloracao diferente
%p/ jatos.
%
%  hist(e, bins);
%  hold on;
%  hist(j, bins);
%  hold off;

  [~,ec] = hist(e, bins);
  [~,ej] = hist(j, bins);
  
  limits = minmax([ec ej]);
  min_c = limits(1);
  max_c = limits(2);
  
  step = (max_c - min_c) / bins;
  centers = (min_c:step:max_c);
  
  hist(e, centers);
  hold on;
  hist(j, centers);

  h = findobj(gca, 'Type', 'patch');
  set(h(1), 'FaceColor', 'none');
  set(h(1), 'EdgeColor', 'r');
  set(h(2), 'FaceColor', 'none');
  set(h(2), 'EdgeColor', 'b');
end

