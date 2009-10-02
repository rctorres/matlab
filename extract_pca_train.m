function [otrn, oval, otst, pp] = extract_pca_train(trn, val, tst, par)
%function [otrn, oval, otst, pp] = extract_pca_train(trn, val, tst, par)
%Extrai as PCAS da maneira correta p/ serem usadas no desenvolvimento de um
%classificador. par deve ser uma estrutura contendo os seguintes campos:
% - norm : ponteiro p/ a funcao usada p/ normalizar (event, esf, etc)
% - ringsDist : vetor com a distribuicao dos aneis. Se for [], a extracaos
% era NAO segmentada. Do contrario, faco a extracao segmentada.
%

disp('Preparando os Conjuntos para Treino Com PCA');

%Usando a normalizacao solicitada.
[otrn, oval, otst, pp{1}] = par.norm(trn, val, tst);

%Removendo a media.
[otrn, oval, otst, pp{2}] = remove_mean(otrn, oval, otst);

%Extraindo as PCAs
pp{3} = extract_pca(trn, par.ringsDist);

%Formatando W p/ que seja passado no formato correto p/ a do_projection.
if isempty(par.ringsDist),
  pp{3}.name = 'PCA';
else
  pp{3}.name = 'PCA-Seg';
end

%Fasendo a projecao nas PCAs 
[otrn, oval, otst] = do_projection(otrn, oval, otst, pp{3}.W);
