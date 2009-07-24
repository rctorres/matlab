function [nData, dbg] = sequential(data, ringsDist, stopEnergy, energyThreshold, fixNorm, layers2Normalize, etot2Use)
%function nData = sequential(data, ringsDist, stopEnergy, energyThreshold, fixNorm, layers2Normalize, etot2Use)
%Realiza a normalizacao sequencial.
%

if nargin < 3, stopEnergy = 100; end
if nargin < 4, energyThreshold = 0.001; end
if nargin < 5, fixNorm = 1000; end
if nargin < 6, layers2Normalize = 1; end
if nargin < 7, etot2Use = 'layer'; end

fprintf('Realizando a normalizacao sequencial.\n');
nLayers = length(ringsDist);

if length(stopEnergy == 1),
  stopEnergy = repmat(stopEnergy,1,nLayers);
end

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
dbg = cell(1,nLayers);

%Calculando o valor de norma unitaria que usaremos.
etot = getTotalEnergy2USe(data, ringsDist, etot2Use);

for i=1:nLayers,
  %Pegando os aneis da camada i.
  [iPos, ePos] = getLayerLimits(ringsDist, i);
  
  fprintf('Normalizando a camada %d.\n', i);
  [nData(iPos:ePos,:), dbg{i}] = doLayer(data(iPos:ePos,:), etot(i,:), stopEnergy(i), energyThreshold(i), fixNorm(i), layers2Normalize(i));
end



function etot = getTotalEnergy2USe(data, ringsDist, etot2Use)
  nLayers = length(ringsDist);
  
  if strcmp(etot2Use, 'event'),
    disp('Usando norma unitaria do evento...');
    etot = repmat(abs(sum(data)), nLayers, 1);
  elseif strcmp(etot2Use, 'section'),
    disp('Usando norma unitaria do secao...');
    etot = zeros(size(data));
    nEMLayers = 4;
    nEM = sum(ringsDist(1:nEMLayers));  
    etot(1:nEM,:) = repmat( abs(sum(data(1:nEM,:))), nEMLayers, 1);
    etot((nEM+1):end,:) = repmat( abs(sum(data((nEM+1):end,:))), (nLayers-nEMLayers), 1);
  elseif strcmp(etot2Use, 'layer'),
    disp('Usando norma unitaria da camada...');
    etot = zeros(size(data));
    for i=1:nLayers,
      etot(i,:) = abs(sum(getLayer(data, ringsDist, i)));
    end
  else
    error('Invalid type of Total Energy to use. Possible values are "event", "section" or "layer".\n');
  end




function [nData, dbg] = doLayer(data, etot, stopEnergy, energyThreshold, fixNorm, doSequential)
  fprintf('For layer with %d rings, stop_energy = %f, energy_threshold = %f, fixed_norm = %f, do_sequential = %d\n', size(data,1), stopEnergy, energyThreshold, fixNorm, doSequential);
  nData = zeros(size(data));
  [nRings, nEvents] = size(data);
  
  dbg.fix = 0;
  dbg.norm = 0;
  dbg.seq = 0;
  
  for i=1:nEvents,
    rings = data(:,i);
    
    if ~doSequential,
      nData(:,i) = rings ./ fixNorm;
      continue;
    end
    
    norm = zeros(nRings,1);
    norm(1) = etot(i);
    
    if norm(1) < stopEnergy,
      norm(1) = max( norm(1), max(abs(rings)) );
    
      if norm(1) < energyThreshold,
        dbg.fix = dbg.fix + 1;
        nData(:,i) = rings ./ fixNorm;
        continue;
      end
      
      dbg.norm = dbg.norm + 1;
      nData(:,i) = rings ./ norm(1);
      continue;
    end
    
    fixed = false;
    for j=2:nRings,
      norm(j) = abs(norm(j-1) - abs(rings(j-1)));
      if (fixed) || (norm(j) < stopEnergy),
        norm(j) = norm(1);
        fixed = true;
      else
        dbg.seq = dbg.seq + 1;
      end
    end
    
    nData(:,i) = rings ./ norm;
  end
