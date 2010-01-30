function wret = gs_ort(w)
%function wret = gs_ort(w)
%Performs Gram-Schimdt ortonormalization of a matrix w.
%The vectors in w must be in each ROW. therefore.
%
  
[M,N] = size(w);
wret = zeros(M,N);

wret(1,:) = w(1,:);
for i=2:M,
  sw = w(i,:);
  cw = sw;
  for j=1:(i-1),
    pw = wret(j,:);
    cw = cw - ( (pw*sw') / (pw*pw') )*pw;
  end
  wret(i,:) = cw;
end
  
%Unity norm.
wret = wret ./ repmat(sqrt(sum(wret.^2, 2)), 1, N);
