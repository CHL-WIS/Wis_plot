function [se, sd] = stats(a,b);
%
%           STAT computes several statistical parameters for WAM model
%                and NDBC data intercomparison.
%
%       Input:  A -- NDBC buoy data from Format 191, record 2 type only
%               B -- WAM model output, one line format
%
%	Hans C. Graber, 4-16-91,  modified 21 July 1992
%	Robert E. Jensen 11-2002  modified 
%
%  ------------------------------------------------------------------
%	The Matricies Contain the following:
%		1.  date (from datenum)
%		2.  wind speed (m/s) buoy has been adjusted
%		3.  wind direction deg Meteorological
%		4.  Significant wave height
%		5.  Parabolic fit wave period
%		6.  Inverse first moment period
%		7.  Overall vector mean wave direction Deg Met.
%  ------------------------------------------------------------------
%
dr = 180/pi;  io = sqrt(-1);
%
[m1,n1] = size(a) ;   % size of buoy data
[m2,n2] = size(b) ;   % size of WAM model output
%
%  Now extract the variables, noting that some of the buoy data
%	are flagged.  Need to remove both pieces of information 
%	prior to running the statistics.
%
%	NOTE:	x = Buoy
%		    Y = Model
%
%				1.0  Wind Speed and Wind direction Check.
iwsg=find(a(:,2) > 0 );
xu = a(iwsg,2);
yu = b(iwsg,2);
%
%				1.1  Wind Direction 
iwdg=find(a(:,3) > 0 & a(:,2) > 0);
xd = a(iwdg,3);
yd = b(iwdg,3);
%
if length(iwdg) < length(iwsg);
    clear xu; clear yu;
    xu = a(iwdg,2);
    yu = b(iwdg,2);
    xd = a(iwdg,3);
    yd = b(iwdg,3);
elseif length(iwsg) > length(iwdg);
    clear xu; clear yu;
    xu = a(iwsg,2);
    yu = b(iwsg,2);
    xd = a(iwsg,3);
    yd = b(iwsg,3); 
end
%
%  Need to make sure that wind speed and direction are IDENTICAL
%   More times than most the direction is missing...  
%
nowdd=isempty(iwdg);
if isempty(nowdd)
  if length(iwdg) ~= length(iwsg);
    iwsg=find(a(:,3) > 0 & a(:,2) > 0);
    clear xu; clear yu;
    xu = a(iwdg,2);
    yu = b(iwdg,2);
    xd = a(iwdg,3);
    yd = b(iwdg,3);
  end
end
%				1.2  Wave Height
iwhtg=find(a(:,4) > 0 );
xh = a(iwhtg,4);
yh = b(iwhtg,4);

%				1.3  Parabolic fit Tp
itpg=find(a(:,5) > 0 & b(:,5) > 0 & a(:,5) ~= Inf & b(:,5) ~= Inf );
xp = a(itpg,5);
yp = b(itpg,5);

%				1.4  Mean Wave Period
itmg=find(a(:,6) > 0 & b(:,5) > 0 & a(:,5) ~= Inf & b(:,5) ~= Inf );
xm = a(itmg,6);
ym = b(itmg,6);

%				1.5  Vector Mean Wave Direction
iwamdg=find(a(:,7) > 0 );
xmwd = a(iwamdg,7);
ymwd = b(iwamdg,7);
%
%
%  Need to make sure that wave height and direction are IDENTICAL
%   More times than most the direction is missing...  
%
nowadd=isempty(iwamdg);
if nowadd == 0
  if length(iwamdg) ~= length(iwhtg);
    iwhtg=find(a(:,7) > 0 & a(:,4) > 0);
    clear xh; clear yh;
    xh = a(iwhtg,4);
    yh = b(iwhtg,4);
    xmwd = a(iwhtg,7);
    ymwd = b(iwhtg,7);
  end
end

%
u = [xu , yu] ;  h = [xh , yh] ;  p = [xp , yp] ;  q = [xm , ym] ; ddd=[xmwd, ymwd];

nu = length(xu) ;  nh = length(xh) ; np = length(xp) ; nm = length(xm) ; nwavd=length(xmwd);

%   calculate statistical parameters for pairs of wind speed, wave height
%   and period

%   calculate means of x and y

xub = mean(xu) ; xhb = mean(xh) ; xpb = mean(xp) ; xqb = mean(xm) ;
yub = mean(yu) ; yhb = mean(yh) ; ypb = mean(yp) ; yqb = mean(ym) ;

%   calculate bias of x and y

bu = mean(yu - xu) ; bh = mean(yh - xh) ;
bp = mean(yp - xp) ; bq = mean(ym - xm) ;

%   calculate absolute error of x and y

