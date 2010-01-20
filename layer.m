function [otrn, oval, otst, pp] = layer(trn, val, tst, par)
%function [trn, val, tst, pp] = layer(trn, val, tst)
%Faz a normalizacao por camada. trn, val, tst precisam ser
%vetores de celulas, com 1 celula p/ cada classe.
%par.ringsDist: distribuicao dos aneis em cada camada
%par.secDist: info de a qual secao cada conj de aneis pertence.
%
  pp.name = 'layer';
  pp.ringsDist = par.ringsDist;
  pp.secDist = par.secDist;
  disp('Fazendo normalizacao por camada.');

  nClasses = length(trn);
  otrn = cell(1, nClasses);
  oval = cell(1, nClasses);
  otst = cell(1, nClasses);
  
  for i=1:nClasses,
    otrn{i} = ringer_norm(trn{i}, par.ringsDist, par.secDist, 'set');
    oval{i} = ringer_norm(val{i}, par.ringsDist, par.secDist, 'set');
    otst{i} = ringer_norm(tst{i}, par.ringsDist, par.secDist, 'set');
  end

