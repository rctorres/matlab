function histLog(data, nBims)
%function histLog(data, nBims)
%Produces the histogram of data, using nBims (just like hist), but the y
%axis is presented in log scale. If data is a cell vector, then there will 
%be one color for each cell. In that case, each cell MUST be a vector, not a matrix.
%

if nargin == 1,
  nBims = 10;
elseif (nargin > 2) || (nargin < 1)
  error('Invalid number of input parameters. See help.');
end

if iscell(data),
  N = length(data);
  x = zeros(nBims, N);
  y = zeros(nBims, N);
  for i=1:N,
    [yi,xi] = hist(data{i}, nBims);
    x(:,i) = xi;
    y(:,i) = yi;
  end
else
  [y,x] = hist(data, nBims);
end

bar(x,y,1.0,'grouped');
set(gca, 'YScale', 'log');
