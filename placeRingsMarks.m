function placeRingsMarks(ringsDist, lim, doYDirection)
%function placeRingsMarks(ringsDist, lim, doYDirection)
%Sets the rings boundaries for each layer.
%ringsDist ia a vector containing the number of rings for each layer.
%lim(1) and lim(2) are, respectively, the minimum and maximum values for the mark to
%appear on the plot. This functions assumes that a plot with the rings
%already exists, and has the current focus. doYDirection, if true (default
%false), will place the rings marks along the Y axis.
%

hold on;
beg = 0.5;
for i=1:(length(ringsDist)-1),
  beg =  beg + ringsDist(i);
  
  if doYDirection,
    plot([lim(1) lim(2)], [beg beg], 'k:');
  else
    plot([beg beg], [lim(1) lim(2)], 'k:');
  end
end
hold off;
