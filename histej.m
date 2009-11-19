function histej(e,j,bins)
%Recebe um conjunto de eletrons e jatos e os plota, com coloracao diferente
%p/ jatos.
%

hist(e, bins);
hold on;
hist(j, bins);

h = findobj(gca, 'Type', 'patch');
set(h(1), 'FaceColor', 'r');
