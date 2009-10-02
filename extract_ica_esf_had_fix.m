function [otrn, oval, otst, pp] = extract_ica_esf_had_fix(trn, val, tst)
%function [otrn, oval, otst, pp] = extract_ica_esf_had_fix(trn, val, tst)
%Extrai as ICAS a partir dos eventos normalizados por Esferizacao com
%Hadronica Fixa.
disp('Fazendo ICA Usando Aneis Normalizados por Esferizacao com Hadronica Fixa');
segmented = false;
[otrn, oval, otst, pp{1}] = spherization_had_fix(trn, val, tst);
[otrn, oval, otst, pp{2}] = remove_mean(otrn, oval, otst);
pp{3}.W = extract_ica(trn, segmented);
pp{3}.name = 'ICA';
[otrn, oval, otst] = do_projection(otrn, oval, otst, pp{3}.W);
