function ret = eqSets(data)
%function ret = eqSets(data)
%Takes a cell vector and returns the same cell vector, but with data sets of equalized sizes
%This is useful when training neural networks where the patterms must have equal number of 
%events. Also, PCA and ICA extraction might profit from this.
%

numPat = length(data);
ret = cell(1,numPat);

%Getting the total size of each set.
sizes = zeros(1,numPat);
for i=1:numPat,
  sizes(i) = size(data{i},2);
end

NumEv = max(sizes);

for i=1:numPat,
  incFac = ceil(NumEv / size(data{i},2));
  aux = repmat(data{i},1,incFac);
  aux = aux(:,1:NumEv);
  ret{i} = aux;
end
