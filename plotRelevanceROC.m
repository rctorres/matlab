function [sp, det, fa, maxSpIdx] = plotRelevanceROC(net, relev, data)

%Calculando a matriz com a media das entradas.
mRing = mean([data{1} data{2}],2);
mData = {repmat(mRing,1,size(data{1},2)) repmat(mRing,1,size(data{2},2))};

%Pegando os indices de cada bloco de entrada relevante.
dist = getRelevanceDistribution(relev);
nDist = length(dist);

nPt = 1000;
sp = zeros(nDist, nPt);
det = zeros(nDist, nPt);
fa = zeros(nDist, nPt);
maxSpIdx = zeros(1,nDist);

%Fazendo para as entradas mais relevantes.
mostRelevData = fillValues(data, mData, dist{1});
[maxSpIdx(1), sp(1,:), det(1,:), fa(1,:)] = getPlot(net, mostRelevData, nPt);
clear mostRelevData;

%Fazendo para as relevancias acumuladas.
for i=2:nDist,
  mData = fillValues(data, mData, dist{i});
  [maxSpIdx(i), sp(i,:), det(i,:), fa(i,:)] = getPlot(net, mData, nPt);
end

if nargout == 0,
  color = ['b' 'g' 'r' 'c' 'm', 'k'];
  leg = {'Most relevant', '20%', '40%', '60%', '80%', '100%'};
  for i=1:nDist,
    plot(100*fa(i,:), 100*det(i,:), color(i));
    hold on;
  end
  legend(leg);
  
  %Placing the maximum SP spots.
  for i=1:nDist,
    plot(100*fa(i,maxSpIdx(i)), 100*det(i,maxSpIdx(i)), sprintf('%c*',color(i)));
  end
  grid on;
  title('ROC for Incremental Usage of Rings Ordered by Their Relevance');
  xlabel('False Alarm (%)');
  ylabel('Detection Efficiency (%)')
end  

function dist = getRelevanceDistribution(relev)
%Ploto um total de 6 ROCs. A primeira e sempre com as entradas + relevantes (>10% da max)
%As outras 5 sao variando de 20 em 20 (20%, 40%, 60%,..) o numero de entradas relevantes.
  nROC = 6; 
  nRelev = length(relev);

  %Ordenando as relevancias.
  [x,idx] = sort(relev, 'descend');
  dist = cell(1,nROC);
  
  %A primeira ROC e sempre das entradas que tenham pelo menos 10% da relevancia da mais relevante.
  dist{1} = find(relev > 0.1*max(relev));

  %As outras analises serao obtidas variando em 20 pontos percentuais o numero de entradas
  %relevantes, ate atingir 100% de entradas relevantes.
  
  %Usando o hist p/ calcular qua e o incremento mais uniforme no numero re entradas relevantes.
  [initPos, endPos, c] = getBimRanges(1,nRelev,(nROC-1));
  initPos = ceil(initPos);
  endPos = floor(endPos);
  
  for i=1:(nROC-1),
 %   fprintf('Curva %d: init = %d, end = %d\n', i, initPos(i), endPos(i));
    dist{i+1} = idx(initPos(i):endPos(i));
  end


function ret = fillValues(data, mData, idx)
  ret = mData;
  for i=1:length(mData),
    for j=1:length(idx),
      k = idx(j);
      ret{i}(k,:) = data{i}(k,:);
    end
  end


function [bestSpot, spVec, det, fa] = getPlot(net, data, nPt)
  %Propagando pela rede.
  out = nsim(net, data);
  [spVec, cutVec, det, fa] = genROC(out{1}, out{2}, nPt);
  [sp, bestSpot] = max(spVec);
