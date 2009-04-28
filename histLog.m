function histLog(data, nBims)
%function histLog(data, nBims)
%Produces the histogram of data, using nBims (just like hist), but the y
%axis is presented in log scale.

[y,x] = hist(data, nBims);
bar(x,y,1);
set(gca, 'YScale', 'log')
