function [le, ue] = get_safe_errors(y, e, lower_lim, upper_lim)
%function [le, ue] = get_safe_errors(y, e, lower_lim, upper_lim)
%This function receives a vector and the its associated errors e. The
%function then ensures that y+e and y-e will stay within the limits
%specified in lower_lim (defaults to zero) and upper_lim (defaults to 100).
%The function return [le, ue] where le is the lower error vector and ue is
%the upper error vector, so they can be used in errorbar (example:
%errorbar(y, le, ue)).

  if nargin < 3, lower_lim = 0; end
  if nargin < 4, upper_lim = 100; end

  max_y = y + e;
  min_y = y - e;
  
  ue = e;
  le = e;
  
  iu = find(max_y > upper_lim);
  il = find(min_y < lower_lim);
  
  ue(iu) = upper_lim - y(iu);
  le(il) = y(il);
end
