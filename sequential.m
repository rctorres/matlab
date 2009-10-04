function [trn, val, tst, pp] = sequential(trn, val, tst, par)
%function [trn, val, tst, pp] = sequential(trn, val, tst, par)
%Realiza a normalizacao sequencial.
% - par.ringsDist : distribuicao dos aneis em cada camada.
%
  pp.name = 'sequential';
  disp('Fazendo Normalizacao Sequencial');
  
  for i=1:length(trn),
    trn{i} = do_set(trn{i}, par.ringsDist);
    val{i} = do_set(val{i}, par.ringsDist);
    tst{i} = do_set(tst{i}, par.ringsDist);
  end


function [data] = do_set(data, ringsDist)

  nLayers = length(ringsDist);

  for i=1:nLayers,
    %Pegando os aneis da camada i.
    [ip, ep] = getLayerLimits(ringsDist, i);  
    data(ip:ep,:) = doLayer(data(ip:ep,:));
  end


function [nData] = doLayer(data)
  stopEnergy = 100;
  energyThreshold = 0.001;

  nData = zeros(size(data));
  [nRings, nEvents] = size(data);
  
  for i=1:nEvents,
    rings = data(:,i);
    
    norm = zeros(nRings, 1); 
    norm(1) = abs(sum(rings));
    
    if norm(1) < stopEnergy,
      norm(1) = max( norm(1), max(abs(rings)) );
    
      if norm(1) < energyThreshold,
        continue;
      end
      
      nData(:,i) = rings ./ norm(1);
      continue;
    end
    
    fixed = false;
    for j=2:nRings,
      norm(j) = abs(norm(j-1) - rings(j-1));
      if (fixed) || (norm(j) < stopEnergy),
        norm(j) = norm(1);
        fixed = true;
      end
    end
    
    nData(:,i) = rings ./ norm;
  end
