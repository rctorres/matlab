function c = nlcorr(x)

x = removeMean(x);
[M,N] = size(x);


c = zeros(M,M);

for i=1:M,
  for j=1:M,
    a = (x(i,:) ./ norm(x(i,:))).^5;
    b = (x(j,:) ./ norm(x(j,:))).^3;
    c(i,j) = mean(a.*b);
  end
end

function ox = removeMean(x)
  mx = mean(x,2);
  mx = repmat(mx,1,size(x,2));
  ox = x - mx;
