function [rNet, rNet_seg] = fullRelevance(ringsDist, trn, val, tst, net, net_seg, w, w_seg, nProj, nProj_seg, name)
%function [rNet, rNet_seg] = fullRelevance(ringsDist, trn, val, tst, net, net_seg, w, w_seg, nProj, nProj_seg, name)
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
%Esta funcao processa os casos segmentado e nao segmentado.
%

fprintf('Doing NON segmented %s case.\n', name);
subplot(1,2,1);
[pTrn, pVal, pTst] = get_pre_proc_data(trn, val, tst, w(1:nProj,:));
rNet = doJob(net, pTrn, pVal, pTst, name);

fprintf('Doing segmented %s case.\n', name);
subplot(1,2,2);
[pTrn, pVal, pTst] = joinSegments(trn, val, tst, ringsDist, nProj_seg, w_seg);
rNet_seg = doJob(net_seg, pTrn, pVal, pTst, [name ' seg']);


function r = doJob(net, trn, val, tst, name)
  r = doRelev(net, trn, val, tst);
  plotRelevanceValues(r.relev, r.rIdx, name);


function rNet = doRelev(net, trn, val, tst)
  %Doing relevance analysis using the trining set
  rNet.relev = doRelevanceAnalysis(net, [trn{1} trn{2}]);

  %Cutting at 10% of the most relevant info.
  rNet.rIdx = find(rNet.relev > (0.1*max(rNet.relev)));

  fprintf('Selected %d inputs after relevance analysys.\n', length(rNet.rIdx));

  %Getting the new relevant dataset.
  trn = getRelevData(trn, rNet.rIdx);
  val = getRelevData(val, rNet.rIdx);
  tst = getRelevData(tst, rNet.rIdx);

  %Training the new network.
  net = newff2([length(rNet.rIdx) 1  1], {'tansig', 'tansig'});
  net.trainParam.epochs = 2;
  net.trainParam.max_fail = 50;
  net.trainParam.show = 0;
  numTrains = 1;
  
  %calculando a melhor  rede ICA usando PCD.
  [pcd, netVec, e, trnE, valE, efic] = npcd(net, trn, val, tst, false, numTrains);

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
