function [otrn, oval, otst, pp] = extract_pca_etot(trn, val, tst)
%function [otrn, oval, otst, pp] = extract_pca_etot(trn, val, tst)
%Extrai as PCAS a partir dos eventos normalizados por Energia Total

disp('Fazendo PCA Usando Aneis Normalizados por Energia Total');
segmented = false;
[otrn, oval, otst, pp{1}] = event(trn, val, tst);
[otrn, oval, otst, pp{2}] = remove_mean(otrn, oval, otst);
pp{3}.pca = extract_pca(trn, segmented);
pp{3}.name = 'PCA';
[otrn, oval, otst] = do_projection(otrn, oval, otst, pp{3}.pca.W);
