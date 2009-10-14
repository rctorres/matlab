function [otrn, oval, otst] = do_projection(trn, val, tst, W, ringsDist)
%function [otrn oval otst] = do_projection(trn, val, tst, W, ringsDist)
%Projeta os datasets em W. Se W for um vetor de celulas, eu farei a
%projecao de cada camada (usando ringsDist), e depois farei a concatenacao
%dos segmentos projetaods, formando uma unica entrada.
%Em W, cada direcao tem que ser uma LINHA!
%

if iscell(W),
  [otrn, oval, otst] = project_segmented(trn, val, tst, W, ringsDist);
else
  [otrn, oval, otst] = project(trn, val, tst, W);
end



function [trn, val, tst] = project(trn, val, tst, W)
  fprintf('Projetando nas %d componentes.\n', size(W,1));
  for i=1:length(trn),
    trn{i} = W * trn{i};
    val{i} = W * val{i};
    tst{i} = W * tst{i};
  end


function [otrn, oval, otst] = project_segmented(trn, val, tst, W, ringsDist)
  %Getting sizes and limits.
  nClasses = length(trn);
  nLayers = length(ringsDist);

  %Pegando o tamanho do evento apos a projecao.
  inList = zeros(1,nLayers);
  for i=1:nLayers,
    inList(i) = size(W{i},1);
  end
  newEvSize = sum(inList);

  %Creating the output vectors.
  otrn = cell(1, nClasses);
  oval = cell(1, nClasses);
  otst = cell(1, nClasses);
  for i=1:nClasses,
    otrn{i} = zeros(newEvSize, size(trn{i},2));
    oval{i} = zeros(newEvSize, size(val{i},2));
    otst{i} = zeros(newEvSize, size(tst{i},2));
  end

  %Getting the data from each layer.
  for i=1:nLayers,
    %Taking the limits of the new event for the current layer.
    [ip, ep] = getLayerLimits(inList,i);

    %Getting the original layer data.
    lTrn = getLayer(trn, ringsDist, i);
    lVal = getLayer(val, ringsDist, i);
    lTst = getLayer(tst, ringsDist, i);

    %Projecting onto W.
    [lTrn, lVal, lTst] = project(lTrn, lVal, lTst, W{i});

    %Inserting the layer info in the final output vectors.
    for j=1:nClasses,
      otrn{j}(ip:ep,:) = lTrn{j};
      oval{j}(ip:ep,:) = lVal{j};
      otst{j}(ip:ep,:) = lTst{j};
    end  
  end
