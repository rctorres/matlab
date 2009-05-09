function [trn val tst] = joinSegments(inTrn, inVal, inTst, ringsDist, inList, wVec)
%function [trn val tst] = joinSegments(inTrn, inVal, inTst, ringsDist, inList, wVec)
%Join the compacted data obtained from each segment individually into a new
%continuous event.
%This function will take the input datasets (as cell vectors) inTrn, inVal,
%inTst, as well as the number of original rings in each layer (ringsDist).
%Then, 'inList' will be a vector specifying the final dimension of each
%layer, after being projected onto its projecting matrix, pecified in the
%cell vector wVec. wVec must containg the projection matrix for each cell in a field named 'W' 
% (wVec.W) with each projection as a row vector, so wVec.W * data is correct.
%. At the end, all d_W obtained from each
%layer are concatenated, generatig a new, single input vent.
%The function returns the trn, val and tst datasets, also as cell vectors,
%but with the conpacted information of each layer concatenated as a single
%continuos event. This script is to be used when pseudo-segmented
%discrimination (where FEX is applied for each layer, but there is only one
%discriminator receiving all the segmented input a a single, 'new' event) 
%is intended.
%

%Getting sizes and limits.
nClasses = length(inTrn);
nLayers = length(ringsDist);
newEvSize = sum(inList);

%Creating the output vectors.
trn = cell(1,nClasses);
val = cell(1,nClasses);
tst = cell(1,nClasses);
for i=1:nClasses,
  trn{i} = zeros(newEvSize, size(inTrn{i},2), 'single');
  val{i} = zeros(newEvSize, size(inVal{i},2), 'single');
  tst{i} = zeros(newEvSize, size(inTst{i},2), 'single');
end

%Getting the data from each layer.
for i=1:nLayers,
  %Taking the limits of the new event for the current layer.
  [ip, ep] = getLayerLimits(inList,i);
  
  %Taking the projection matrix.
  W = wVec{i}.W(1:inList(i),:);
  
  %Getting the original layer data.
  lTrn = getLayer(inTrn, ringsDist, i);
  lVal = getLayer(inVal, ringsDist, i);
  lTst = getLayer(inTst, ringsDist, i);

  %Projecting onto W.
  [lTrn, lVal, lTst] = get_pre_proc_data(lTrn, lVal, lTst, W);

  %Inserting the layer info in the final output vectors.
  for j=1:nClasses,
    trn{j}(ip:ep,:) = lTrn{j};
    val{j}(ip:ep,:) = lVal{j};
    tst{j}(ip:ep,:) = lTst{j};
  end  
end
