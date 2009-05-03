function doProjectionAnalysis(W, data)
%function doProjectionAnalysis(W, data)
%Performs ortogonality, and linear and non-linear decorrelation analysis.
%W must be the projection matrix, with one projection per row, and data is
%a data vector to be projected onto W, where each event is a collumn, so
%that W * data is feasible.
%

W = W';
data = data';

%Doing ortogonalization
figure;
pcolor(calcAngles(W));
colorbar;
title('Ortogonalization Analysis');
xlabel('Projection');
ylabel('Projection');

data = data * W;

%Doing linear correlation analysis.
figure;
pcolor(corrcoef(data));
colorbar;
title('Linear Correlation Analysis');
xlabel('Projection');
ylabel('Projection');

%Doing non-linear correlation analysis.
figure;
pcolor(corrcoef(data.^3, tanh(data)));
colorbar;
title('Non-linear Correlation Analysis');
xlabel('Projection');
ylabel('Projection');
