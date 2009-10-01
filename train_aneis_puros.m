function [net, fisher] = train_aneis_puros(trn, val, tst, par, discover_via_pcd, batch_size, tst_equal_val)
%function [net, fisher] = train_aneis_puros(trn, val, tst, par, discover_via_pcd, batch_size, tst_equal_val)
%
  fprintf('Fazendo %s\n', par.desc);

  if discover_via_pcd,
    %Quero saber qtos nos usar na camada escondida
    numNodes = 1;
  else
    %Fazendo Fisher.
    numNodes = 0;
    fisher = fullTrain(trn, val, tst, batch_size, numNodes, par.pp_func, tst_equal_val);
    numNodes = p.hidden_nodes; %P/ o treino neural.
  end

  %Treino neural.
  net = fullTrain(trn, val, tst, batch_size, numNodes, par.pp_func, tst_equal_val);
