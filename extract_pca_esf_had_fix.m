function [otrn, oval, otst, pp] = extract_pca_esf_had_fix(trn, val, tst)
%function [otrn, oval, otst] = extract_pca_esf_had_fix(trn, val, tst)
%Extrai as PCAS a partir dos eventos normalizados por Esferizacao com
%Hadronica Fixa.
disp('Fazendo PCA Usando Aneis Normalizados por Esferizacao com Hadronica Fixa');
segmented = false;
[otrn, oval, otst, pp{1}] = spherization_had_fix(trn, val, tst);
[otrn, oval, otst, pp{2}] = remove_mean(otrn, oval, otst);
pp{3}.W = extract_pca(trn, segmented);
pp{3}.name = 'PCA';
[otrn, oval, otst] = do_projection(otrn, oval, otst, pp{3}.W);
