function [otrn, oval, otst, pp] = extract_ica_etot(trn, val, tst)
%function [otrn, oval, otst, pp] = extract_ica_etot(trn, val, tst)
%Extrai as ICAS a partir dos eventos normalizados por Energia Total

disp('Fazendo ICA Usando Aneis Normalizados por Energia Total');
segmented = false;
[otrn, oval, otst, pp{1}] = event(trn, val, tst);
[otrn, oval, otst, pp{2}] = remove_mean(otrn, oval, otst);
pp{3}.W = extract_ica(trn, segmented);
pp{3}.name = 'ICA';
[otrn, oval, otst] = do_projection(otrn, oval, otst, pp{3}.W);
