function [spMax, spMean, spStd, netStr] = numNodesAnalysis(numNodesVec, numTrains, inTrn, inVal, inTst)
%function [maxSp, spMean, spStd, netStr] = numNodesAnalysis(numNodesVec, numTrains, inTrn, inVal, inTst)
%This function will take the default training, validating and testing sets for electrons and jets
%and will perform the hidden nodes validation, which means, varying the number of nodes in the 
%hidden layer taking the values in the numNodesVec. If a network with only one hidden node is
%requested, then the training is done, for this particular case, with NO hidden layer. For
%better statistics, for each case, the network is trained numTrains times. The function
%returns the mean and std values of the SPs obtained for each configuration.
%Also, the function returs an structure vector containing the best network for
%each case.
%

net = [];
trfFunc = 'tansig';

if length(find(numNodesVec <= 0)) > 0,
  error('numNodesVec must have only positive values\n');
end

start = 1;
nNodes = length(numNodesVec);
nInput = size(inTrn{1},1);
numNodesVec = sort(numNodesVec);

spMean = zeros(1,nNodes);
spStd = zeros(1,nNodes);
spMax = zeros(1,nNodes);
netStr = cell(1,nNodes);


for i=1:nNodes,
  if numNodesVec(i) == 1,
    fprintf('Training linear network (%d x 1)\n', nInput);
    net = newff2([nInput, 1], {trfFunc});
  else
    fprintf('Training non-linear network (%d x %d x 1)\n', nInput, numNodesVec(i));
    net = newff2([nInput, numNodesVec(i), 1], {trfFunc, trfFunc});
  end
  [netStr{i}, spMax(i), spMean(i), spStd(i)] = do_train(net, inTrn, inVal, inTst, numTrains);
end


function [outNet, maxEffic, meanEfic, stdEfic] = do_train(net, inTrn, inVal, inTst, numIt)
  net.trainParam.epochs = 2000;
  net.trainParam.show = 0;
  net.trainParam.max_fail = 50;

  [nVec, idx] = trainMany(net, inTrn, inVal, inTst, numIt);
  outNet.net = nVec{idx}.net;
  outNet.epoch = nVec{idx}.epoch;
  outNet.trnError = nVec{idx}.trnError;
  outNet.valError = nVec{idx}.valError;
  
  maxEffic = nVec{idx}.sp;

  %Getting the mean and std val of the SP efficiencies obtained through the iterations.
  ef = zeros(1,numIt);
  for j=1:numIt,
    ef(j) = nVec{j}.sp;
  end  
  meanEfic = mean(ef);
  stdEfic = std(ef);
