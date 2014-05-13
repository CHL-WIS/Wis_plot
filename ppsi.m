function [psi] =  ppsi(p)
   if  p <= 0.;
       [shr] = sshr(p);
       ss4=1.-shr-3.*log(shr)+2*log((1.+shr)/2.);
       psi=ss4 + 2.*atan(shr)-1.5708+log((1. + shr.*shr)/2.);
   else
    psi =-7. * p(:,1);
   end