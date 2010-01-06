function [stdInf, stdSup] = adjustErrorRanges(mean_val, std_val)
%function [stdInf, stdSup] = adjustErrorRanges(mean_val, std_val)
%Esta funcao ajusta, baseado na media e nod esvio padrao, os limites
%inferiores e superiores da barra de erro, para que as mesmas nao
%ultrapassem o limite [0,1]. Esta funcao considera que a maxima
%probabilidade (evento certo) tem valor 1 (um). A funcao retorna os
%limites inferior e superior de cada barra de erro.
%
  stdInf = std_val;
  stdSup = std_val;
  sup_vals = mean_val + std_val;
  inf_vals = mean_val - std_val;
  stdInf(inf_vals < 0) = mean_val(inf_vals < 0);
  stdSup(sup_vals > 1) = 1 - mean_val(sup_vals > 1);
  
