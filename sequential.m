function [trn, val, tst, pp] = sequential(trn, val, tst, par)
%function [trn, val, tst, pp] = sequential(trn, val, tst, ringsDist, par)
%Realiza a normalizacao sequencial. par precisa ter os seguintes campos:
% - ringsDist : Numero de aneis em cada camada.
% - secDist : vetor de celulas indicando, por uma string, se a camada e EM
%             ou HD.
%
  pp.name = 'sequential';
  disp('Fazendo normalizacao por evento.');
  fprintf('Fazendo normalizacao sequencial.\n');
  for i=1:length(trn),
    trn{i} = ringer_norm(trn{i}, par.ringsDist, par.secDist, pp.name);
    val{i} = ringer_norm(val{i}, par.ringsDist, par.secDist, pp.name);
    tst{i} = ringer_norm(tst{i}, par.ringsDist, par.secDist, pp.name);
  end
