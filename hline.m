function r = hline(y, mode, xmin, xmax)
%function hline(y, mode, xmin, xmax)
%Adds an horizontal line to a given plot.
%You must specify the position in Y-axis where the line will be drawn.
%Optionally, you can set the start and end points of the line across
%X-axis, otherwise, the function will take the limits in X for the plot.
%Finally, a mode (color, format, etc) can also be set.
%
  lim = get(gca, 'XLim');
  if nargin < 2, mode = 'k-'; end
  if nargin < 3, xmin = lim(1); end
  if nargin < 4, xmax = lim(2); end
  r = plot([xmin, xmax], [y, y], mode);
end
