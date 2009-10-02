function W = extract_pca(trn, ringsDist)
%function W = extract_pca(trn, ringsDist)
%Extrai as PCAs. Se ringsDist = [], ou omitido, a extracao sera nao segmentada. 
%Do contrario, a extracao sera feita camada a camada, e W sera 
%um vetor de celulas, com as projecoes. Se ringsDist for omitido, a funcao
%usara o default [8 64 8 8 4 4 4]. As projecoes serao retornadas nas LINHAS
%de W.
%

if nargin < 2, ringsDist = []; end

data = cell2mat(trn);

if isempty(ringsDist),
  fprintf('Extraindo as %d PCAs do caso NAO segmentado.\n', size(data,1));
  W = do_job(data);
else
  N = length(ringsDist);
  W = cell(1,N);
  for i=1:N,
    ldata = getLayer(data, ringsDist, i);
    fprintf('Extraindo as %d PCAs do caso segmentado.\n', size(ldata,1));
    W{i} = do_job(ldata);
  end  
end

function proj = do_job(data)
  [W, en] = pcacov(cov(data'));
  proj.W = W';
  proj.en = en;
  