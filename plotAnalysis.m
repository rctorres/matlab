function plotAnalysis(net, tst, bE, bEta, bPhi)
%function plotAnalysis(net, evo, tst, bE, bEta, bPhi)
%Gera as figuras de Plots para analise. Os parametros de entrada sao:
% - net: a rede neural a ser utilizada, tal como retornada pelo fullTrain.
% - tst : celulas com o conjunto de eletrons e jatos, contendo infos como
%         ET, eta, etc (load4Train(false,...).
% - be (opt): O numero de bims para usar no histograma de energia.
% - bEta (opt): O numero de bims para usar no histograma de eta.
% - bPhi (opt): O numero de bims para usar no histograma de phi.
%
%Os seguintes graficos serao gerados:
% - Variacao da deteccao e do falso alarme pela energia.
% - Variacao da deteccao e do falso alarme por eta.
% - Variacao da deteccao e do falso alarme por phi.
%

  if nargin < 3, bE = 50; end
  if nargin < 4, bEta = 50; end
  if nargin < 5, bPhi = 50; end
    
  [a1, a2, tst] = do_pre_proc(net.pp, tst, tst, tst);
  clear a1, a2;
  
  %Calculating net Output
  ret.out_e = nsim(net, tst{1}.rings);
  ret.out_j = nsim(net, tst{2}.rings);
  
  %Getting the best cut.
  [spVec, cutVec] = genROC(ret.out_e, ret.out_j);
  [sp, I] = max(spVec);
  ret.cut = cutVec(I);
  
  %Doing energy analysis.
  [in, sup, ret.et.x] = getBimRanges(7000, 80000, bE);
  [ret.et.det, ret.et.fa, ret.et.num_e, ret.et.num_j] = getProbabilities(net, ret.cut, tst, 'et', in, sup);
  
  %Doing eta.
  [in, sup, ret.eta.x] = getBimRanges(-2.5, 2.5, bEta);
  [ret.eta.det, ret.eta.fa, ret.eta.num_e, ret.eta.num_j] = getProbabilities(net, ret.cut, tst, 'lvl2_eta', in, sup);

  %Doing phi.
  [in, sup, ret.phi.x] = getBimRanges(-pi, pi, bPhi);
  [ret.phi.det, ret.phi.fa, ret.phi.num_e, ret.phi.num_j] = getProbabilities(net, ret.cut, tst, 'lvl2_phi', in, sup);
  