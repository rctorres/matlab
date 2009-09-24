function res = plotPCAcurve(val, marker)
%function plotPCAcurve(val, marker)
%Plots the accumulated energy over the number of considered PCAs using the
%marker 'marker' ('b*--' by default).
%

if nargin < 2, marker = 'b*--'; end

N = length(val);
res = zeros(1,N);
Etot = sum(val);
res(1) = 100*val(1)/Etot;
for i=2:N,
	res(i) = res(i-1) + ( 100*val(i)/Etot );
end

plot(res, marker);
title('Amount of Energy Retained');
xlabel('# PCA Used');
ylabel('Retained Energy (%)');
grid on;
