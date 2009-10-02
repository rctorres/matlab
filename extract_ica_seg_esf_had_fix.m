function [otrn, oval, otst, pp] = extract_ica_seg_esf_had_fix(trn, val, tst)
%function [otrn, oval, otst] = extract_ica_etot(trn, val, tst)
%Extrai as ICAS Segmentadas a partir dos eventos normalizados por
%Esferizacao com Hadronica Fixa.
%

disp('Fazendo ICA Segmentadas Usando Aneis Normalizados por Esferizacao com Hadronica Fixa.');
segmented = true;
[otrn, oval, otst, pp{1}] = spherization_had_fix(trn, val, tst);
[otrn, oval, otst, pp{2}] = remove_mean(otrn, oval, otst);
pp{3}.W = extract_ica(trn, segmented);
pp{3}.name = 'ICA-Seg';
[otrn, oval, otst] = do_projection(otrn, oval, otst, pp{3}.W);