au = mean(abs(yu - xu)) ; ah = mean(abs(yh - xh)) ;
ap = mean(abs(yp - xp)) ; aq = mean(abs(ym - xm)) ;

%   calculate rms error of x and y

ru = sqrt(sum( (yu - xu - bu).^2 ) / nu) ;
rh = sqrt(sum( (yh - xh - bh).^2 ) / nh) ;
rp = sqrt(sum( (yp - xp - bp).^2 ) / np) ;
rq = sqrt(sum( (ym - xm - bq).^2 ) / nm) ;

%   calculate scatter index

su = ru / xub * 100 ; sh = rh / xhb * 100 ;
sp = rp / xpb * 100 ; sq = rq / xqb * 100 ;

%   calculate skill score

ssu = 1 - 0.5*sum( (yu-xu).^2 ) / sum( (xu-bu).^2 ) ;
ssh = 1 - 0.5*sum( (yh-xh).^2 ) / sum( (xh-bh).^2 ) ;
ssp = 1 - 0.5*sum( (yp-xp).^2 ) / sum( (xp-bp).^2 ) ;
ssq = 1 - 0.5*sum( (ym-xm).^2 ) / sum( (xm-bq).^2 ) ;

%   calculate correlation coefficient r
if isempty(u)
    rcu(1,1)=0.;
elseif size(u,1) == 1
   rcu(1,1) = 0.;
else
    ra = corr(u) ; 
    rcu = ra(1,2) ; 
end
if size(h,1) == 1
    rch(1,1) = 0.;
else
    ra = corr(h) ; rch = ra(1,2) ;
end
if size(p,1) == 1;
    rcp(1,1) = 0.;
else
    ra = corr(p) ; rcp = ra(1,2) ;
 end
if size(q,1) == 1;
    rcq=0.
else
    ra = corr(q) ; rcq = ra(1,2) ;
end
%   compute linear regression coefficient

c = polyfit(xu,yu,1); fu = polyval(c,xu); u1 = sort(xu); fu1 = polyval(c,u1);
cs(1) = 1 ; cs(2) = 0 ; fus = polyval(cs,u1) ; slu = c(1) ; iu = c(2) ;

c = polyfit(xh,yh,1); fh = polyval(c,xh); h1 = sort(xh); fh1 = polyval(c,h1);
cs(1) = 1 ; cs(2) = 0 ; fhs = polyval(cs,h1) ; slh = c(1) ; ih = c(2) ;

c = polyfit(xp,yp,1); fp = polyval(c,xp); p1 = sort(xp); fp1 = polyval(c,p1);
cs(1) = 1 ; cs(2) = 0 ; fps = polyval(cs,p1) ; slp = c(1) ; ip = c(2) ;

c = polyfit(xm,ym,1); fq = polyval(c,xm); q1 = sort(xm); fq1 = polyval(c,q1);
cs(1) = 1 ; cs(2) = 0 ; fqs = polyval(cs,q1) ; slq = c(1) ; iq = c(2) ;

%   compute symmetrical regression coefficient

csu = sqrt(sum(yu.^2) / sum(xu.^2)); csh = sqrt(sum(yh.^2) / sum(xh.^2));
csp = sqrt(sum(yp.^2) / sum(xp.^2)); csq = sqrt(sum(ym.^2) / sum(xm.^2));

%   compute principal component regression coefficient

z = sum(2*xu.*yu)/(sum(xu.^2)-sum(yu.^2)); z = atan(z); cpu = abs(tan(z/2));
z = sum(2*xh.*yh)/(sum(xh.^2)-sum(yh.^2)); z = atan(z); cph = abs(tan(z/2));
z = sum(2*xp.*yp)/(sum(xp.^2)-sum(yp.^2)); z = atan(z); cpp = abs(tan(z/2));
z = sum(2*xm.*ym)/(sum(xm.^2)-sum(ym.^2)); z = atan(z); cpq = abs(tan(z/2));

%   compute systematic and unsystematic rms error

yo = slu*xu+iu; sru = sqrt(sum((yo-xu).^2)/nu); uru = sqrt(sum((yo-yu).^2)/nu);
yo = slh*xh+ih; srh = sqrt(sum((yo-xh).^2)/nh); urh = sqrt(sum((yo-yh).^2)/nh);
yo = slh*xp+ip; srp = sqrt(sum((yo-xp).^2)/np); urp = sqrt(sum((yo-yp).^2)/np);
yo = slh*xm+iq; srq = sqrt(sum((yo-xm).^2)/nm); urq = sqrt(sum((yo-ym).^2)/nm);

%   calculate bias and rms difference from regression line

du = mean(yu - fu) ; dh = mean(yh - fh) ;
dp = mean(yp - fp) ; dq = mean(ym - fq) ;

%   calculate rms error of x and y

