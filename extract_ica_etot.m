function [otrn, oval, otst, pp] = extract_ica_etot(trn, val, tst)
%function [otrn, oval, otst] = extract_ica_etot(trn, val, tst)
%Extrai as ICAS a partir dos eventos normalizados por Energia Total

[otrn, oval, otst, pp{1}] = event(trn, val, tst);
pp{2}.W = extract_ica(trn);
pp{2}.name = 'ICA';
[otrn, oval, otst, pp{3}] = remove_mean(otrn, oval, otst);
[otrn, oval, otst] = do_projection(otrn, oval, otst, pp{2}.W);
