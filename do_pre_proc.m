function [trn, val, tst] = do_pre_proc(pp, trn, val, tst)
%function [trn, val, tst] = do_pre_proc(trn, val, tst, pp)
%Realiza a cadeia de pre-processamento armazenada no vetor de celulas pp.
%Este vetor e, por exemplo, retornada pelas funcoes extract_ica_train,
%extract_pca_train, event, remove_mean, etc. Ou seja, esta funcao vai
%iterar por este vetor, e aplciar os pre-processamento, na ordem em que
%estao armazenados nos dados.
%

N = length(pp);

for i=1:N,
  pre_proc = pp{i};
  id = pre_proc.name(1:3);
  if strcmp(id, 'PCA') || strcmp(id, 'PCD') || strcmp(id, 'ICA'),
    fprintf('Projetando nas %s\n', pre_proc.name);
    [trn, val, tst] = project(trn, val, tst, pre_proc);
  else
    func = str2func(pre_proc.name);
    [trn, val, tst] = func(trn, val, tst, pre_proc);
  end
end

function [trn, val, tst] = project(trn, val, tst, pre_proc)
  W = pre_proc.W;
  nComp = pre_proc.nComp;

  