rsu = sqrt(sum( (yu - fu - du).^2 ) / (nu - 1)) ;
rsh = sqrt(sum( (yh - fh - dh).^2 ) / (nh - 1)) ;
rsp = sqrt(sum( (yp - fp - dp).^2 ) / (np - 1)) ;
rsq = sqrt(sum( (ym - fq - dq).^2 ) / (nm - 1)) ;

%   calculate standard error of regression coefficient b

sxu2 = (nu * sum(xu.^2)-(sum(xu))^2); syu2 = sum( (yu-fu).^2 )/(nu-2) ;
sxxu2 = sum(xu.^2); sau = sqrt(syu2*sxxu2/sxu2); sbu = sqrt(nu*syu2/sxu2);

sxh2 = (nh * sum(xh.^2)-(sum(xh))^2); syh2 = sum( (yh-fh).^2 )/(nh-2);
sxxh2 = sum(xh.^2); sah = sqrt(syh2*sxxh2/sxh2); sbh = sqrt(nh*syh2/sxh2);

sxp2 = (nh * sum(xp.^2)-(sum(xp))^2); syp2 = sum( (yp-fp).^2 )/(np-2);
sxxp2 = sum(xp.^2); sap = sqrt(syp2*sxxp2/sxp2); sbp = sqrt(nh*syp2/sxp2);

sxq2 = (nh * sum(xm.^2)-(sum(xm))^2); syq2 = sum( (ym-fq).^2 )/(nm-2);
sxxq2 = sum(xm.^2); saq = sqrt(syq2*sxxq2/sxq2); sbq = sqrt(nh*syq2/sxq2);

%   store statistics from scalar variables

se(1,:) = [xub,yub,bu,au,ru,su,ssu,rcu,csu,cpu,slu,iu,sru,uru,rsu,sau,sbu,nu];
se(2,:) = [xhb,yhb,bh,ah,rh,sh,ssh,rch,csh,cph,slh,ih,srh,urh,rsh,sah,sbh,nh];
se(3,:) = [xpb,ypb,bp,ap,rp,sp,ssp,rcp,csp,cpp,slp,ip,srp,urp,rsp,sap,sbp,np];
se(4,:) = [xqb,yqb,bq,aq,rq,sq,ssq,rcq,csq,cpq,slq,iq,srq,urq,rsq,saq,sbq,nm];

 
%%%%%%   comqute statistics for directional data   %%%%%%%%%%
%   Check on NO data from the buoy record.
%
if isempty(iwdg) == 0
    
    aus = sin(xd*pi/180) ; auc = cos(xd*pi/180) ;
    bus = sin(yd*pi/180) ; buc = cos(yd*pi/180) ;
    xs = xu .* aus ; xc = xu .* auc ;
    bs = sin((yd - xd)*pi/180) ; bc = cos((yd - xd)*pi/180) ;
    ys = yu .* bus ; yc = yu .* buc ;
    
    %   calculate mean directions of x and y
    
    %   -- mean direction from sine and cosine --
    
    xbs = mean(aus) ; xbc = mean(auc) ; xdb = atan2(xbs,xbc) * 180/pi ;
    if xdb < 0 
        xdb = xdb + 360 ;
    end
    
    ybs = mean(bus) ; ybc = mean(buc) ; ydb = atan2(ybs,ybc) * 180/pi ;
    if ydb < 0
        ydb = ydb + 360 ;
    end
    
    %   calculate standard deviation by Yamartino's (1984) method
    
    ex = sqrt(1 - (xbs^2 + xbc^2)); ey = sqrt(1 - (ybs^2 + ybc^2)); 
    sigx = asin(ex)*(180/pi) * (1 + 0.1547 * ex^3) ;  
    sigy = asin(ey)*(180/pi) * (1 + 0.1547 * ey^3) ;
    
    %   -- wind speed weighted mean direction --
    
    xus = mean(xs) ; xuc = mean(xc) ; avx = atan2(xus,xuc) * 180/pi ;
    if avx < 0
        avx = avx + 360 ;
    end
    
    yus = mean(ys) ; yuc = mean(yc) ; avy = atan2(yus,yuc) * 180/pi ;
    if avy < 0
        avy = avy + 360 ;
    end
    
    %   calculate bias of x and y
    
    bbs = mean(bs) ; bbc = mean(bc) ; bd = atan2(bbs,bbc) * 180/pi ;
    dt = (xs .* yc + ys .* xc) ./ (xs .* ys + xc .* yc) ;
    ad = mean( atan(dt) ) * 180 / pi ;
    
    %   calculate rms error of x and y
    
    sig = - 2 * log(bbs^2 + bbc^2) ; rd = sqrt((bd*pi/180)^2 + sig) * 180/pi ;
    
    %   calculate complex correlation coefficient rho and phase
    
    rp = mean( (xs.*ys + xc.*yc) ) ; ip = mean( (xs.*yc + ys.*xc) ) ;
    r1 = sqrt(mean(xs.^2 + xc.^2)) ; r2 = sqrt(mean(ys.^2 + yc.^2)) ;
    z = (rp + io*ip) / (r1 * r2);  rho = abs(z); pha = angle(z) * 180/pi;
    
    %   store results
