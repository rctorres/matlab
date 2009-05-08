function [meanSp, stdSp, maxSp] = getEficValues(netVec)
%function [meanSp, stdSp, maxSp] = getEficValues(netVec)
%It runs over a netVec vector (like returned by trainMany), or any
%cell vector ontaining a field names 'sp'. It will colect all SP values
%read, and will return the mean SP, the SP deviation and the maximum SP
%achieved.
%

N = length(netVec);

v = zeros(1,N);

for i=1:N,
  v(i) = netVec{i}.sp;
end

meanSp = mean(v);
stdSp = std(v);
maxSp = max(v);
