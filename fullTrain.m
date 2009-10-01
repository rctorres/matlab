function [oNet] = fullTrain(trn, val, tst, batchSize, nNodes, pp_func, tstIsVal)
%function [oNet] = fullTrain(trn, val, tst, batchSize, nNodes, pp_func, tstIsVal)
%Perform the standard training.
% -trn, val, tst - cell vectors with trn, val and tst data.
% -batchSize : The batch size for each epoch.
% -nNodes : the number of hidden nodes for the neural network.
% -pp_func : A pointer to a function the will be called once the trn, val,
%             tst sets are created. The function must have the following
%             interface [otrn, oval, otst] = pp_func(trn, val, tst). If
%             this parameter os ommited, or [], no pre-processing will be
%             done.
% -tstIsVal : If true, the data will be split into trn and
%             val only, and tst = val. 
%
%Returns:
% oNet: trained structure with the following fields:
%  1) If PCD was used:
%     - net : Cell vector with the network corresponding to each PCD.
%     - trnEvo : The evolution structure associated with each network.
%     - efic : Atructure containing the max, mean and std values of the SP
%              achieved for each PCD extracted.
% 
%  2) If cross val was done:
%     - net : Cell vector with the network corresponding to each deal.
%     - evo : The evolution structure associated with each network.
%     - sp : The SP values achieved in each deal.
%     - det : A matrix containing the detection values for each deal (ROC).
%     - fa : A matrix containing the false alarm values for each deal (ROC).
% 

  if (nargin ~= 7),
    error('Invalid number of parameters. See help!');
  end
  
  %If no pre-processing function was passed, we use a dummy one.
  if isempty(pp_func), pp_func = @do_nothing; end
  
  %Creating the neural network.
  if nNodes == 0,
    disp('Training a Fisher classifier.');
    net = newff2(trn);
  else
    disp('Training a non-linear classifier.');
    net = newff2(trn, [-1 1], nNodes, {'tansig', 'tansig'});
  end
  
  %Training parameters.
  net.trainParam.epochs = 5000;
  net.trainParam.max_fail = 100;
  net.trainParam.show = 0;
  net.trainParam.batchSize = batchSize;
  net.trainParam.useSP = true;
  numTrains = 5;

  %Doing the training.
  if (nNodes == 1),
    disp('Extracting the number of hidden nodes via PCD.');
    [trn, val, tst] = pp_func(trn, val, tst);
    fprintf('Data input dimension after pre-processing: %d\n', size(trn{1},1));
    [aux, oNet.net, oNet.evo, oNet.efic] = npcd(net, trn, val, tst, numTrains);
  else
    fprintf('Training a network (%s) by cross validation.\n', getNumNodesAsText(net));
    data = getCrossData(trn, val, tst, tstIsVal);
    oNet = crossVal(data, net, pp_func, tstIsVal);
  end


function data = getCrossData(trn, val, tst, tstIsVal)
  data = {[trn{1} val{1}], [trn{2} val{2}]};
  if tstIsVal,
    disp('The passed data set does NOT have a distinct test set.');
  else
    disp('The passed data set HAS a distinct test set.');
    data = {[data{1} tst{1}], [data{2} tst{2}]};
  end


function [otrn, oval, otst] = do_nothing(trn, val, tst)
%Dummy function to work with pp_function ponter.
  disp('Applying NO pre-processing...');
  otrn = trn;
  oval = val;
  otst = tst;
