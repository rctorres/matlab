function nData = event(data, ringsDist, energyThreshold, fixNorm, layers2Normalize, etot2Use)
%function nData = sequential(data, ringsDist, energyThreshold, fixNorm, layers2Normalize, etot2Use)
%Realiza a normalizacao por evento, tal como o Rabello no Ringer.
%

if nargin < 3, energyThreshold = 0.001; end
if nargin < 4, fixNorm = 1; end
if nargin < 5, layers2Normalize = 1; end
if nargin < 6, etot2Use = 'event'; end

fprintf('Realizando a normalizacao por evento.\n');
nLayers = length(ringsDist);

if length(energyThreshold == 1),
  energyThreshold = repmat(energyThreshold,1,nLayers);
end

if length(fixNorm == 1),
  fixNorm = repmat(fixNorm,1,nLayers);
end

if length(layers2Normalize == 1),
  layers2Normalize = repmat(layers2Normalize,1,nLayers);
end


nData = zeros(size(data));

%Calculando o valor de norma unitaria que usaremos.
etot = getTotalEnergy2USe(data, ringsDist, etot2Use);

for i=1:nLayers,
  %Pegando os aneis da camada i.
  [iPos, ePos] = getLayerLimits(ringsDist, i);
  
  fprintf('Normalizando a camada %d.\n', i);
  nData(iPos:ePos,:)  = doLayer(data(iPos:ePos,:), etot(i,:), energyThreshold(i), fixNorm(i), layers2Normalize(i));
end



function etot = getTotalEnergy2USe(data, ringsDist, etot2Use)
  nLayers = length(ringsDist);
  
  if strcmp(etot2Use, 'event'),
    disp('Usando norma unitaria do evento...');
    etot = repmat(abs(sum(data)), nLayers, 1);
  elseif strcmp(etot2Use, 'section'),
    disp('Usando norma unitaria do secao...');
    etot = zeros(nLayers, size(data,2));
    nEMLayers = 4;
    nEM = sum(ringsDist(1:nEMLayers));  
    etot(1:nEMLayers,:) = repmat( abs(sum(data(1:nEM,:))), nEMLayers, 1);
    etot((nEMLayers+1):end,:) = repmat( abs(sum(data((nEM+1):end,:))), (nLayers-nEMLayers), 1);
  elseif strcmp(etot2Use, 'layer'),
    disp('Usando norma unitaria da camada...');
    etot = zeros(nLayers, size(data,2));
    for i=1:nLayers,
      etot(i,:) = abs(sum(getLayer(data, ringsDist, i)));
    end
  else
    error('Invalid type of Total Energy to use. Possible values are "event", "section" or "layer".\n');
  end




function nData = doLayer(data, etot, stopEnergy, energyThreshold, fixNorm, doNorm)
  fprintf('For layer with %d rings, energy_threshold = %f, fixed_norm = %f, do_norm = %d\n', size(data,1), energyThreshold, fixNorm, doNorm);
  nData = zeros(size(data));
  [nRings, nEvents] = size(data);
  
  for i=1:nEvents,
    rings = data(:,i);
    
    if ~doNorm,
      nData(:,i) = rings ./ fixNorm;
      continue;
    end
    
    norm = etot(i);
    
    if norm < energyThreshold,
      nData(:,i) = rings ./ fixNorm;
      continue;
    end

    nData(:,i) = rings ./ norm;
  end
