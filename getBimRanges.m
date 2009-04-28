function [inThres, supThres, centers] = getBimRanges(minVal, maxVal, nBims)
%function [inThres, supThres, centers] = getBimRanges(minVal, maxVal, nBims)
%Retorna os limites e o centros quando dividimos uma faixa dinamica por umd
%eterminado numero de bims.
%Parametros de entrada:
% - minVal: o valor minimo da faixa considerada.
% - maxVal: o valor maximo da faixa considerada.
% - nBims: em quantas partes dividiremos a faixa considerada.
%
%A funcao retorna:
% - inThres: os limiares inferiores de cada bim.
% - supThres: os limiares superiores de cada bim.
% - centers: os valores do centro de cada bim.
%

  step = (maxVal - minVal) / nBims;
  div = [minVal:step:maxVal];
  inThres = div(1:end-1);
  supThres = div(2:end);
  centers = (supThres + inThres) ./ 2;
