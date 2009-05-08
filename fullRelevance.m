function rNet = fullRelevance(net, inTrn, inVal, inTst)
%rNet = fullRelevance(net, inTrn, inVal, inTst)
%Faz a analise de relevancia, seleciona as entradas mais relevantes, e
%treina uma nova rede (via PCD) so com elas. Retorna uma estrutura contendo:
% - netVec : o vetor com redes neurais treinadas a cada PCD extraida.
% - e : AS epocas p/c ada PCD.
% - trnE : Uma matriz com os erros de treinamento p/ cada epoca.
% - valE : Uma matriz com os erros de validacao p/ cada epoca.
% - efic : A eficiencia media, maxima e o desvio padrao, de cada PCD.
% - relev : Os valores de relevancia de cada entrada.
% - rIdx : Os indices das entradas mais relevantes.
%

%Doing relevance analysis using the trining set
rNet.relev = doRelevanceAnalysis(net, [inTrn{1} inTrn{2}]);

%Cutting at 10% of the most relevant info.
rNet.rIdx = find(relev > (0.1*max(relev)));

%Getting the new relevant dataset.
inTrn = getRelevData(inTrn, rIdx);
inVal = getRelevData(inVal, rIdx);
inTst = getRelevData(inTst, rIdx);

%Training the new network.
net = newff2([size(inTrn{1},1) 1  1], {'tansig', 'tansig'});
net.trainParam.epochs = 2000;
net.trainParam.max_fail = 50;
net.trainParam.show = 0;
numTrains = 5;
  
%calculando a melhor  rede ICA usando PCD.
[pcd, netVec, e, trnE, valE, efic] = npcd(net, inTrn, inVal, inTst, false, numTrains);

rNet.netVec = netVec;
rNet.e = e;
rNet.trnE = trnE;
rNet.valE = valE;
rNet.efic = efic;


function rData = getRelevData(data, rIdx)
  N = length(data);
  rData = cell(1,N);
  for i=1:N,
    rData{i} = data{i}(rIdx,:);
  end
