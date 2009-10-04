function [trn, val, tst, pp] = extract_ica_pca_train(trn, val, tst, par)
%function [trn, val, tst, pp] = extract_ica_pca_train(trn, val, tst, par)
%Extrai as ICAS da maneira correta p/ serem usadas no desenvolvimento de um
%classificador, reduzindo a domensao dos eventos via PCA.
%par deve ser uma estrutura contendo os seguintes campos:
% - norm : ponteiro p/ a funcao usada p/ normalizar (event, esf, etc)
% - ringsDist : vetor com a distribuicao dos aneis.
% - isSegmented : se true, fara a extracao segmentada.
% - nComp : um valor (caso nao-segmentado), ou um vetor, especificando o
%           numero de PCs p/ serem retidas do evento ou de cada segmento. 
%           Este parametro NAO pode ser vazio.
%
%

disp('Preparando os Conjuntos para Treino Com ICA Compactadas por PCA');

%Usando a normalizacao solicitada.
[trn, val, tst, pp{1}] = par.norm(trn, val, tst, par);

%Para o resto do codigo, fica mais facil testar se ringDist = [] p/
%extracao nao segmentada.
if ~par.isSegmented,
  par.ringsDist = [];
end

%Removendo a media.
[trn, val, tst, pp{2}] = remove_mean(trn, val, tst);

%Extraindo as PCAs
pp{3} = extract_pca(trn, par.ringsDist);
pp{3}.nComp = par.nComp;
if isempty(par.ringsDist),
  pp{3}.name = 'PCA';  
else
  pp{3}.name = 'PCA-Seg';
end

%Fazendo a compactacao do sinal.
W = do_reduction(pp{3}.W, par.ringsDist, par.nComp);

%Fazendo a projecao nas PCAs 
[trn, val, tst] = do_projection(trn, val, tst, W, par.ringsDist);

%Extraindo as ICAs
if isempty(par.ringsDist),
  pp{4}.W = extract_ica(trn, []);
  pp{4}.name = 'ICA';
else
  pp{4}.W = extract_ica(trn, par.nComp); %nComp e o novo ringsDist, apos a compactacao.
  pp{4}.name = 'ICA-Seg';
end

%Fazendo a projecao nas ICAs 
[trn, val, tst] = do_projection(trn, val, tst, pp{4}.W, par.nComp);


function W = do_reduction(pca, ringsDist, nComp)
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
