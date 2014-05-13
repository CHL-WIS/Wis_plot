function read_HWM(fname)

fid = fopen(fname);
for jj = 1:20
    data = fgetl(fid);
end
data = fgetl(fid);lat = str2num(data(27:end));
data = fgetl(fid);lon = str2num(data(28:end));
data = textscan(fid,'%s%s%f%f','headerlines',8);
fclose(fid);
for zz = 1:length(data{1})
    date(1,:) = data{1}(zz);
    monc = date{1}(1:2);mon = str2num(monc);
    dayc = date{1}(4:5);day = str2num(dayc);
    yearc = date{1}(7:10);year = str2num(yearc);
    
    tt = data{1}(zz);
    hourc = tt{1}(1:2);hour = str2num(hourc);
    minc = tt{1}(4:5);min = str2num(minc);
    secc = tt{1}(7:8);sec = str2num(secc);
    
    time(zz,1) = datenum(year,mon,day,hour,min,sec);
end

wtlv = data{3}/3.281;
pres = data{4};
wspd = repmat(-999,size(wtlv));
wdir = repmat(-999,size(wtlv));
stat = fname(5:14);
aa = struct('stat',stat,'time',time,'lat',lat,'lon',lon,'wtlv',wtlv, ...
    'pres',pres,'wspd',wspd,'wdir',wdir);
fout = ['WL-',stat,'-Isaac'];
save(fout,'aa');