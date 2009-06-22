function total = countInnerProducts(net, origDim)
%function total = countInnerProducts(net,origDim)
%Counts the number of inner products performed by the passed neural network.
%
nNodes = getNumNodes(net);
if nargin == 2,
  nNodes(1) = origDim;
end

total = 0;

for i=2:length(nNodes),
  total = total + (nNodes(i) * nNodes(i-1));
end

function numNodes = getNumNodes(net)
  numNodes = [net.inputs{1}.size zeros(1,length(net.layers))];
  for i=1:length(net.layers),
    numNodes(i+1) = net.layers{i}.size;
  end
  
