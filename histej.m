function histej(e,j,bins)
%function histej(e,j,bins)
%Recebe um conjunto de eletrons e jatos e os plota, com coloracao diferente
%p/ jatos.
%

hist(e, bins);
hold on;
hist(j, bins);

h = findobj(gca, 'Type', 'patch');
set(h(1), 'FaceColor', 'none');
set(h(1), 'EdgeColor', 'r');
set(h(2), 'FaceColor', 'none');
set(h(2), 'EdgeColor', 'b');

