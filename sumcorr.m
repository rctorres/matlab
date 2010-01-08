function ret = sumcorr(c)

  ang = min(c.ang);
  corr = max(c.corr);
  im = max(c.im);
  dist = min(c.dist);

  ret = [ang; corr; im; dist];

  %P/ visualizar na tela, coloco todo mundo na faixa [0,1].
  data = (mapminmax(ret) + 1) ./ 2;
  
  %Angulo e distancia sao rebatidos. Quanto mais prox de 1, mais 
  %correlacionados.
  data(1,:) = 1 - data(1,:);
  data(4,:) = 1 - data(4,:);
  
  data = [data, data(:,end)];
  data = [data; data(end,:)];
  
  figure;
  pcolor(data);
  title('Valor da Figura de Merito para Cada Componente');
  xlabel('Componente');
  ylabel('Fig. Merito (1-Ang., 2-Corr., 3-Inf. Mut., 4-Dist. J-S)');
  colorbar;
