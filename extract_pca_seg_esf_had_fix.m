function [otrn, oval, otst, pp] = extract_pca_seg_esf_had_fix(trn, val, tst)
%function [otrn, oval, otst, pp] = extract_pca_etot(trn, val, tst)
%Extrai as PCAS Segmentadas a partir dos eventos normalizados por
%Esferizacao com Hadronica Fixa.
%

disp('Fazendo PCA Segmentadas Usando Aneis Normalizados por Esferizacao com Hadronica Fixa.');
segmented = true;
[otrn, oval, otst, pp{1}] = spherization_had_fix(trn, val, tst);
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
