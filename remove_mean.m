function [oTrn, oVal, oTst, meanVec] = remove_mean(trn, val, tst, mv)
%function [oTrn, oVal, oTst, meanVec] = remove_mean(trn, val, tst, mv)
%Remove a media dos conjuntos de dados.
%Se um vetor de medias 'mv' previamente calculado e passado, ele sera usado nos 3 conjuntos.
%Do contrario, a media de cada variavel sera calculada do vetor 'trn'
%

if nargin == 3,
  meanVec = mean([trn{1} trn{2}], 2);
else
  meanVec = mv;
end

oTrn = cell(size(trn));
oVal = cell(size(val));
oTst = cell(size(tst));

for i=1:length(trn),
  oTrn{i} = trn{i} - repmat(meanVec,1,size(trn{i},2));
  oVal{i} = val{i} - repmat(meanVec,1,size(val{i},2));
  oTst{i} = tst{i} - repmat(meanVec,1,size(tst{i},2));
end
