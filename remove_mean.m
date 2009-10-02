function [oTrn, oVal, oTst, meanVec] = remove_mean(trn, val, tst)
%function [oTrn, oVal, oTst, meanVec] = remove_mean(trn, val, tst)
%Remove a media dos conjuntos de dados. A media de cada variavel sera calculada do vetor 'trn'
%meanVec e o vetor com as medias calculadas do conjunto de treino.
%

meanVec = mean(cell2mat(trn), 2);

oTrn = cell(size(trn));
oVal = cell(size(val));
oTst = cell(size(tst));

for i=1:length(trn),
  oTrn{i} = trn{i} - repmat(meanVec,1,size(trn{i},2));
  oVal{i} = val{i} - repmat(meanVec,1,size(val{i},2));
  oTst{i} = tst{i} - repmat(meanVec,1,size(tst{i},2));
end
