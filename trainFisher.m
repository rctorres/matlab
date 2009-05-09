function [oNet, oNet_seg] = trainFisher(trn, val, tst, doSpher, proj, proj_seg, ringsDist)
%function [oNet, oNet_seg] = trainFisher(trn, val, tst, doSpher, proj, proj_seg, ringsDist)

doProj = false;
doProjSeg = false;

if (nargin == 4),
  disp('Will perform ONLY a non-segmented training without ANY projection.');
elseif (nargin == 5),
  doProj = true;
  disp('Will perform non-segmented projection.');
elseif (nargin == 7),
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
oNet = trainNetwork(inTrn, inVal, inTst, doSpher);

%Seg case.
if doProjSeg,
  [inTrn, inVal, inTst] = joinSegments(trn, val, tst, ringsDist, proj_seg.N, proj_seg.W);
  fprintf('Input dimension for the segmented case: %d\n', size(inTrn{1},1));
  oNet_seg = trainNetwork(inTrn, inVal, inTst, doSpher);
end


function oNet = trainNetwork(inTrn, inVal, inTst, doSpher)
  %Should we spherize?
  ps = [];
  if doSpher,
    [inTrn, inVal, inTst, ps] = normalize(inTrn, inVal, inTst);
  end
  
  %Creating the neural network
  net = newff2([size(inTrn{1},1) 1], {'tansig'});
  net.trainParam.epochs = 2000;
  net.trainParam.max_fail = 50;
  net.trainParam.show = 0;
  numTrains = 5;
  [netVec, I] = trainMany(net, inTrn, inVal, inTst, numTrains);
  oNet = netVec{I};
  
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
 