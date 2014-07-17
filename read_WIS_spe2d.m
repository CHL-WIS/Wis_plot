function [fileout] = read_WIS_spe2d(fname)
fid = fopen(fname,'r');
nn = 0;
%station = '46001';
for jj = 1:99999
    data = textscan(fid,'%f%f%f%f%f%f%f%f%f',1);
    cont = data{1};
    if size(cont,1) == 0;
        break
    else
    
    date(jj,:) = data{2};
    lon = data{3};
    lat = data{4};
    nf = data{5};
    na = data{6};
    freq1 = data{7};
    dir1 = data{8};
    dird = data{9};
    ang = [dir1:360/na:360].*pi/180;
    
    data = textscan(fid,'%f%f%f',1);
    u10(jj,1) = data{1};
    udir(jj,1) = data{2};
    ustar(jj,1) = data{3};

    data = textscan(fid,'%f%f%f%f%f%f%f',1);
    hs(jj,1) = data{1};
    tp(jj,1) = 0;%data{2};
    tpp(jj,1) = data{2};
    tm(jj,1) = data{3};
    tm1(jj,1) = data{4};
    tm2(jj,1) = data{5};
    wdir(jj,1) = data{6};
    wspr(jj,1) = data{7};
% changed number from 8 to 7 and reorderd output  07/23/2013 TJ Hesser
    for ii = 1:nf
        data = fscanf(fid,'%f',1);
        fr(ii) = data;
        data = fscanf(fid,'%f',na);
        ef(ii,:) = data;
        
    end
    ef2d(:,:,jj) = ef;
    end
    %fileout(jj) = struct('time',time,'lon',lon,'lat',lat,'nf',nf,'na',na, ...
    %    'freq1',freq1,'dir1',dir1,'dird',dird,'u10',u10,'udir',udir, ...
    %    'ustar',ustar,'hs',hs,'tp',tp,'tpp',tpp,'tm',tm,'tm1',tm1,'tm2',tm2, ...
    %    'wdir',wdir,'wspr',wspr,'freq',fr,'ang',ang,'ef2d',ef);
end
timec = num2str(date);
year = str2num(timec(:,1:4));
mon = str2num(timec(:,5:6));
day = str2num(timec(:,7:8));
hour = str2num(timec(:,9:10));
minu = str2num(timec(:,11:12));
sec = str2num(timec(:,13:14));
time = datenum(year,mon,day,hour,minu,sec);
fileout = struct('date',date,'time',time,'lon',lon,'lat',lat,'nf',nf,'na',na, ...
        'freq1',freq1,'dir1',dir1,'dird',dird,'u10',u10,'udir',udir, ...
        'ustar',ustar,'hs',hs,'tp',tp,'tpp',tpp,'tm',tm,'tm1',tm1,'tm2',tm2, ...
        'wdir',wdir,'wspr',wspr,'freq',fr,'ang',ang,'ef2d',ef2d);