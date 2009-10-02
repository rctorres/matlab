function [otrn, oval, otst, pp] = extract_pca_seg_etot(trn, val, tst)
%function [otrn, oval, otst, pp] = extract_pca_etot(trn, val, tst)
%Extrai as PCAS Segmentadas a partir dos eventos normalizados por Energia Total
%
disp('Fazendo PCA Segmentada Usando Aneis Normalizados por Energia Total');
segmented = true;
[otrn, oval, otst, pp{1}] = event(trn, val, tst);
[otrn, oval, otst, pp{2}] = remove_mean(otrn, oval, otst);
pp{3}.pca = extract_pca(trn, segmented);
pp{3}.name = 'PCA-Seg';

%Gerando o vetor de W no formato correto p/ a projecao.
nSegs = length(pp{3}.pca);
W = cell(1,nSegs);
for i=1:nSegs,
  W{i} = pp{3}.pca{i}.W;
end

[otrn, oval, otst] = do_projection(otrn, oval, otst, W);
