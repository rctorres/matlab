function [net, fisher] = train_case(trn, val, tst, par, discover_via_pcd, trainParam, tst_equal_val, doCrossVal)
%function [net, fisher] = train_case(trn, val, tst, par, discover_via_pcd, trainParam, tst_equal_val, doCrossVal)
%Faz o treino de um caso especifico.
%trn, val, tst sao dos datasets. par e a estrutura de treino especifica
%para este caso, retornada pela funcao get_parameters existento no
%diretorio de analise. discover_via_pcd, se true, vai fazer o sistema
%realizar uma analise por PCD, p/ saber qual o melhor numero de nos na
%camada escondida. trainParam e a estrutura com os parametros de
%treinamento, de tal forma que net.trainParam = trainParam seja valido.
%tst_equal_val, se true, diz a funcao que o conjunto de teste e identico ao
%de validacao. Se discover_via_pcd = false, um fisher sera rodado, e, em
%ambos os casos (fisher, net), a validacao cruzada sera feita 
%(se , doCrossVal = true). do Contrario, apaenas uma rede sera treinada.
%

  fprintf('Fazendo %s\n', par.desc);

  if discover_via_pcd,
    %Quero saber qtos nos usar na camada escondida
    numNodes = 1;
    fisher = [];
  else
    %Fazendo Fisher.
    numNodes = 0;
    fisher = fullTrain(trn, val, tst, trainParam, numNodes, par, tst_equal_val, doCrossVal);
    fisher.desc = par.desc;
    fisher.id = par.id;
    numNodes = par.hidden_nodes; %P/ o treino neural.
  end

  %Treino neural.
  net = fullTrain(trn, val, tst, trainParam, numNodes, par, tst_equal_val, doCrossVal);
  net.desc = par.desc;
  net.id = par.id;
