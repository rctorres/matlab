function r = vline(x, mode, ymin, ymax)
%function vline(x, mode, ymin, ymax)
%Adds a vertical line to a given plot.
%You must specify the position in X-axis where the line will be drawn.
%Optionally, you can set the start and end points of the line across
%Y-axis, otherwise, the function will take the limits in Y for the plot.
%Finally, a mode (color, format, etc) can also be set.
%
  lim = get(gca, 'YLim');
  if nargin < 2, mode = 'k-'; end
  if nargin < 3, ymin = lim(1); end
  if nargin < 4, ymax = lim(2); end
  r = plot([x, x], [ymin, ymax], mode);
end
