function W = extract_pca(trn, isSegmented, ringsDist)
%function W = extract_ica(trn, isSegmented)
%Extrai as PCAs. Se isSegmented = false, a extracao sera nao segmentada. 
%Do contrario, a extracao sera feita camada a camada, e W sera 
%um vetor de celulas, com as projecoes. Se ringsDist for omitido, a funcao
%usara o default [8 64 8 8 4 4 4]. As projecoes serao retornadas nas LINHAS
%de W.
%

if nargin < 3, ringsDist = [8 64 8 8 4 4 4]; end

data = cell2mat(trn);

if isSegmented,
  N = length(ringsDist);
  W = cell(1,N);
  for i=1:N,
    fprintf('Extraindo as %d ICAs do caso segmentado.\n', size(ldata,1));
    ldata = getLayer(data, ringsDist, i);
    W{i} = do_job(ldata);
  end  
else
  fprintf('Extraindo as %d ICAs do caso NAO segmentado.\n', size(data,1));
  W = do_job(data);
end

function proj = do_job(data)
  [W, en] = pcacov(cov(data'));
  proj.W = W';
  proj.en = en;
  