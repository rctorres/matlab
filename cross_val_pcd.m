function ret = cross_val_pcd(nPCDs, data, net, pp, tstIsVal, nBlocks, nDeal, nTrains)
%function ret = cross_val_pcd(nPCDs, data, net, pp, tstIsVal, nBlocks, nDeal, nTrains)
%
%WARNING: THIS FUNCTION ONLY WORKS FOR THE 2 CLASSES CASE!!!
%

if (nargin < 4) || (isempty(pp)),
  pp.func = @do_nothing;
  pp.par = [];
end
if nargin < 5, tstIsVal = false; end
if nargin < 6, nBlocks = 12; end
if nargin < 7, nDeal = 10; end
if nargin < 8, nTrains = 5; end
if nargin > 8, error('Invalid number of parameters. See help!'); end

data = create_blocks(data, nBlocks);

ret.pcd = cell(1, nDeal);
ret.net = cell(nDeal, nPCDs);
ret.evo = cell(nDeal, nPCDs);
ret.sp = zeros(nDeal, nPCDs);
ret.det = cell(1, nDeal);
ret.fa = cell(1, nDeal);
ret.pp = cell(1, nDeal);

[net_par.hidNodes, net_par.trfFunc, net_par.trnParam] = getNetworkInfo(net);
for d=1:nDeal,
  fprintf('DEAL %d\n', d); 
  [trn val tst] = deal_sets(data, tstIsVal);
  [trn val tst ret.pp{d}] = calculate_pre_processing(trn, val, tst, pp);
  [ret.pcd{d} ret.net(d,:) ret.evo(d,:) ret.sp(d,:) ret.det{d} ret.fa{d}] = get_pcd(net_par, trn, val, tst, nTrains, nPCDs);
end


function bdata = create_blocks(data, nBlocks)
%Creating the blocks. bdata{c,b}, where c is the class idx, and b is the
%block idx.
%
  nClasses = length(data);
  bdata = cell(nClasses, nBlocks);
  
  %Ramdomly placing the events within the blocks.
  for c=1:nClasses,
    for b=1:nBlocks,
      bdata{c,b} = data{c}(:,b:nBlocks:end);
    end
  end
  

function [trn val tst] = deal_sets(data, tstIsVal)
%Create the training, validation and test sets based on how many blocks per
%set we should have.

  [nClasses, nBlocks] = size(data);
  trn = cell(1,nClasses);
  val = cell(1,nClasses);
  tst = cell(1,nClasses);
  
  for c=1:nClasses,
    idx = randperm(nBlocks);
    if tstIsVal,
      trn{c} = cell2mat(data(c,idx(1:2:end)));
      val{c} = cell2mat(data(c,idx(2:2:end)));
      tst{c} = val{c};
    else
      trn{c} = cell2mat(data(c,idx(1:3:end)));
      val{c} = cell2mat(data(c,idx(2:3:end)));
      tst{c} = cell2mat(data(c,idx(3:3:end)));
    end
  end
 

function [pcd onet oevo sp det fa] = get_pcd(net_par, trn, val, tst, nTrains, numPCD)
  nROC = 500;
  net = newff2(trn, [-1 1], net_par.hidNodes, net_par.trfFunc);
  net.trainParam = net_par.trnParam;
  [pcd, onet, oevo] = npcd(net, trn, val, tst, nTrains, 0, numPCD);
  det = zeros(numPCD, nROC);
  fa = zeros(numPCD, nROC);
  sp = zeros(1, numPCD);

  for i=1:numPCD,
    out = nsim(onet{i}, tst);
    [spVec, cutVec, det(i,:), fa(i,:)] = genROC(out{1}, out{2}, nROC);
    sp(i) = max(spVec);
  end

  
function [hidNodes, trfFunc, trnParam] = getNetworkInfo(net)
  %Getting the network information regarding its topology

  hidNodes = zeros(1,(length(net.layers)-1));
  trfFunc = cell(1,length(net.layers));
  for i=1:length(net.layers),
    if i < length(net.layers),
      hidNodes(i) = net.layers{i}.size;
    end
    trfFunc{i} = net.layers{i}.transferFcn;
  end
  
  trnParam = net.trainParam;

  
function [otrn, oval, otst, pp] = do_nothing(trn, val, tst, par)
%Dummy function to work with pp_function ponter.
  disp('Applying NO pre-processing...');
  otrn = trn;
  oval = val;
  otst = tst;
  pp = [];
  
