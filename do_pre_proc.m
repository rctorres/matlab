function [trn, val, tst] = do_pre_proc(pp, ringsDist, trn, val, tst)
%function [trn, val, tst] = do_pre_proc(pp, ringsDist, trn, val, tst)
%Realiza a cadeia de pre-processamento armazenada no vetor de celulas pp.
%Este vetor e, por exemplo, retornada pelas funcoes extract_ica_train,
%extract_pca_train, event, remove_mean, etc. Ou seja, esta funcao vai
%iterar por este vetor, e aplciar os pre-processamento, na ordem em que
%estao armazenados nos dados.
%

%Se pp nao for um vetor de celulas, a gente transforma num...
if ~iscell(pp),
  pproc{1} = pp;
else
  pproc = pp;
end

N = length(pproc);

for i=1:N,
  pre_proc = pproc{i};
  id = pre_proc.name(1:3);
  if strcmp(id, 'PCA') || strcmp(id, 'PCD') || strcmp(id, 'ICA'),
    fprintf('Fazendo projecao %s.\n', pre_proc.name);
    [trn, val, tst, ringsDist] = project(trn, val, tst, pre_proc, ringsDist);
  else
    func = str2func(pre_proc.name);
    [trn, val, tst] = func(trn, val, tst, pre_proc);
  end
end


function [trn, val, tst, ringsDist] = project(trn, val, tst, pre_proc, ringsDist)
  W = pre_proc.W;
  
  %Verifica se o campo com nComp existe. Se nao existir, projetamos na
  %dimensao total de W.
  if isfield(pre_proc, 'nComp'),
    nComp = pre_proc.nComp;
  else
    if iscell(W),
      N = length(W);
      nComp = zeros(1,N);
      for i=1:N,
        nComp(i) = size(W{i}, 1);
      end
    else
      nComp = size(W, 1);
    end
  end
  
  %Fazendo o corte de dimensoes.
  if iscell(W),
    for i=1:length(W),
      W{i} = W{i}(1:nComp(i),:);
    end
  else
    W = W(1:nComp,:);
  end
  
  [trn, val, tst] = do_projection(trn, val, tst, W, ringsDist);

  %Atualizando as camadas em ringsDist, ja que corti dimensoes.
  if iscell(W), ringsDist = nComp; end
  