function train_all_cases(trn, val, tst, norm, discover_via_pcd, batch_size, tst_equal_val)
%function train_all_cases(trn, val, tst, norm, discover_via_pcd, batch_size, tst_equal_val)
%Treina todos os casos de pre-processamento passados.
%trn, val, tst sao dos datasets. norm e a lista de normalizacos a serem
%executadas. Atraves de norm, sera chamada a funcao com os parametros a
%serem usados em cada normalizacao. discover_via_pcd, se true, vai fazer o sistema
%realizar uma analise por PCD, p/ saber qual o melhor numero de nos na
%camada escondida. batch_sise e o tamanho da batelada a ser usada, e
%tst_equal_val, se true, diz a funcao que o conjunto de teste e identico ao
%de validacao. Se discover_via_pcd = false, um fisher sera rodado, e, em
%ambos os casos (fisher, net), a validacao cruzada sera feita.
%

for i=1:length(norm),
  par = get_parameters(norm{i});
  [net, fisher] = train_case(trn, val, tst, par, discover_via_pcd, batch_size, tst_equal_val);
  
  if discover_via_pcd,
    save(sprintf('nodes_analysis_%s.mat', par.id), 'net');
  else
    save(sprintf('nets_%s.mat', par.id), 'net', 'fisher');
  end
end
