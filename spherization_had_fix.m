function [otrn, oval, otst, pp] = spherization_had_fix(trn, val, tst, par)
%function [otrn, oval, otst, pp] = spherization_had_fix(trn, val, tst)
%Faz a normalizacao por esferizacao, dividindo a secao hadronica por
%um valor fixo. trn, val, tst precisam ser vetores de celulas, com 
%1 celula p/ cada classe. ps e a estrutura usada p/ normalizar.
%
  disp('Fazendo normalizacao por Esferizacao com Hadronica Fixa.');
  
  hadFixVal = 1000; %Fator de normalizacao da secao hadronica.
  hadInitIdx = 89; % Indice onde comeca a secao hadronica.
  
  [aux, ps] = mapstd(cell2mat(trn));
  clear aux;
  
  %Colocando a media = 0 e std = hadFix para os indices correspondentes a aneis
  %pertencentes a secao hadronica. Assim, o proprio mapstd se encarregara
  %da normalizacao correta.
  ps.xmean(hadInitIdx:end) = 0;
  ps.xstd(hadInitIdx:end) = hadFixVal;
  
  nClasses = length(trn);
  otrn = cell(1, nClasses);
  oval = cell(1, nClasses);
  otst = cell(1, nClasses);
  
  for i=1:nClasses,
    otrn{i} = mapstd('apply', trn{i}, ps);
    oval{i} = mapstd('apply', val{i}, ps);
    otst{i} = mapstd('apply', tst{i}, ps);
  end

  pp.ps = ps;
  pp.name = 'spherization_had_fix';
  