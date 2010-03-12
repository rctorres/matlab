function ret = get_out_cut_et_eta_phi(name, tst, netStr)
%function ret = get_out_cut_et_eta_phi(name, tst, netStr)
%  name: nome da abordagem (ICA, PCA 99%, etc.)
%  tst: conjunto de teste
%  netStr: estrutura contendo pp e net.
  
  %Pegando o melhor resultado de validacao cruzada
  [mV, idx] = max(netStr.sp);
  net = netStr.net{idx};
  pp = netStr.pp{idx};
  
  %Aplicando o pre-processamento.
  tst = do_pre_proc(pp, tst, tst, tst);

  %Propagando pela rede neural.
  ret.name = name;
  for i=1:length(tst),
    ret.out{i} = nsim(net, tst{i});
    ret.et{i} = 0.001 * (tst{i}.t2ca_em_e ./ cosh(tst{i}.t2ca_eta));
    ret.eta{i} = tst{i}.t2ca_eta;
    ret.phi{i} = tst{i}.t2ca_phi;
    ret.ev_mean{i} = mean(tst{i},2)';
  end
  
  [spVal, cutVal] = genROC(ret.out{1}, ret.out{2});
  [mv, idx] = max(spVal);
  ret.cut = cutVal(idx);
