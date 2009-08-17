function str = getNumNodesAsText(net)
  %Retorna o numero de neuronios em cada camada, como um texto, p/ a insercao em legendas e titulos.

  %Camada de entrada.
  str = sprintf('%d', net.inputs{1}.size);
  
  %Camadas escondidas e de saida.
  for i=1:net.numLayers,
    str = strcat(str, sprintf('x%d', net.layers{i}.size));
  end
