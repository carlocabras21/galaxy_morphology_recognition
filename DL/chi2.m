% function chi = chi2(h,g)
% 
% Compute Chi2 statistics between two normalized vectors, h and g.
function chi = chi2(h,g)

  x = h./(norm(h)+eps);
  y = g./(norm(g)+eps);
  chi = 0.5*sum( ((x-y).^2)./(x+y+eps) );

return;