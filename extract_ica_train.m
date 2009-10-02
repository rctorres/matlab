function [trn, val, tst, pp] = extract_ica_train(trn, val, tst, par)
%function [trn, val, tst, pp] = extract_ica_train(trn, val, tst, par)
%Extrai as ICAS da maneira correta p/ serem usadas no desenvolvimento de um
%classificador. par deve ser uma estrutura contendo os seguintes campos:
% - norm : ponteiro p/ a funcao usada p/ normalizar (event, esf, etc)
% - ringsDist : vetor com a distribuicao dos aneis. Se for [], a extracaos
% era NAO segmentada. Do contrario, faco a extracao segmentada.
%

disp('Preparando os Conjuntos para Treino Com ICA');

%Usando a normalizacao solicitada.
[trn, val, tst, pp{1}] = par.norm(trn, val, tst);

%Removendo a media.
[trn, val, tst, pp{2}] = remove_mean(trn, val, tst);

%Extraindo as ICAs
pp{3}.W = extract_ica(trn, par.ringsDist);
if isempty(par.ringsDist),
  pp{3}.name = 'ICA';
else
  pp{3}.name = 'ICA-Seg';
end

%Fasendo a projecao nas ICAs 
[trn, val, tst] = do_projection(trn, val, tst, pp{3}.W, par.ringsDist);
