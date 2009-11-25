function [trn, val, tst] = do_pre_proc(pp, trn, val, tst)
%function [trn, val, tst] = do_pre_proc(pp, trn, val, tst)
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
    [trn, val, tst] = project(trn, val, tst, pre_proc);
  elseif strcmp(pre_proc.name, 'tanh'),
    [trn, val, tst] = do_tanh(trn, val, tst);
  elseif strcmp(pre_proc.name, 'relevance'),
    [trn, val, tst] = do_relevance(trn, val, tst, pre_proc);
  else
    func = str2func(pre_proc.name);
    [trn, val, tst] = func(trn, val, tst, pre_proc);
  end
end

function [trn, val, tst] = do_relevance(trn, val, tst, pre_proc)
  fprintf('Selecionando as %d componentes relevantes.\n', length(pre_proc.relevComp));
  for i=1:length(trn),
    trn{i} = trn{i}(pre_proc.relevComp, :);
    val{i} = val{i}(pre_proc.relevComp, :);
    tst{i} = tst{i}(pre_proc.relevComp, :);
  end


function [trn, val, tst] = do_tanh(trn, val, tst)
  disp('Calculando a tangente hiperbolica das projecoes.');
  for i=1:length(trn),
    trn{i} = tanh(trn{i});
    val{i} = tanh(val{i});
    tst{i} = tanh(tst{i});
  end


function [trn, val, tst] = project(trn, val, tst, pre_proc)
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
    ringsDist = pre_proc.ringsDist;
    for i=1:length(W),
      W{i} = W{i}(1:nComp(i),:);
    end
  else
    W = W(1:nComp,:);
    ringsDist = [];
  end
  
  [trn, val, tst] = do_projection(trn, val, tst, W, ringsDist);
  