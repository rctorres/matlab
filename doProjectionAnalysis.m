function doProjectionAnalysis(W, data)
%function doProjectionAnalysis(W, data)
%Performs ortogonality, and linear and non-linear decorrelation analysis.
%W must be the projection matrix, with one projection per row, and data is
%a data vector to be projected onto W, where each event is a collumn, so
%that W * data is feasible.
%

data = (W * data)';

%Doing ortogonalization
figure;
pcolor(calcAngles(W'));
colorbar;
title('Ortogonalization Analysis');
xlabel('Projection');
ylabel('Projection');

%Doing linear correlation analysis.
figure;
pcolor(abs(corrcoef(data)));
colorbar;
title('Linear Correlation Analysis');
xlabel('Projection');
ylabel('Projection');

ndata = size(data,1);
data(1:round(ndata/2),:) = tanh(data(1:round(ndata/2),:));
data(round(ndata/2)+1:end,:) = data(round(ndata/2)+1:end,:).^3;

%Doing non-linear correlation analysis.
figure;
pcolor(abs(corrcoef(data)));
colorbar;
title('Non-linear Correlation Analysis');
xlabel('Projection');
ylabel('Projection');
