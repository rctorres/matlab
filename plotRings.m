function plotRings(rings, dist, plotFmt, allTogether)
%function ret = plotRings(rings, dist, plotFmt, allTogether)
%This function plot a ring set, each layer in a windo
%   rings : a vector containing the rings
%   dist : a vector specifying how many rings per layer we have.
%   plotFmt : specifies the plotting format (color, line shape) of the ring
%   plot.
%   allTogether : If True, a sinlge graphic will be generated, with dotted
%   blue lines separating the layers. Otherwise, one graphic per layer is
%   generated.
	
  if allTogether == true,
    plot(rings, plotFmt);
    hold on;

    for d=1:length(dist),
      xVal = sum(dist(1:d));
      plot([xVal xVal], [0,1], 'k:');
    end
  else
    initPos = 1;
    for d=1:length(dist),
      endPos = initPos + dist(d) - 1;
      subplot(2,ceil(length(dist)/2),d);
      plot(rings(initPos:endPos), plotFmt);
      s = sprintf('Layer-%d',d);
      title(s);
      hold on;
      initPos = endPos + 1;
    end
            
  end
	
  hold off;
