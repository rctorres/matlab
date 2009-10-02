function [otrn, oval, otst, pp] = extract_ica_train(trn, val, tst, par)
%function [otrn, oval, otst, pp] = extract_ica_train(trn, val, tst, par)
%Extrai as ICAS da maneira correta p/ serem usadas no desenvolvimento de um
%classificador. par deve ser uma estrutura contendo os seguintes campos:
% - norm : ponteiro p/ a funcao usada p/ normalizar (event, esf, etc)
% - ringsDist : vetor com a distribuicao dos aneis. Se for [], a extracaos
% era NAO segmentada. Do contrario, faco a extracao segmentada.
%

disp('Preparando os Conjuntos para Treino Com ICA');

%Usando a normalizacao solicitada.
[otrn, oval, otst, pp{1}] = par.norm(trn, val, tst);

%Removendo a media.
[otrn, oval, otst, pp{2}] = remove_mean(otrn, oval, otst);

%Extraindo as ICAs
pp{3}.W = extract_ica(trn, par.ringsDist);
if isempty(par.ringsDist),
  pp{3}.name = 'ICA';
else
  pp{3}.name = 'ICA-Seg';
end

%Fasendo a projecao nas ICAs 
[otrn, oval, otst] = do_projection(otrn, oval, otst, pp{3}.W, par.ringsDist);
