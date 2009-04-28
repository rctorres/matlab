function placeRingsMarks(ringsDist, minY, maxY)
%function placeRingsMarks(ringsDist, minY, maxY)
%Sets the rings boundaries for each layer.
%ringsDist ia a vector containing the number of rings for each layer. minY
%and maxY are, respectively, the minimum and maximum values for the mark to
%appear on the plot. This functions assumes that a plot with the rings
%already exists, and has the current focus.
%

hold on;
beg = 0.5;
for i=1:(length(ringsDist)-1),
  beg =  beg + ringsDist(i);
  plot([beg beg], [minY maxY], 'k:');
end
hold off;
