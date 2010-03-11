function [oNet] = fullTrain(trn, val, tst, trainParam, nNodes, pp, tstIsVal, doCrossVal)
%function [oNet] = fullTrain(trn, val, tst, trainParam, nNodes, pp, tstIsVal, doCrossVal)
%Perform the standard training.
% -trn, val, tst - cell vectors with trn, val and tst data.
% -trainParam : structure containing th taining parameters 
%               (I'll do net.trainParam = trainParam).
% -nNodes : the number of hidden nodes for the neural network.
% - pp :      A structure containing 2 fileds named 'func' and 'par'.
%            'func' must be a pointer to a pre-processing function to be 
%             executed on the data. 'par' must be a structure containing 
%             any parameter that must be used by func. The calling
%             procedure is [trn,val,tst,] = pp.func(trn, val, tst, pp.par)
%             if func does not use any par, pp.par must be [].
%             If this parameter os ommited, or [], no pre-processing will 
%             be done.
% -tstIsVal : If true, the data will be split into trn and
%             val only, and tst = val. 
% -doCrossVal : If true, a cross validation analysis will be done.
%               Othewise, a single training will be performed
%
%Returns:
% oNet: trained structure with the following fields:
%  1) If PCD was used:
%     - net : Cell vector with the network corresponding to each PCD.
%     - trnEvo : The evolution structure associated with each network.
%     - efic : Atructure containing the max, mean and std values of the SP
%              achieved for each PCD extracted.
% 
%  2) If PCD was not used was done:
%     - net : Cell vector with the network corresponding to each deal.
%     - evo : The evolution structure associated with each network.
%     - sp : The SP values achieved in each deal.
%     - det : A matrix containing the detection values for each deal (ROC).
%     - fa : A matrix containing the false alarm values for each deal (ROC).
%
%     If cross_val was not used, the returned structure will be the same as
%     for cross val, but you will have only one occurence of each field.
%

  if (nargin ~= 8),
    error('Invalid number of parameters. See help!');
  end
  
  %If no pre-processing function was passed, we use a dummy one.
  if isempty(pp),
    pp.func = @do_nothing;
    pp.par = [];
  end
  
  numTrains = 2;

  %Doing the training.
  if (nNodes == 1),
    disp('Extracting the number of hidden nodes via PCD.');
    [trn, val, tst, oNet.pp] = calculate_pre_processing(trn, val, tst, pp);
    fprintf('Data input dimension after pre-processing: %d\n', size(trn{1},1));
    net = create_network(trn, nNodes, trainParam);
    [aux, oNet.net, oNet.evo, oNet.efic] = npcd(net, trn, val, tst, numTrains);
  else
    if doCrossVal,
      net = create_network(trn, nNodes, trainParam);
      fprintf('Training a network (%s) by cross validation.\n', getNumNodesAsText(net));
      data = getCrossData(trn, val, tst, tstIsVal);
      oNet = crossVal(data, net, pp, tstIsVal);
    else
      [trn, val, tst, oNet.pp] = calculate_pre_processing(trn, val, tst, pp);
      fprintf('Data input dimension after pre-processing: %d\n', size(trn{1},1));
      net = create_network(trn, nNodes, trainParam);
      fprintf('Training the network (%s).\n', getNumNodesAsText(net));
      [netVec, I] = trainMany(net, trn, val, tst, numTrains);
      oNet.net = netVec{I}.net;
      oNet.evo = netVec{I}.trnEvo;
      out = nsim(oNet.net, tst);
      [spVec, cutVec, oNet.det, oNet.fa] = genROC(out{1}, out{2});
      oNet.sp = max(spVec);
    end
  end


function net = create_network(trn, nNodes, trainParam)
  if nNodes == 0,
    disp('Creating a Fisher Classifier.');
    net = newff2(trn);
  else
    disp('Creating a Non-linear Classifier.');
    net = newff2(trn, [-1 1], nNodes, {'tansig', 'tansig'});
  end
  
  net.trainParam = trainParam;
    


function data = getCrossData(trn, val, tst, tstIsVal)
  data = {[trn{1} val{1}], [trn{2} val{2}]};
  if tstIsVal,
    disp('The passed data set does NOT have a distinct test set.');
  else
    disp('The passed data set HAS a distinct test set.');
    data = {[data{1} tst{1}], [data{2} tst{2}]};
  end


function [otrn, oval, otst, pp] = do_nothing(trn, val, tst, par)
%Dummy function to work with pp_function ponter.
  disp('Applying NO pre-processing...');
  otrn = trn;
  oval = val;
  otst = tst;
  pp = [];
