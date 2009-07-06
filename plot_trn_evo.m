function plot_trn_evo(d)
%function plot_trn_evo(d)
%Plota graficos de analises do trnEvo (d) retornado pela ntrain.
%

%plotando a evolucao do erro de treino, validacao e SP
figure
plot(d.epoch, d.mse_trn, 'b', d.epoch, d.mse_val, 'r', d.epoch, d.sp_val, 'k');
hold on
i_mse = find(d.stop_mse == 1, 1, 'first');
i_sp = find(d.stop_sp == 1, 1, 'first');
plot(d.epoch(i_mse), d.sp_val(i_mse), 'r*', d.epoch(i_sp), d.sp_val(i_sp), 'k*');
[max_mse, i_max_mse] = max(d.sp_val(1:i_mse));
[max_sp, i_max_sp] = max(d.sp_val(1:i_sp));
[max_sp_global, i_max_sp_global] = max(d.sp_val);
plot(d.epoch(i_max_mse), d.sp_val(i_max_mse), 'rs', d.epoch(i_max_sp), d.sp_val(i_max_sp), 'ks', d.epoch(i_max_sp_global), d.sp_val(i_max_sp_global), 'mv');
[min_mse, i_min_mse] = min(d.mse_val(1:i_mse));
plot(d.epoch(i_min_mse), d.mse_val(i_min_mse), 'rd');
legend('Treino', 'Val (MSE)', 'Val (SP)', 'Stop (MSE)', 'Stop (SP)', 'Best SP (MSE)', 'Best SP (SP)', 'Best MSE (MSE)', 'Best SP (Global)', 'Location', 'East');
plot(d.epoch(i_mse), d.mse_val(i_mse), 'r*');
title('Evolucao do Treinamento');
xlabel('Epoca')
ylabel('MSE / SP');
grid on;

fprintf('SP maximo atraves de parada por MSE = %f\n', max_mse);
fprintf('SP maximo atraves de parada por SP = %f\n', max_sp);
fprintf('\n');
fprintf('Ultimo SP obtido com MSE = %f\n', d.sp_val(i_mse));
fprintf('Ultimo SP obtido com SP = %f\n', d.sp_val(i_sp));

%plotando o flags de melhor MSE lobal e melhor SP global.
figure
plot(d.epoch, d.is_best_mse, 'bx', d.epoch, d.is_best_sp, 'rs');
title('Flags de Melhor Validacao Obtida');
xlabel('Epoca')
ylabel('Melhor caso?');
legend('MSE', 'SP', 'Location', 'East');
grid on;


%plotando o numero de falhas para cada caso (max_fail)
figure
plot(d.epoch, d.num_fails_mse, 'b', d.epoch, d.num_fails_sp, 'r');
title('Evolucao do Numero de Falhas');
xlabel('Epoca')
ylabel('Numero de falhas');
legend('MSE', 'SP', 'Location', 'Best');
grid on;


%plotando o flag de parar treinamento
figure
plot(d.epoch, d.stop_mse, 'bx', d.epoch, d.stop_sp, 'rs');
title('Flag de Maximo Numero de Falhas Atingido');
xlabel('Epoca')
ylabel('Parar treino');
legend('MSE', 'SP', 'Location', 'Best');
grid on;
