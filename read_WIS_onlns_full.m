function aa = read_WIS_onlns_full(fname,stat)
fid = fopen(fname);
data = textscan(fid,['%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',...
    '%f%f%f%f%f%f%f%f%f%f%f%f%f%f']);
fclose(fid);
ii = data{4} == stat;
timec = num2str(data{3}(ii));
year = str2num(timec(:,1:4));
mon = str2num(timec(:,5:6));
day = str2num(timec(:,7:8));
hour = str2num(timec(:,9:10));
min = str2num(timec(:,11:12));
sec = str2num(timec(:,13:14));
mtime = datenum(year,mon,day,hour,min,sec);

lon = data{6}(ii);
lat = data{5}(ii);
wvht = data{12}(ii);
tpp = data{13}(ii);
tm1 = data{14}(ii);
wavd = data{18}(ii);
wspd = data{7}(ii);
wdir = data{8}(ii);

wavd = wavd + 180;
wavd(wavd > 360) = wavd(wavd > 360) - 360;

wdir = wdir + 180;
wdir(wdir > 360) = wdir(wdir > 360) - 360;

aa = struct('time',mtime,'lon',lon(1),'lat',lat(1),'wvht',wvht,'tpp', ...
    tpp,'tm1',tm1,'wavd',wavd,'wspd',wspd,'wdir',wdir);