else
    xdb=0.;
    ydb=0;
    sigx=0;
    sigy=0;
    avx=0.;
    avy=0.;
    bd=0.;
    rd=0.;
    rho=0;
    pha=0;
    nu = 0;
end    
sd(1,:) = [xdb, sigx, ydb, sigy, avx, avy, bd, rd, rho, pha, nu] ;

%  Now for the Wave Direction.
%   Same logic to test if there are directional buoy data.
%     ddd=[xmwd, ymwd];  nwavd=length(xmwd);
%
%clear xdb; clear ydb; clear avx; clear avy; clear bd;
%clear rd;  clear rho; clear pha; clear nu;

if isempty(iwamdg) == 0
    
    aswv = sin(xmwd*pi/180) ; acwv = cos(xmwd*pi/180) ;
    bswv = sin(ymwd*pi/180) ; bcwv = cos(ymwd*pi/180) ;
    xswv = xh .* aswv ; xcwv = xh .* acwv ;
    bswv = sin((ymwd - xmwd)*pi/180) ; bcwv = cos((ymwd - xmwd)*pi/180) ;
    yswv = yh .* bswv ; ycwv = yh .* bcwv ;
    
    %   calculate mean directions of x and y
    
    %   -- mean direction from sine and cosine --
    
    xbswv = mean(aswv) ; xbcwv = mean(acwv) ; xdbwv = atan2(xbswv,xbcwv) * 180/pi ;
    if xdbwv < 0 
        xdbwv = xdbwv + 360 ;
    end
    
    ybswv = mean(bswv) ; ybcwv = mean(bcwv) ; ydbwv = atan2(ybswv,ybcwv) * 180/pi ;
    if ydbwv < 0
        ydbwv = ydbwv + 360 ;
    end
    
    %   calculate standard deviation by Yamartino's (1984) method
    
    exwv = sqrt(1 - (xbswv^2 + xbcwv^2)); 
    eywv = sqrt(1 - (ybswv^2 + ybcwv^2)); 
    sigxwv = asin(exwv)*(180/pi) * (1 + 0.1547 * exwv^3) ;  
    sigywv = asin(eywv)*(180/pi) * (1 + 0.1547 * eywv^3) ;
    
    %   -- wave height weighted mean direction --
    
    xswv = mean(xswv) ; xcwv = mean(xcwv) ; 
    avxwv = atan2(xswv,xcwv) * 180/pi ;
    if avxwv < 0
        avxwv = avxwv + 360 ;
    end
    
    yswv = mean(yswv) ; ycwv = mean(ycwv) ; 
    avywv = atan2(yswv,ycwv) * 180/pi ;
    
    if avywv < 0
        avywv = avywv + 360 ;
    end
    
    %   calculate bias of x and y
    
    bbswv = mean(bswv) ; bbcwv = mean(bcwv) ; bdwv = atan2(bbswv,bbcwv) * 180/pi ;
    dtwv = (xswv .* ycwv + yswv .* xcwv) ./ (xswv .* yswv + xcwv .* ycwv) ;
    adwv = mean( atan(dtwv) ) * 180 / pi ;
    
    %   calculate rms error of x and y
    
    sigwv = - 2 * log(bbswv^2 + bbcwv^2) ; rdwv = sqrt((bdwv*pi/180)^2 + sigwv) * 180/pi ;
    
    %   calculate complex correlation coefficient rho and phase
    
    rpwv = mean( (xswv.*yswv + xcwv.*ycwv) ) ; ipwv = mean( (xswv.*ycwv + yswv.*xcwv) ) ;
    r1wv = sqrt(mean(xswv.^2 + xcwv.^2)) ; r2wv = sqrt(mean(yswv.^2 + ycwv.^2)) ;
    zwv = (rpwv + io*ipwv) / (r1wv * r2wv);  rhowv = abs(zwv); phawv = angle(zwv) * 180/pi;
    
    %   store results
else
    xdbwv=0.;
    ydbwv=0;
    avxwv=0.;
    avywv=0.;
    bdwv=0.;
    sigxwv=0;
    sigywv=0;
    rdwv=0.;
    rhowv=0;
    phawv=0;
    nwavd = 0;
end   
sd(2,:) = [xdbwv, sigxwv, ydbwv, sigywv, avxwv, avywv, bdwv, rdwv, rhowv, phawv, nwavd] ;



