function [trn, val, tst, pp] = remove_mean(trn, val, tst, par)
%function [oTrn, oVal, oTst, meanVec] = remove_mean(trn, val, tst, par)
%Remove a media dos conjuntos de dados. A media de cada variavel sera calculada do vetor 'trn'
%pp e o vetor com as medias calculadas do conjunto de treino.
% par.means : vetor com medias previamente calculadas. Neste caso, eu so
% removo as medias usando este vetor, ao inves de calcula-las.
%
disp('Removendo a Media dos Conjuntos.');

pp.name = 'remove_mean';

if isstruct(par) && isfield(par, 'means'),
  disp('Usando o vetor de medias passado.');
  pp.means = par.means;
else
  disp('Calculando a media dos conjuntos.');
  pp.means = mean(cell2mat(trn), 2);
end

for i=1:length(trn),
  trn{i} = trn{i} - repmat(pp.means,1,size(trn{i},2));
  val{i} = val{i} - repmat(pp.means,1,size(val{i},2));
  tst{i} = tst{i} - repmat(pp.means,1,size(tst{i},2));
end
