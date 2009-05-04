function plotProjectionAnalysis(data, ringsDist, secNames, w_all, w_seg, name)

nLayers = length(ringsDist);

doProj = true;
if nargin == 3,
  doProj = false;
  name = 'dummy';
  w_seg = cell(1,nLayers);
  for i=1:nLayers, w_seg{i}.(name) = [];end
  w_all.(name) = [];
end

inHist = figure;
figCorr = figure;
figNlCorr = figure;
figOrt = figure;

for i=1:nLayers,
  ldata = project(getLayer(data, ringsDist, i), w_seg{i}.(name), doProj);
  figure(inHist);
  subplot(2,4,i);
  doPlot(ldata, secNames{i});
  doProjectionAnalysis(secNames{i}, ldata, i, figCorr, figNlCorr, figOrt, w_seg{i}.(name))
end

figure(inHist);
subplot(2,4,8);
ldata = project(data, w_all.(name), doProj);
doPlot(ldata, 'All Layers');
doProjectionAnalysis('All Layers', ldata, 8, figCorr, figNlCorr, figOrt, w_all.(name))


function doProjectionAnalysis(name, data, figIdx, figCorr, figNlCorr, figOrt, W)

  if nargin == 7,
    %Doing ortogonalization
    figure(figOrt);
    subplot(2,4,figIdx);
    pcolor(calcAngles(W'));
    colorbar;
    title(sprintf('Ortogonalization Analysis - %s', name));
    xlabel('Projection');
    ylabel('Projection');
  end
  
  data = double(data');
  
  %Doing linear correlation analysis.
  figure(figCorr);
  subplot(2,4,figIdx);
  pcolor(abs(corrcoef(data)));
  colorbar;
  title(sprintf('Linear Correlation Analysis - %s', name));
  xlabel('Projection');
  ylabel('Projection');

  %Doing non-linear correlation analysis.
  ndata = size(data,1);
  data(1:round(ndata/2),:) = tanh(data(1:round(ndata/2),:));
  data(round(ndata/2)+1:end,:) = data(round(ndata/2)+1:end,:).^3;

  figure(figNlCorr);
  subplot(2,4,figIdx);
  pcolor(abs(corrcoef(data)));
  colorbar;
  title(sprintf('Non-linear Correlation Analysis - %s', name));
  xlabel('Projection');
  ylabel('Projection');



function doPlot(data, name)
  [n,m] = size(data);
  data  = reshape(data,1,n*m);
  histLog(data, 1000);
  title(name);
  xlabel('Input Dist')
  ylabel('Counts');
  fprintf('For %s, mean = %f, std = %f\n', name, mean(data), std(data));


  
function pdata = project(data, w, doProj)
  if doProj,
    pdata = w * data;
  else
    pdata = data;
  end
