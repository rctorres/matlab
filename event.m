function [otrn, oval, otst, pp] = event(trn, val, tst, par)
%function [trn, val, tst, pp] = event(trn, val, tst)
%Faz a normalizacao por evento (energia total). trn, val, tst precisam ser
%vetores de celulas, com 1 celula p/ cada classe.
%
  pp.name = 'event';
  disp('Fazendo normalizacao por evento.');

  nClasses = length(trn);
  otrn = cell(1, nClasses);
  oval = cell(1, nClasses);
  otst = cell(1, nClasses);
  
  for i=1:nClasses,
    otrn{i} = do_event(trn{i});
    oval{i} = do_event(val{i});
    otst{i} = do_event(tst{i});
  end


function ndata = do_event(data)
  energyThreshold = 0.001;
  etot = abs(sum(data));
  etot(etot <= energyThreshold) = 1;
  ndata = data ./ repmat(etot, size(data,1), 1);
