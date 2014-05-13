function aa = read_WIS_onlns_full_old(fname,stat)
fid = fopen(fname);
data = textscan(fid,['%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',...
    '%f%f%f%f%f%f%f%f%f%f%f%f%f%f']);
fclose(fid);
ii = data{2} == stat;
timec = num2str(data{1}(ii));
year = str2num(timec(:,1:4));
mon = str2num(timec(:,5:6));
day = str2num(timec(:,7:8));
hour = str2num(timec(:,9:10));
min = str2num(timec(:,11:12));
sec = str2num(timec(:,13:14));
mtime = datenum(year,mon,day,hour,min,sec);

lon = data{4}(ii);
lat = data{3}(ii);
wvht = data{10}(ii);
tpp = data{11}(ii);
tm1 = data{12}(ii);
wavd = data{16}(ii);
wspd = data{5}(ii);
wdir = data{6}(ii);

wavd = wavd;
%wavd(wavd > 360) = wavd(wavd > 360) - 360;

wdir = wdir;
%wdir(wdir > 360) = wdir(wdir > 360) - 360;

aa = struct('time',mtime,'lon',lon(1),'lat',lat(1),'wvht',wvht,'tpp', ...
    tpp,'tm1',tm1,'wavd',wavd,'wspd',wspd,'wdir',wdir);