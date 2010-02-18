function [trn, val, tst, pp] = extract_pcd_train(trn, val, tst, par)
%function [trn, val, tst, pp] = extract_pcd_train(trn, val, tst, par)
%Extrai as PCDS da maneira correta p/ serem usadas no desenvolvimento de um
%classificador. par deve ser uma estrutura contendo os seguintes campos:
% - norm : ponteiro p/ a funcao usada p/ normalizar (event, esf, etc)
% - ringsDist : vetor com a distribuicao dos aneis.
% - isSegmented : se true, fara a extracao segmentada.
% - pcd : Estrutura com a info das PCDs extraidas (tal como retornada por
%         extract e extract_segmented.
% - doTanh : se true, vai passar os conjuntos, apos a projecao nas PCDs
%            pela tangente hiperbolica.
% - nComp : um valor (caso nao-segmentado), ou um vetor, especificando o
%           numero de PCs p/ serem retidas do evento ou de cada segmento. 
%           Se este campo for [], TODAS as PCs disponiveis serao utilizadas.
%

disp('Preparando os Conjuntos para Treino Com PCD');

%Usando a normalizacao solicitada.
[trn, val, tst, pp{1}] = par.norm(trn, val, tst, par);
normName = pp{1}.name;

%Para o resto do codigo, fica mais facil testar se ringDist = [] p/
%extracao nao segmentada.
if ~par.isSegmented,
  par.ringsDist = [];
end

if isstruct(par.pcd),
  fprintf('Pegando as PCDs PREVIAMENTE extraidas com normalizacao "%s"\n', normName);
  extPCD = par.pcd.(normName);
else
  disp('Extraindo as PCDs do Zero!');
  if isempty(par.ringsDist),
   [extPCD.W, aux1, aux2, extPCD.efic] = npcd(par.pcd, trn, val, tst);
  else
    extPCD = extract_pcd_seg(par.pcd, par.ringsDist, trn, val, tst);
  end
end

%Pegando as PCDs
pp{2}.W = extPCD.W;
pp{2}.efic = extPCD.efic;
pp{2}.nComp = par.nComp;
if isempty(par.ringsDist),
  pp{2}.name = 'PCD';
else
  pp{2}.name = 'PCD-Seg';
  pp{2}.ringsDist = par.ringsDist;
end

%Fazendo a compactacao do sinal.
W = do_reduction(pp{2}.W, par.ringsDist, par.nComp);

%Fazendo a projecao nas PCDs 
[trn, val, tst] = do_projection(trn, val, tst, W, par.ringsDist);

if par.doTanh,
  disp('Passando os datasets pela Tangente Hiperbolica');
  pp{3}.name = 'tanh';
  for i=1:length(trn),
    trn{i} = tanh(trn{i});
    val{i} = tanh(val{i});
    tst{i} = tanh(tst{i});
  end
end


function W = do_reduction(pcd, ringsDist, nComp)
  if isempty(ringsDist), %Nao segmentado
    W = pcd(1:nComp,:);
  else %Segmentado
    N = length(pcd);
    W = cell(1,N);
    for i=1:N,
      W{i} = pcd{i}(1:nComp(i),:);
    end
  end
   

function ret = extract_pcd_seg(netRef, ringsDist, trn, val, tst)
  [trnAlgo, maxNumPCD, numNodes, trfFunc, usingBias, trnParam] = getNetworkInfo(netRef);

  for i=1:length(ringsDist),
    %Pegando os aneis da camada desejada.
    trn = getLayer(trn, ringsDist, i);
    val = getLayer(val, ringsDist, i);
    tst = getLayer(tst, ringsDist, i);

    fprintf('Pegando os %d aneis da camada %d\n', ringsDist(i), i);

    net = newff2(trn, [-1 1], numNodes.hidNodes, trfFunc, trnAlgo);
    net.trainParam = trnParam;
    [ret.W{i}, aux, aux2, ret.efic{i}] = npcd(net, trn, val, tst);
  end  


function [trnAlgo, maxNumPCD, numNodes, trfFunc, usingBias, trnParam] = getNetworkInfo(net)
  %Getting the network information regarding its topology

  %Taking the training algo.
  trnAlgo = net.trainFcn;

  %The maximum number of PCDs to be extracted is equal to the input size.
  maxNumPCD = net.inputs{1}.size;
  
  %Getting the input and output ranges.
  numNodes.inRange = net.inputs{1}.range;
  numNodes.outRange = net.outputs{length(net.outputs)}.range;

  %Taking the other layer's size and training function.
  numNodes.hidNodes = zeros(1,(length(net.layers)-1));
  trfFunc = cell(1,length(net.layers));
  usingBias = zeros(1,length(net.layers));
  for i=1:length(net.layers),
    if i < length(net.layers),
      numNodes.hidNodes(i) = net.layers{i}.size;
    end
    trfFunc{i} = net.layers{i}.transferFcn;
    usingBias(i) = net.layers{i}.userdata.usingBias;
  end
  
  trnParam = net.trainParam;
