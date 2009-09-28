function plot_corr_analysis(data, ringsDist, w, w_seg)

%Correlacao linear.
do_plot(data, ringsDist, w, w_seg, 'linear');

%Correlacao nao-linear.
do_plot(tanh(data), ringsDist, w, w_seg, 'nao-linear');


function do_plot(data, ringsDist, w, w_seg, tit)
  N = length(ringsDist);
  leg = {'PS', 'EM1', 'EM2', 'EM2', 'HD1', 'HD2', 'HD3'};
  figure;

  for i=1:N,
    subplot(2,4,i);
    ldata = getLayer(data, ringsDist, i);  
    if ~isempty(w_seg),
      ldata = w_seg{i}.w * ldata;
    end
    do_job(ldata, sprintf('%s (%s)', leg{i}, tit));
  end

  if ~isempty(w),
    data = w.w * data;
  end
  do_job(data, sprintf('All (%s)', tit));


function do_job(data, tit)
  c = corrcoef(data');
  c = [c c(:,end)];
  c = [c; c(end,:)];
  pcolor(c);
  colorbar;
  title(tit);
