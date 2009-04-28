function [initPos, endPos] = getLayerLimits(ringsDist, layer)
%function [initPos, endPos] = getLayerLimits(ringsDist, layer)
%Returns the init and ending indexes of a given layer, based on the rings distribution.
%Therefore, data(initPos:endPos,:) will return all rings belonging to layer 'layer'
%
initPos = sum(ringsDist(1:layer-1)) + 1;
endPos = initPos + ringsDist(layer) - 1;
fprintf('Getting layer %d (Rings %d to %d). Total of %d rings.\n', layer, initPos, endPos, (endPos - initPos + 1));
