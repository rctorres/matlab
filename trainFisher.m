function [oNet, oNet_seg] = trainFisher(trn, val, tst, proj, proj_seg, ringsDist)

doProj = false;
doProjSeg = false;

if (nargin == 3),
  disp('Will perform ONLY a non-segmented training without ANY projection.');
elseif (nargin == 4),
  doProj = true;
  disp('Will perform non-segmented projection.');
elseif (nargin == 6),
  doProjSeg = true;
  disp('Will perform segmented projection and training.');
else
  error('Invalid number of parameters. See help!');
end

%Creating the neural network
net = newff2([size(trn{1},1) 1], {'tansig'});
net.trainParam.epochs = 2000;
net.trainParam.max_fail = 50;
net.trainParam.show = 0;
numTrains = 5;

%Non seg case.
if doProj,
  [inTrn, inVal, inTst] = get_pre_proc_data(trn, val, tst, proj.W(1:proj.N,:));
  [inTrn, inVal, inTst] = normalize(inTrn, inVal, inTst, proj);
else
  inTrn = trn; inVal = val; inTst = tst;
end
[netVec, I] = trainMany(net, inTrn, inVal, inTst, numTrains);
oNet = netVec{I};

%Seg case.
if doProjSeg,
  [inTrn, inVal, inTst] = joinSegments(trn, val, tst, ringsDist, proj_seg.N, proj_seg.W);
  [inTrn, inVal, inTst] = normalize(inTrn, inVal, inTst, proj_seg);
  [netVec, I] = trainMany(net, inTrn, inVal, inTst, numTrains);
  oNet_seg = netVec{I};
end

function [nTrn, nVal, nTst] = normalize(trn, val, tst, proj)
  nTrn = trn;
  nVal = val;
  nTst = tst;

  %Should we apply mapstd?
  if isfield(proj, 'ps'),
    disp('Applying input spherization.')
    for i=1:length(trn),
      nTrn{i} = single(mapstd('apply', double(trn{i}), proj.ps));
      nVal{i} = single(mapstd('apply', double(val{i}), proj.ps));
      nTst{i} = single(mapstd('apply', double(tst{i}), proj.ps));
    end
  end
