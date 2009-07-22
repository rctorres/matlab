function [nData, dbg] = sequential(data, ringsDist, stopEnergy, energyThreshold, fixNorm, layers2Normalize)
%function nData = sequential(data, ringsDist, stopEnergy, energyThreshold, fixNorm, layers2Normalize)
%Realiza a normalizacao sequencial.
%

if nargin == 2,
  stopEnergy = 100;
  energyThreshold = 0.001;
  fixNorm = 1000;
  layers2Normalize = ones(size(ringsDist));
elseif nargin == 3,
  energyThreshold = 0.001;
  fixNorm = 1000;
  layers2Normalize = ones(size(ringsDist));
elseif nargin == 4,
  fixNorm = 1000;
  layers2Normalize = ones(size(ringsDist));
elseif nargin == 5,
  layers2Normalize = ones(size(ringsDist));
end

fprintf('Realizando a normalizacao sequencial.\n');

if length(stopEnergy == 1),
  stopEnergy = repmat(stopEnergy,1,length(ringsDist));
end

if length(energyThreshold == 1),
  energyThreshold = repmat(energyThreshold,1,length(ringsDist));
end

if length(fixNorm == 1),
  fixNorm = repmat(fixNorm,1,length(ringsDist));
end


nData = zeros(size(data));
dbg = cell(1,length(ringsDist));

for i=1:length(ringsDist),  
  %Pegando os aneis da camada i.
  [iPos, ePos] = getLayerLimits(ringsDist, i);
  
  fprintf('Normalizando a camada %d.\n', i);
  [nData(iPos:ePos,:), dbg{i}] = doLayer(data(iPos:ePos,:), stopEnergy(i), energyThreshold(i), fixNorm(i), layers2Normalize(i));
end


function [nData, dbg] = doLayer(data, stopEnergy, energyThreshold, fixNorm, doSequential)
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
    norm(1) = abs(sum(rings));
    
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
