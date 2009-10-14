function [trn, val, tst, pp] = spherization_had_fix(trn, val, tst, par)
%function [otrn, oval, otst, pp] = spherization_had_fix(trn, val, tst)
%Faz a normalizacao por esferizacao, dividindo a secao hadronica por
%um valor fixo. trn, val, tst precisam ser vetores de celulas, com 
%1 celula p/ cada classe. ps e a estrutura usada p/ normalizar.
% - par.ps : opcional. Estrutura com os valores de media e desvios para
%            serem usados na esferizacao. Se o campo ps nao existir, ou a 
%            estrutura for nula, a funcao calculara estes valores.
%
  disp('Fazendo normalizacao por Esferizacao com Hadronica Fixa.');
  
  pp.name = 'spherization_had_fix';
  
  if isstruct(par) && isfield(par, 'ps'),
    disp('Usando os valores de media e desvios passados.');
    pp.ps = par.ps;
  else
    disp('Calculando a media e os desvios dos conjuntos.');
    pp.ps = get_spherization_values(cell2mat(trn));
  end

  for i=1:length(trn),
    trn{i} = mapstd('apply', trn{i}, pp.ps);
    val{i} = mapstd('apply', val{i}, pp.ps);
    tst{i} = mapstd('apply', tst{i}, pp.ps);
  end
  
  
function ps = get_spherization_values(data)
  hadFixVal = 1000; %Fator de normalizacao da secao hadronica.
  hadInitIdx = 89; % Indice onde comeca a secao hadronica.
  
  [aux, ps] = mapstd(data);
  clear aux;
  
  %Colocando a media = 0 e std = hadFix para os indices correspondentes a aneis
  %pertencentes a secao hadronica. Assim, o proprio mapstd se encarregara
  %da normalizacao correta.
  ps.xmean(hadInitIdx:end) = 0;
  ps.xstd(hadInitIdx:end) = hadFixVal;
  