function [out, et, eta, phi] = plotAnalysis(net, tst, bE, bEta, bPhi)
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
  clear a1 a2;
  
  %Calculating net Output
  out.e = nsim(net.net, tst{1}.rings);
  out.j = nsim(net.net, tst{2}.rings);
  
  %Getting the best cut.
  [spVec, cutVec] = genROC(out.e, out.j);
  [sp, I] = max(spVec);
  out.cut = cutVec(I);
  
  %Doing energy analysis.
  [in, sup, et.x] = getBimRanges(15000, 80000, bE);
  [et.det, et.fa, et.num_e, et.num_j] = getProbabilities(net.net, out.cut, tst, 'et', in, sup);
  
  %Doing eta.
  [in, sup, eta.x] = getBimRanges(-2.5, 2.5, bEta);
  [eta.det, eta.fa, eta.num_e, eta.num_j] = getProbabilities(net.net, out.cut, tst, 'lvl2_eta', in, sup);

  %Doing phi.
  [in, sup, phi.x] = getBimRanges(-pi, pi, bPhi);
  [phi.det, phi.fa, phi.num_e, phi.num_j] = getProbabilities(net.net, out.cut, tst, 'lvl2_phi', in, sup);
  