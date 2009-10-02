function [trn, val, tst, pp] = extract_pca_train(trn, val, tst, par)
%function [trn, val, tst, pp] = extract_pca_train(trn, val, tst, par)
%Extrai as PCAS da maneira correta p/ serem usadas no desenvolvimento de um
%classificador. par deve ser uma estrutura contendo os seguintes campos:
% - norm : ponteiro p/ a funcao usada p/ normalizar (event, esf, etc)
% - ringsDist : vetor com a distribuicao dos aneis. Se for [], a extracao
%               sera NAO segmentada. Do contrario, faco a extracao segmentada.
% - nComp : um valor (caso nao-segmentado), ou um vetor, especificando o
%           numero de PCs p/ serem retidas do evento ou de cada segmento. 
%           Se este campo for [], TODAS as PCs serao utilizadas.
%

disp('Preparando os Conjuntos para Treino Com PCA');

%Usando a normalizacao solicitada.
[trn, val, tst, pp{1}] = par.norm(trn, val, tst);

%Removendo a media.
[trn, val, tst, pp{2}] = remove_mean(trn, val, tst);

%Extraindo as PCAs
pp{3} = extract_pca(trn, par.ringsDist);
if isempty(par.ringsDist),
  pp{3}.name = 'PCA';  
else
  pp{3}.name = 'PCA-Seg';
end

%Fazendo a compactacao do sinal, se solicitado.
W = do_reduction(pp{3}.W, par.ringsDist, par.nComp);

%Fazendo a projecao nas PCAs 
[trn, val, tst] = do_projection(trn, val, tst, W, par.ringsDist);


function W = do_reduction(pca, ringsDist, nComp)
  %So faco alguma coisa se nComp nao for vazio. Do contrario, nao mexo em nada 
  if isempty(nComp),
    disp('Nao farei nenhuma reducao via PCA');
    W = pca;
  else
    disp('Reduzindo a dimensao do evento via PCA');
    if isempty(ringsDist), %Nao segmentado
      W = pca(1:nComp,:);
    else %Segmentado
      N = length(pca);
      W = cell(1,N);
      for i=1:N,
        W{i} = pca{i}(1:nComp(i),:);
      end
    end
  end
