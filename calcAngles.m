function ang = calcAngles(A, B, force90Deg)
%function [ang]=calcAngles(A, B, force90Deg)
% Calculates the angles (in degrees) between the columns of matrices A and B.
%if force90Deg = true (default is false), then, all angles will be limited
%to the [0,90] degrees range by subtracting it from 180 degrees and taking
%it modulus.
%

if nargin < 2, B = A; end
if nargin < 3, force90Deg = false; end


% Normalizes A and B
for c = 1:size(A,2)
  A(:,c) = A(:,c) ./ norm(A(:,c));
  B(:,c) = B(:,c) ./ norm(B(:,c));
end

% Find the angles. Due to numerical precision error, the result of p might
% be slightly (10^-16) above 1, causing some results to be complex. To
% overcome this situation, since A and B were normalized (modulus = 1), 
% the maximum size of p wil allways be 1. So there is no problem in 
% Assigning values >1 to 1.
p = A'*B;
p(abs(p)>1) = 1;
ang = acosd(p);

%Limiting the result to +- 90 degrees.
if force90Deg,
  I = find(ang > 90);
  ang(I) = abs(180 - ang(I));
end

if nargout == 0,
  angPlot = [ang ang(:,end)];
  angPlot = [angPlot; angPlot(end,:)];
  pcolor(angPlot);
  title('Angles Between Vectors');
  ylabel('A');
  xlabel('B');
  colorbar;
end
