function aa = read_NDBC_onlns(fname)

a = load(fname);
totobsB = size(a,1);

yrnd=a(:,2);
mtnd=a(:,3);
dynd=a(:,4);
hrnd=a(:,5);
mnnd=60*round(a(:,6)/60);

timndb_D=datenum(yrnd,mtnd,dynd,hrnd,mnnd,0);
TMNDB_D=datevec(timndb_D);
timbuoy=datenum(TMNDB_D);

latbn = sprintf('%4.2f',a(1,7) + (a(1,8)/60 + a(1,9)/3600));
latb=num2str(latbn);
lonbn = sprintf('%4.2f',(-a(1,10) + a(1,11)/60 + a(1,12)/3600));
lonb=['-',num2str(lonbn)];

DEPout=a(1,13);
depb=num2str(a(1,13));


iwnd=find(a(:,15) > 0 & a(:,18) > -100 & a(:,19) > -100);
jwnd=find(a(:,18) <= -999 & a(:,19) <= -999);
kwnd=find(a(:,15) <= -999);
clear u10buoy; clear air_sea;
u10buoy=zeros(size(a(:,1)));
ele=zeros(size(a(:,1)));
ielez=find(a(:,14) <= 0.0);
if isempty(ielez)
    ele=a(:,14);
else
    ele(1:length(a(:,1)),1)=5.0;
end
air_sea(iwnd,1)=a(iwnd,18)-a(iwnd,19);
temdifa=length(find(a(:,18) == 0));
temdifs=length(find(a(:,19) == 0));
if temdifa > 0.5*totobsB | temdifs > 0.5*totobsB
    air_sea(1:totobsB,1)=0.;
end

thresh=floor(0.05*length(u10buoy));
if length(iwnd) < thresh | length(iwnd) < 10
    u10buoy(1:length(u10buoy)) = NaN;
    windB(1:length(u10buoy)) = NaN;
else
    [u10buoy(iwnd)]=windp(100*a(iwnd,15),100*ele(iwnd,1),air_sea(iwnd,1),100*ele(iwnd,1));
    u10buoy(jwnd)= a(jwnd,15).*(ele(jwnd,1) / 10.).^(-1/7);
    u10buoy(kwnd) = a(kwnd,15);
    kbadu10=find(imag(u10buoy));
    u10buoy(kbadu10)=a(kbadu10,15);
end

hgtB=a(:,21);
ihgB = find(a(:,21) > 0);

tppfB=a(:,23);
itpB=find(a(:,23) > 0);

tmnB=a(:,24);
ltmnB=find(a(:,24) > 0);

iwavB=find(a(:,25) >= 0);
wavdB=a(:,25);

iu10 = find(u10buoy > 0);

windB=a(:,17);
nowndB=find(windB == 0);
iwdB=length(nowndB);
iwdB2 = find(a(:,17) >= 0);

aa = struct('time',timbuoy,'lonc',lonb,'latc',latb,'lon',str2num(lonb), ...
    'lat',str2num(latb),'depth',DEPout,'wavhs',hgtB,'wavtp',tppfB,'wavtm1', ...
    tmnB,'wavdir',wavdB, ...
    'wndspd',u10buoy,'wnddir',windB,'wavtpp',tppfB, ...
    'wspd',u10buoy,'wdir',windB);