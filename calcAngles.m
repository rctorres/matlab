function ang = calcAngles(A,B)
%function [ang]=calcAngles(A,B)
% Calculates the angles (in degrees) between the columns of matrices A and B.
%

if nargin == 1,
  B = A;
end

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
%ang(ang > 90) = 180 - ang(ang > 90);

if nargout == 0,
  angPlot = [ang ang(:,end)];
  angPlot = [angPlot; angPlot(end,:)];
  pcolor(angPlot);
  title('Angles Between Vectors');
  ylabel('A');
  xlabel('B');
  colorbar;
end
