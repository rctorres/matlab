function [trn, val, tst] = do_pre_proc(pp, ringsDist, trn, val, tst)
%function [trn, val, tst] = do_pre_proc(pp, ringsDist, trn, val, tst)
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


function [trn, val, tst] = project(trn, val, tst, pre_proc, ringsDist)
  W = pre_proc.W;
  nComp = pre_proc.nComp;

  if iscell(W),
    for i=1:length(W),
      W{i} = W{i}(1:nComp(i),:);
    end
  else
    W = W(1:nComp,:);
  end
  
  [trn, val, tst] = do_projection(trn, val, tst, W, ringsDist);
  