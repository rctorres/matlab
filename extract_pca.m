function pca = extract_pca(trn, ringsDist)
%function pca = extract_pca(trn, ringsDist)
%Extrai as PCAs. Se ringsDist = [], ou omitido, a extracao sera nao segmentada. 
%Do contrario, a extracao sera feita camada a camada, e W sera 
%um vetor de celulas, com as projecoes. O retorno e uma estrutura contendo
%os campos W e en. Se for extracao segmentada, ambos serao um vetor de
%celulas, onde cada celula contem a info de um segmento. Em W, cada LINHA e
%uma projecao. (Z = W*X).
%

if nargin < 2, ringsDist = []; end

data = cell2mat(trn);

if isempty(ringsDist),
  fprintf('Extraindo as %d PCAs do caso NAO segmentado.\n', size(data,1));
  [W, en] = do_job(data);
else
  N = length(ringsDist);
  W = cell(1,N);
  en = cell(1,N);
  for i=1:N,
    ldata = getLayer(data, ringsDist, i);
    fprintf('Extraindo as %d PCAs do caso segmentado.\n', size(ldata,1));
    [W{i}, en{i}] = do_job(ldata);
  end  
end

pca.W = W;
pca.en = en;


function [W, en] = do_job(data)
  [W, en] = pcacov(cov(data'));
  W = W'; %Uma PCA (direcao) por LINHA.
  