function data = sumcorr(c)
%function data = sumcorr(c)
%Plota um resumo das analises de correlacao feitas com a funcao fullcorr.
%Este resumo e feito pegando o valor que MAIS representa semelhanca entre
%duas variaveis,s egundo uma dada fig de merito (menor angulo, maior
%correlacao, etc).
%As figuras de merito que nao ficam limitadas entre 0 e 1, sao normlizadas
%para que o resultado fique nesta faixa. Adicionalmente, o angulo e a
%distancia sao rebatidos (1-x), para que tenhamos sempre o mesmo padrao
%(quanto mais prox de 1, maior a semelhanca entre as variaveis,s egundo uma
%dada fig de merito).
%

  ang = min(c.ang) ./ 90; %Max = 1.
  corr = max(c.corr);
  im = max(c.im);
  im = im ./ max(im); %Max = 1.
  dist = min(c.dist);

  data = [ang; corr; im; dist];
  
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
