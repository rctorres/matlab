function [oNet, oNet_seg] = fullTrain(trn, val, tst, batchSize, doSpher, remMean, nNodes, skipNSeg, proj, proj_seg, ringsDist)
%function [oNet, oNet_seg] = fullTrain(trn, val, tst, batchSize, doSpher, remMean, nNodes, skipNSeg, proj, proj_seg, ringsDist)
%Perform segmented and non-segmented training.
% batchSize : The batch size for each epoch.
% trn, val, tst - cell vectors with trn, val and tst data.
% doSpher - if true, will apply mapstd to the inputs.
% remMean - if true, will remove the mean of the input events, calculating it from the training set 
% nNodes : structure containing the number of nodes for the non segmented
% (nseg)  and segmented (seg) cases
%          (in this order).if 0, trains a fisher classifier. If 1, then a neural-network is trained and the number of
%          hidden nodes are calculated via PCD. Otherwise, a network is trained with nNodes nodes in
%          the hidden layer.
% skipNSeg : If true, will skip the non-segmented training. To skip the segment training, just set proj_seg = [].
% proj : A projection structure for the non-segmented case containing the following fields:
%    - W : The projection matrix, with one projection per ROW.
%    - N : The number of projections to use.
%        If proj = [], then no projection is performed, but the training is done.
% proj_seg : A projection structure for the segmented case containing the following fields:
%    - W : A cell vector, where each cell is a structure containing a field named 'W' containing
%            the projections direction for that given layer. Each ROW is a direction.
%    - N : A vector with the number of projections to use for each layer.
%        If proj_seg = [], then no projection is performed, AND the training is not done (skipped).
%
% ringsDist - Vector containing the number of rings in each layer.
%Returns:
% oNet and oNet_seg : trained structure with the following fields:
%   For the non-linear case:
%     - net: Either the net structure (fisher) or a cell vector with the net structure for each PCD.
%     - epoch: Either the epochs vector (fisher) or a matrix where the rows are the epochs for each PCD.
%     - trnError: Either the trn error vector (fisher) or a matrix where the rows are the trn error for each PCD.
%     - valError: Either the val error vector (fisher) or a matrix where the rows are the val error for each PCD.
%     - ps: if doSpher = true, will contain the ps structure to use with mapstd for inut spherization.
%     - efic: only for the non-linear case. It is the mean, std and max SP values obtained for each PCD.
%
% If any of the cases (seg or non-seg) are skipped, it corresponding return structure is set to [].
% 

if (nargin ~= 11),
  error('Invalid number of parameters. See help!');
end

if remMean,
  disp('Removendo a media dos dados...');
  [trn, val, tst] = remove_mean(trn, val, tst);
else
  disp('Dados serao processados SEM a remocao da media...');
end

%Non seg case.
if ~skipNSeg,
  if size(proj,1) ~= 0,
    disp('Performing non-segmented projection.');
    [inTrn, inVal, inTst] = get_pre_proc_data(trn, val, tst, proj.W);
  else
    inTrn = trn; inVal = val; inTst = tst;
  end
  fprintf('Input dimension for the NON segmented case: %d\n', size(inTrn{1},1));
  oNet = trainNetwork(inTrn, inVal, inTst, doSpher, nNodes.nseg, batchSize);
else
  disp('Skipping the non-segmented training.');
  oNet = [];
end

%Seg case.
if size(proj_seg,1) ~= 0,
  [inTrn, inVal, inTst] = joinSegments(trn, val, tst, ringsDist, proj_seg);
  fprintf('Input dimension for the segmented case: %d\n', size(inTrn{1},1));
  oNet_seg = trainNetwork(inTrn, inVal, inTst, doSpher, nNodes.seg, batchSize);
else
  disp('Skipping the segmented training.');
  oNet_seg = [];
end



function oNet = trainNetwork(inTrn, inVal, inTst, doSpher, nNodes, batchSize)
  %Should we spherize?

  ps = [];
  nNodes = abs(nNodes);
  
  if doSpher,
    [inTrn, inVal, inTst, ps] = normalize(inTrn, inVal, inTst);
  end

  %Creating the neural network.  
  if nNodes == 0,
    disp('Training a Fisher classifier.');
    net = newff2(inTrn);
  else
    disp('Training a non-linear classifier.');
    net = newff2(inTrn, [1 -1], nNodes, {'tansig', 'tansig'});
  end
  net.trainParam.epochs = 5000;
  net.trainParam.max_fail = 100;
  net.trainParam.show = 0;
  net.trainParam.batchSize = batchSize;
  net.trainParam.useSP = true;
  numTrains = 5;

  %Doing the training.
  if (nNodes == 1),
    disp('Extracting the number of hidden nodes via PCD.');
    [aux, oNet.net, oNet.trnEvo, oNet.efic] = npcd(net, inTrn, inVal, inTst, false, numTrains);
  else
    fprintf('Training an specific network with %d nodes in the hidden layer.\n', nNodes);
    [netVec, I] = trainMany(net, inTrn, inVal, inTst, numTrains);
    oNet = netVec{I};
  end

  %Saving the spherization values.
  if doSpher,
    oNet.ps = ps;
  end


function [nTrn, nVal, nTst, ps] = normalize(trn, val, tst)
  N = length(trn);
  nTrn = cell(1,N);
  nVal = cell(1,N);
  nTst = cell(1,N);
  
  disp('Applying input spherization.');

  %Calculating the pre-proc parameters.
  data = [];
  for i=1:N,
    data = [data trn{i}];
  end
  [aux, ps] = mapstd(data);
  clear data aux;
    
  %Applying onto the dataset.
  for i=1:N,
    nTrn{i} = mapstd('apply', trn{i}, ps);
    nVal{i} = mapstd('apply', val{i}, ps);
    nTst{i} = mapstd('apply', tst{i}, ps);
  end
 
