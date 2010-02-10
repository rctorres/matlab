function [p, x, y] = emdensity(u, kmax, nPoints)

  [w,m,r] = em(u, [], kmax, 0, 0, 0);

  x = linspace(min(u), max(u), nPoints)';
  lx = em_gauss(x,m,r);
  p = lx*w;
