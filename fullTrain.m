function [oNet, oNet_seg] = fullTrain(trn, val, tst, doSpher, doFisher, proj, proj_seg, ringsDist)
%function [oNet, oNet_seg] = fullTrain(trn, val, tst, doSpher, doFisher, proj, proj_seg, ringsDist)
%Perform segmented and non-segmented training.
% trn, val, tst - cell vectors with trn, val and tst data.
% doSpher - if true, will apply mapstd to the inputs.
% doFisher : trains a linear classifier. Otherwise, a neural-network is trained with hiddedn nodes calculated via PCD.
% proj : A projection structure for the non-segmented case containing the following fields:
%    - W : The projection matrix, with one projection per ROW.
%    - N : The number of projections to use.
% proj_seg : A projection structure for the segmented case containing the following fields:
%    - W : A cell vector, where each cell is a structure containing a field named 'W' containing
%            the projections direction for that given layer. Each ROW is a direction.
%    - N : A vector with the number of projections to use for each layer.
%
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

doProj = false;
doProjSeg = false;

if (nargin == 5),
  disp('Will perform ONLY a non-segmented training without ANY projection.');
elseif (nargin == 6),
  doProj = true;
  disp('Will perform non-segmented projection.');
elseif (nargin == 8),
  doProj = true;
  doProjSeg = true;
  disp('Will perform segmented and non-segmented projection and training.');
else
  error('Invalid number of parameters. See help!');
end

%Non seg case.
if doProj,
  [inTrn, inVal, inTst] = get_pre_proc_data(trn, val, tst, proj.W(1:proj.N,:));
else
  inTrn = trn; inVal = val; inTst = tst;
end
fprintf('Input dimension for the NON segmented case: %d\n', size(inTrn{1},1));
oNet = trainNetwork(inTrn, inVal, inTst, doSpher, doFisher);

%Seg case.
if doProjSeg,
  [inTrn, inVal, inTst] = joinSegments(trn, val, tst, ringsDist, proj_seg.N, proj_seg.W);
  fprintf('Input dimension for the segmented case: %d\n', size(inTrn{1},1));
  oNet_seg = trainNetwork(inTrn, inVal, inTst, doSpher, doFisher);
end



function oNet = trainNetwork(inTrn, inVal, inTst, doSpher, doFisher)
  %Should we spherize?

  ps = [];
  if doSpher,
    [inTrn, inVal, inTst, ps] = normalize(inTrn, inVal, inTst);
  end

  %Creating the neural network.  
  net = [];
  if doFisher,
    disp('Training a Fisher classifier.');
    net = newff2([size(inTrn{1},1) 1], {'tansig'});
  else
    disp('Training a non-linear classifier.');
    net = newff2([size(inTrn{1},1) 1  1], {'tansig', 'tansig'});
  end
  net.trainParam.epochs = 2000;
  net.trainParam.max_fail = 50;
  net.trainParam.show = 0;
  numTrains = 5;

  %Doing the training.
  if doFisher,
    [netVec, I] = trainMany(net, inTrn, inVal, inTst, numTrains);
    oNet = netVec{I};
  else
    [aux, oNet.net, oNet.epoch, oNet.trnError, oNet.valError, oNet.efic] = npcd(net, inTrn, inVal, inTst, false, numTrains);
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
  [aux, ps] = mapstd(double(data));
  clear data aux;
    
  %Applying onto the dataset.
  for i=1:N,
    nTrn{i} = single(mapstd('apply', double(trn{i}), ps));
    nVal{i} = single(mapstd('apply', double(val{i}), ps));
    nTst{i} = single(mapstd('apply', double(tst{i}), ps));
  end
 