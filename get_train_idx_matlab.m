function [in_data, out_data, idx] = get_train_idx_matlab(trn, val, tst)
%function [trnIdx, valIdx, tstIdx] = get_train_idx_matlab(trn, val, tst)
%Esta funcao pega o conjunto de trino, validacao e teste passado, onde cada
%conjunto e um vetor de celulas, e retorna:
% in_data: a concatenacao dos conjuntos de trn, val e tst, para o toolbox
% de redes neurais do Matlab.
% out_data, os valores de alvos correspondentes (+1 p/ eletrons e -1 para
% jatos).
% id : Estrutura com os indices em in_data onde se encontram os
% eventos outrora em trn, val e tst.
%
%Se tst for omitido da entrada, a funcao trabalhara somente com trn e val.
%

aux = cell(1,4);
aux{1} = trn{1};
aux{2} = trn{2};
aux{3} = val{1};
aux{4} = val{2};

if nargin == 3,
  aux{5} = tst{1};
  aux{6} = tst{2};
end

N = length(aux);
out = cell(1,N);
ind = cell(1,N);
signal = 1;
initPos = 1;
for i=1:N,
  nEv = size(aux{i},2);
  endPos = initPos + (nEv-1);
  
  ind{i} = (initPos:endPos);
  out{i} = signal*ones(1,nEv);
  
  initPos = endPos + 1;
  signal = -signal;
end

in_data = cell2mat(aux);
out_data = cell2mat(out);
idx.trainInd = [ind{1} ind{2}];
idx.valInd = [ind{3} ind{4}];

if nargin == 3,
  idx.testInd = [ind{5} ind{6}];
else
  idx.testInd = [];
end
