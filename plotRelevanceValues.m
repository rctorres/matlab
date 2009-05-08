function plotRelevanceValues(relev, rIdx, name)
%function plotRelevanceValues(relev, rIdx, name)
%Recebe os valores de relevancia p/ cada entrada e os indices das entradas
%mais relevantes, fazendo um barplot com legenda colorida das mesmas. Usa
%um nome 'name' p/ identificar o tirulo.
%

barh([1:length(relev)], relev, 1, 'r');
hold on;
barh(rIdx, relev(rIdx), 1, 'g');
hold off;
legend('Rejected', 'Accepted');
title(sprintf('Relevance Value for the Classifier Input Variables (%s)', name));
xlabel('MSE Deviation');
ylabel('Input Number');
