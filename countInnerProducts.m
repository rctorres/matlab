function total = countInnerProducts(net)
%function total = countInnerProducts(net)
%Counts the number of inner products performed by the passed neural network.
%
nNodes = getNumNodes(net);
total = 0;

for i=2:length(nNodes),
  total = total + (nNodes(i-1) * nNodes(i));
end

function numNodes = getNumNodes(net)
  numNodes = [net.inputs{1}.size zeros(1,length(net.layers))];
  for i=1:length(net.layers),
    numNodes(i+1) = net.layers{i}.size;
  end
  