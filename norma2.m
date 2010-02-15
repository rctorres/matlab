function [trn, val, tst, pp] = norma2(trn, val, tst, par)
%function [trn, val, tst, pp] = norma2(trn, val, tst)
%Faz a normalizacao por norma 2. trn, val, tst precisam ser
%vetores de celulas, com 1 celula p/ cada classe.
%
  pp.name = 'norma2';
  disp('Fazendo normalizacao por norma 2.');

  nClasses = length(trn);
  
  for i=1:nClasses,
    trn{i} = do_norma2(trn{i});
    val{i} = do_norma2(val{i});
    tst{i} = do_norma2(tst{i});
  end


function data = do_norma2(data)
  for i=1:size(data,2);
    data(:,i) = data(:,i) ./ norm(data(:,i));
  end
