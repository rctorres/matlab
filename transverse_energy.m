function [trn, val, tst, pp] = transverse_energy(trn, val, tst, par)
%function [trn, val, tst, pp] = transverse_energy(trn, val, tst)
%Faz a normalizacao por energia transversa. trn, val, tst precisam ser
%vetores de celulas, com 1 celula p/ cada classe.
%
  pp.name = 'transverse_energy';
  disp('Fazendo normalizacao por energia transversa.');

  for i=1:length(trn),
    trn{i} = do_et(trn{i});
    val{i} = do_et(val{i});
    tst{i} = do_et(tst{i});
  end


function data = do_et(data)
  %Aproximo a energia transversa pegando os 4 primeiros aneis da EM2.
  data = data ./ repmat(sum(data(73:76,:)), size(data,1), 1);
