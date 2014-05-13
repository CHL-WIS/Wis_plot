function [shr] = sshr(ps)
  if ps <= 0.;
     ri = ps;
     rinew = ps.*(1.-18.*ri).^(0.25);
     while abs(rinew-ri) >= 0.001;
       ri = rinew;
       rinew = ps.*(1.-18.*ri).^(0.25);
     end
     shr(:,1) = 1. / (1. -18.*rinew(:,1)).^(0.25);
  else
      shr(:,1) = 1. + 7.*ps(:,1);
  end