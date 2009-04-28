function [trn, val, tst] = createTrainingSets(data)
%function [trn, val, tst] = createTrainingSets(data)
%Pega a estrutura tal como retornada por load_rings, e divide os eventos
%nos conjuntos de treino, validacao e teste.
%

  totalEvents = length(data.lvl1_id);
  
  strNames = fieldnames(data);
  trn = data;
  val = data;
  tst = data;
  for i=1:length(strNames),
    aux = getfield(data, strNames{i});
    fName = strNames{i};
    trn.(fName) = aux(:,1:3:end);
    val.(fName) = aux(:,2:3:end);
    tst.(fName) = aux(:,3:3:end);
  end
