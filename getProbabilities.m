function [pd, pfa, numE, numJ] = getProbabilities(net, cut, tst, fName, infLim, supLim)
%function [pd, pfa, numE, numJ] = getProbabilities(net, cut, tst, fName, infLim, supLim)
%calcula as probabilidades de deteccao e falso alarme em relacao a uma dada
%grandeza. Exemplo, esta funcao pode ser usada para calcular as
%probabilidades de deteccao e falso alarme para cada valor de energia, para
%cada valor de eta, etc. A grandeza a ser usada e passada por parametro, e
%e usada de tal forma que a faixa dinamica da grandeza e dividida em
%faixas, e , emc ada faixa, as probabildiades sao calculadas.
% Parametros de entrada:
% - net: a rede neural a ser utilizada.
% - cut: O corte (threshold) de separacao das classes.
% - tst: conjunto de dados de teste (load4Train(false,...))
% - fname: nome do campo a ser testado (lvl2_eta, Et, etc)
% - infLim: O valor do limite inferior de analise para cada bim. O tamanho
% deste vetor diz quantos bins serao utilizados.
% - supLim: O valor do limite inferior de analise para cada bim. O tamanho
% deste vetor diz quantos bins serao utilizados.
%
%A funcao retorna:
% - pd: A probabilidade de deteccao de eletrons para cada bim.
% - pj: A probabilidade de falso alarme para cada bim.
% -numE: O numero de eletrons encontrados em cada bim.
% -numJ: O numero de jatos encontrados em cada bim.
%
  
  nBims = length(infLim);
  pd = zeros(1,nBims);
  pfa = zeros(1,nBims);
  numE = zeros(1,nBims);
  numJ = zeros(1,nBims);
  
  analE = tst{1}.(fName);
  analJ = tst{2}.(fName);
  
  for i=1:nBims,
    %Selecting the data falling on the desired region.
    Ie = find( (analE >= infLim(i)) & (analE < supLim(i)) );
    Ij = find( (analJ >= infLim(i)) & (analJ < supLim(i)) );
    numE(i) = length(Ie);
    numJ(i) = length(Ij);
    
    %Calculating Pd.
    out = nsim(net, tst{1}.rings(:,Ie));
    pd(i) = length(find(out >= cut)) / numE(i);
    
    %Calculating Pfa
    out = nsim(net, tst{2}.rings(:,Ij));
    pfa(i) = length(find(out >= cut)) / numJ(i);
  end
