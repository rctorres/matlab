function plotRelevanceValues(relev, rIdx, name)
%function plotRelevanceValues(relev, rIdx, name)
%Recebe os valores de relevancia p/ cada entrada e os indices das entradas
%mais relevantes, fazendo um barplot com legenda colorida das mesmas. Usa
%um nome 'name' p/ identificar o tirulo.
%

barh((1:length(relev)), relev, 1, 'r');
hold on;
aux = zeros(size(relev));
aux(rIdx) = relev(rIdx);
barh((1:length(relev)), aux, 1, 'g');
hold off;
legend('Rejected', 'Accepted');
title(sprintf('Input Relevance (%s)', name));
xlabel('Deviation');
ylabel('Input Number');
