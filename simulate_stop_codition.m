function nevo = simulate_stop_codition(evo, num_epochs, max_fail, use_sp)
%function nevo = simulate_stop_codition(evo, num_epochs, max_fail, use_sp)
%Esta funcao pega um treinamento realizado, e retorna este mesmo
%treinamento, simulando um novo criterio de parada, que deve ser mais
%restritivo que o original. exemplo, se vc tem um treino que vc realizou com
%20.000 epocas, mas gostaria de saber como seria a evolucao caso o nmero de
%epocas fosse 100, ou com 20k epocas, mas vc gostaria de saber como seria
%se a parada fosse por MSE, ou SP, etc.

nevo = evo;

if iscell(evo),
  [M,N] = size(evo);
  for i=1:M,
    for j=1:N,
      nevo{1,j} = do_job(evo{1,j}, num_epochs, max_fail, use_sp);
    end
  end
else
  nevo = do_job(evo, num_epochs, max_fail, use_sp);
end
  
  
function nevo = do_job(evo, num_epochs, max_fail, use_sp)
  %Truncando pelas epocas.
  nevo = truncate(evo, num_epochs);
  
  %Truncando por max_fail.
  if use_sp,
    nevo.stop_sp = evo.num_fails_sp >= max_fail;
    nevo.stop_mse = evo.num_fails_mse >= floor(max_fail/2);
  else
    nevo.stop_sp = ones(1, num_epochs);
    nevo.stop_mse = evo.num_fails_mse >= max_fail;
  end
   
  %Truncando o numero de epocas pela parada por max_fail.
  I = find(nevo.stop_sp & nevo.stop_mse, 1, 'first');
  if ~isempty(I),
    nevo = truncate(nevo, I);    
  end

  

function nevo = truncate(evo, num)
  nevo = evo;
  fields = fieldnames(evo);
  for i=1:length(fields),
    f = fields{i};
    nevo.(f) = evo.(f)(:,1:num);
  end
  