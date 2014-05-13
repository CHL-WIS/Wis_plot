function [u10] = pbl(uz,zu,td,zt)
%
%Author: Original fortran routine D.T. Resio Dec. 2001
%        Modified by R.E. Jensen 2003
%	    This Subroutine and accompanying Functions
%	    generates the U10 estimate using Planetary
%	    Bounday Layer Physics.  The procedures are
%	    very similar to that introduced by Cardone.
% 
%
%  Input Parameters  ALL IN CGS System!!!!
%
%	UZ = Speed at starting position
%	ZU = Elevation at starting position 
%	TD = Air Sea Temperature Difference (Tair-Tsea)
%	ZT = Elevation of Temperature Measurement (set to 
%             anemometer elevation).
%
%  AUX. Functions
%       1.  PSI
%       2.  SHR is used in PSI
%
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
      vk=0.4;
      cf=1.79;
      c1=.1525;
      c2=0.0155/980.;
      c3=-0.00371;
      
      
%   first guess values

      cdrag=(1.1+0.035*uz*0.01)*0.001;
      ust=sqrt(cdrag).*uz;
      z0=c1./ust+c2*ust.*ust+c3;
 
      if abs(td) >= 0.1;
          
%  Include stability effects into solution
%  And Initial guess for stability length
%
      x1=log(1000./z0);
      sl=cf.*ust.*ust.*x1./td;
      p=zt./sl;
      [psi] = ppsi(p);
      ustn=vk*uz./(log(zu./z0)-psi);
%
%  Start Looking for the results..
%
      while abs(ustn - ust) > 0.1
        ust=0.5*(ustn+ust);
        z0=c1./ust+c2*ust.*ust+c3;
        sl=cf.*ust.*ust.*x1./td;
        p=zt./sl;
        [psi] = ppsi(p);
        ustn=vk*uz ./(log(zu./z0)-psi);
      end
        x2=1000./sl;
        p=x2;
        [psi] = ppsi(p);
        u10 = ustn.*(log(1000./z0)-psi) ./ vk ;
        u10 = u10 / 100.;
%
%  neutral solution
%
     else
       ustn=uz.*vk./log(zu./z0);
       while abs(ustn-ust) > 0.1 ;
          ust=0.5*(ust+ustn);
          z0=c1./ust+c2*ust.*ust+c3;
          ustn=uz.*vk./log(zu./z0);
       end
        z0=c1./ustn+c2*ustn.*ustn+c3 ;
        u10=ustn/vk.*log(1000./z0);
        u10 = u10 / 100.;
      end