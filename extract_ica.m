function W = extract_ica(trn, isSegmented, ringsDist)
%function W = extract_ica(trn, isSegmented)
%Extrai as ICAs. Se isSegmented = false, a extracao sera nao segmentada. 
%Do contrario, a extracao sera feita camada a camada, e W sera 
%um vetor de celulas, com as projecoes. Se ringsDist for omitido, a funcao
%usara o default [8 64 8 8 4 4 4].
%

if nargin < 3, ringsDist = [8 64 8 8 4 4 4]; end

data = cell2mat(trn);

if isSegmented,
  N = length(ringsDist);
  W = cell(1,N);
  for i=1:N,
    ldata = getLayer(data, ringsDist, i);
    fprintf('Extraindo as %d ICAs do caso segmentado.\n', size(ldata,1));
    W{i} = jadeica(ldata);
  end  
else
  fprintf('Extraindo as %d ICAs do caso NAO segmentado.\n', size(data,1));
  W = jadeica(data);
end
