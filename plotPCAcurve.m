function res = plotPCAcurve(val, nRet, retStyle, discStyle, lineStyle)
%function plotPCAcurve(val, nRet, retStyle, discStyle, lineStyle)
%Plots the accumulated energy over the number of considered PCAs.
%nRet, if supplied will tell how many components were actually retained.
%The points of the components retained will be plot for visualization.
%

if nargin < 3, retStyle = 'bo'; end
if nargin < 4, discStyle = 'r*'; end
if nargin < 5, lineStyle = 'k--'; end

N = length(val);
res = zeros(1,N);

if nargin == 1,
  nRet = N;
end

Etot = sum(val);

res(1) = 100*val(1)/Etot;
for i=2:N,
	res(i) = res(i-1) + ( 100*val(i)/Etot );
end

if nargout == 0,
  plot([1:nRet], res(1:nRet), retStyle);
  if nRet < N,
    hold on;
    plot([nRet+1:N], res(nRet+1:end), discStyle);
    legend(sprintf('Retained   (%d)', nRet), sprintf('Discarded (%d)', N-nRet), 'Location', 'Southeast');
    plot([1:N], res, lineStyle);
  end
end
