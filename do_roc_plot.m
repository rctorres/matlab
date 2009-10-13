function [h_roc, h_sp] = do_roc_plot(net, fisher, c, idx, pdRef)
%function [h_roc, h_sp] = do_roc_plot(net, fisher, c, idx, pdRef)
%Plota a ROC e a tabela de eficiencias recebendo os valores net e fisher
%salvos por train_case. c e uma cor a representar o conjunto a ser plotado.
%idx e o indice para ser usado no eixo x do errorbar, e pdRef e uma prob.
%de detecao de referencia [0-1] par aque se ja apresentada o falso alarme
%correspondente.

  disp(net.desc);
  
  if isempty(fisher),
    cases = {net};
  else
    cases = {net, fisher};
  end
  
  nCases = length(cases);  
  traces = {'-', '--'};
  marker = {'s', 'o'};
  h_roc = zeros(1,nCases);
  h_sp = zeros(1,nCases);
  
  for i=1:nCases,
    d = cases{i};
    t = traces{i};
    m = marker{i};

    %ROC
    subplot(2,2,1);
    hold on;
    h = plot(100*d.fa', 100*d.det', [c t]);
    grid on;
    title('ROCs Aneis Puros');
    xlabel('Falso Alarme (%)');
    ylabel('Detecao (%)');
    h_roc(i) = h(1);
  
    %SP
    subplot(2,2,2);
    hold on;
    mean_sp = mean(d.sp);
    std_sp = std(d.sp);
    [si, ss] = adjustErrorRanges(mean_sp, std_sp);
    h = errorbar(idx-1+i, 100*mean_sp, 100*si, 100*ss, [c m]);
    grid on;
    title('Maximo SP de Cada Caso');
    xlabel('Caso');
    ylabel('SP (%)');
    h_sp(i) = h(1);

    %Area da ROC
    subplot(2,2,3);
    hold on;
    area = roc_area(d.det);
    mean_area = mean(area);
    std_area = std(area);
    [si, ss] = adjustErrorRanges(mean_area, std_area);
    errorbar(idx-1+i, 100*mean_area, 100*si, 100*ss, [c m]);
    grid on;
    title('Area da ROC');
    xlabel('Caso');
    ylabel('Area');

    %PF@PD
    subplot(2,2,4);
    hold on;
    [v, I] = min(abs(d.det - pdRef), [], 2);
    pfa = d.det(I);
    mean_pfa = mean(pfa);
    std_pfa = std(pfa);
    [si, ss] = adjustErrorRanges(mean_pfa, std_pfa);
    errorbar(idx-1+i, 100*mean_pfa, 100*si, 100*ss, [c m]);
    grid on;
    title(sprintf('P_D @ P_{FA} = %2.2f%%', 100*pdRef));
    xlabel('Caso');
    ylabel('Detecao (%)');

    netName = getNumNodesAsText(d.net);
    fprintf('%8s : SP = %2.2f +- %2.2e, Area = %2.2f +- %2.2e, Pd@Pf = %2.0f =  %2.2f +- %2.2e\n', netName, 100*mean_sp, 100*std_sp, 100*mean_area, 100*std_area, 100*pdRef, 100*mean_pfa, 100*std_pfa);
  end
  
  
function s = roc_area(pd)
  res = 1 / size(pd,2);
  s = sum(res*pd, 2);
  