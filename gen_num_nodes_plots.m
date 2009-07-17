function gen_num_nodes_plots(efic,efic_seg)
%Esta funcao vai plotar a evolucao da eficiencia (SP) pelo numero de
%neuronios na camada escondida da rede. Para tal, ela vai receber uma
%estrutura contendo 3 campos %chamados 'mean', 'std' e 'max', que sao, 
%respectivamente o a media, o desvio e o valor maximo de SP obtido p/ 
%cada tamanho de camada escondida testado. O grafico apresentado sera 
%para o caso nao-segmentado e segmentado.
%

errorbar(efic.mean, efic.std, 'b*--');
hold on;
plot(efic.max, 'ro--');
errorbar(efic_seg.mean, efic_seg.std, 'kd--');
plot(efic_seg.max, 'ms--');
hold off
legend('Mean (non-seg)', 'Max (non-seg)', 'Mean (seg)', 'Max (seg)', 'Location', 'SouthEast');
title('SP Over Number of Nodes in Hidden Layer')
xlabel('# Nodes');
ylabel('SP (Norm)');
grid on;


