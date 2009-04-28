function layerData = getLayer(data, ringsDist, layer)
%function layerData = getLayer(data, ringsDist, layer)
%Returns the rings corresponding to a given layer. This script is usefull when
%data processing is done for each ring layer individually. 'data' is either a matrix, or
%a cell matrix containing the ring sets. ringDist is a vector containing the number of 
%rings in each layer (8 64 8...), and layer, is the ID (1-started) of the layer you want.
%The function returns a matrix, or cell array, containing the same dataset, but only with the
%rings of the desired layer. The rings in data must be organized so that each event is a collumn.
%

if iscell(data),
  nSet = length(data);
  layerData = cell(1,nSet);
  for i=1:nSet,
    layerData{i} = slice(data{i},ringsDist,layer);
  end
else
  layerData = slice(data,ringsDist,layer);
end

function ret = slice(data, ringsDist, layer)
  [initPos, endPos] = getLayerLimits(ringsDist, layer)
  ret = data(initPos:endPos,:);
