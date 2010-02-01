function [trn, val, tst, pp] = spherization(trn, val, tst, par)
%function [otrn, oval, otst, pp] = spherization(trn, val, tst)
%Faz a normalizacao por esferizacao. trn, val, tst precisam ser vetores 
%de celulas, com 1 celula p/ cada classe. ps e a estrutura usada p/ 
%normalizar.
% - par.ps : opcional. Estrutura com os valores de media e desvios para
%            serem usados na esferizacao. Se o campo ps nao existir, ou a 
%            estrutura for nula, a funcao calculara estes valores.
%
  disp('Fazendo normalizacao por Esferizacao.');
  
  pp.name = 'spherization';
  
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
  [aux, ps] = mapstd(data);
  clear aux;
  