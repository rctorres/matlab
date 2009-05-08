function plotPCDEfic(ef)
%function plotPCDEfic(ef)
%Plota a vricao da eficiencia pelo numerod e PCDs, recebendo a estrutura de
%eficiencia retornada pelo npcd (xxx.efic) contendo o maximo SP obtido p/c
%ada SP, bem como o SP medio e seu desvio.
%

plot(ef.max, 'r*--');
hold on;
errorbar(ef.mean, ef.std, 'b*--');
hold off;
title('SP Variation over PCD');
xlabel('# PCD');
ylabel('SP (norm)');
legend('Max SP', 'Mean SP', 'Location', 'SouthEast');
grid on;
