function plotPCAcurve(val)
%function plotPCAcurve(val)
%Plots the accumulated energy over the number of considered PCAs.
%

N = length(val);
res = zeros(1,N);

Etot = sum(val);

res(1) = 100*val(1)/Etot;
for i=2:N,
	res(i) = res(i-1) + ( 100*val(i)/Etot );
end

plot([1:N], res, '*-');
