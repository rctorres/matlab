function nData = sequential(data, ringsDist, stopEnergy, energyThreshold, layers2Normalize)
%function nData = sequential(data, ringsDist, stopEnergy, energyThreshold, layers2Normalize)
%Realiza a normalizacao sequencial.
%

if nargin == 2,
  stopEnergy = 100;
  energyThreshold = 0.001;
  layers2Normalize = ones(size(ringsDist));
elseif nargin == 3,
  energyThreshold = 0.001;
  layers2Normalize = ones(size(ringsDist));
elseif nargin == 4,
  layers2Normalize = ones(size(ringsDist));
end

fprintf('Realizando a normalizacao sequencial.\n');
fprintf('Energy Threshold = %f\n', energyThreshold);

if length(stopEnergy == 1),
  stopEnergy = repmat(stopEnergy,1,length(ringsDist));
end

nData = zeros(size(data));

for i=1:length(ringsDist),  
  %Pegando os aneis da camada i.
  [iPos, ePos] = getLayerLimits(ringsDist, i);
  
  fprintf('Normalizando a camada %d. Vou fazer a parte sequencial? %d\n', i, layers2Normalize(i));
  nData(iPos:ePos,:) = doLayer(data(iPos:ePos,:), stopEnergy(i), energyThreshold, layers2Normalize(i));
end


function nData = doLayer(data, stopEnergy, energyThreshold, doSequential)
  fprintf('For layer with %d rings, stop_energy = %f\n', size(data,1), stopEnergy);
  nData = data;
  [nRings, nEvents] = size(data);
  
  for i=1:nEvents,
    rings = data(:,i);
    norm = zeros(nRings,1);
    norm(1) = abs(sum(rings));
    
    if norm(1) < stopEnergy,
      max_r = max(rings);
      min_r = min(rings);
      if norm(1) < max_r,
        new_norm = abs(max_r);
        if abs(min_r) > new_norm,
          new_norm = abs(min_r);
        end
        norm(1) = new_norm;
      end
      
      if norm(1) < energyThreshold,
        continue;
      end
      
      nData(:,i) = rings ./ norm(1);
      continue;
    end
    
    if doSequential,
      fixed = false;
      for j=2:nRings,
        norm(j) = abs(norm(j-1) - abs(rings(j-1)));
        if (fixed) || (norm(j) < stopEnergy),
          norm(j) = norm(1);
          fixed = true;
        end
      end
      nData(:,i) = rings ./ norm;
    else
      nData(:,i) = rings ./ norm(1);
    end
  end
