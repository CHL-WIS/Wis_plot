function [aa, fflag] = read_WIS_onlns(fname)
fid = fopen(fname);
if fid == -1
    fflag = 0;aa = 0;
    return
end
fflag = 1;
data = textscan(fid,['%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f',...
    '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f']);
fclose(fid);
if data{1}(1,1) == 1
    [aa,fflag] = read_WIS_onlns_old(fname);
    return
end
aa.timec = num2str(data{1});
year = str2num(aa.timec(:,1:4));
mon = str2num(aa.timec(:,5:6));
day = str2num(aa.timec(:,7:8));
hour = str2num(aa.timec(:,9:10));
min = str2num(aa.timec(:,11:12));
sec = str2num(aa.timec(:,13:14));
aa.time = datenum(year,mon,day,hour,min,sec);

aa.stat = data{2}(1);
aa.lat = data{3}(1);
aa.lon = data{4}(1);
aa.wspd = data{5};
aa.wdir = data{6};
aa.ustar = data{7};
aa.cdrag = data{8};
aa.norm = data{9};
aa.wvht = data{10};
aa.tp = data{11};
aa.tpp = data{12};
aa.tm = data{13};
aa.tm1 = data{14};
aa.tm2 = data{15};
aa.wavd = data{16};
aa.wavs = data{17};

aa.whsea = data{18};
aa.tpsea = data{19};
aa.tppsea = data{20};
aa.tmsea = data{21};
aa.tm1sea = data{22};
aa.tm2sea = data{23};
aa.wdsea = data{24};
aa.wssea = data{25};

aa.whswe = data{26};
aa.tpswe = data{27};
aa.tppswe = data{28};
aa.tmswe = data{29};
aa.tm1swe = data{30};
aa.tm2swe = data{31};
aa.wdswe = data{32};
aa.wsswe = data{33};


%wavd = wavd + 180;
%wavd(wavd > 360) = wavd(wavd > 360) - 360;

%wdir = wdir + 180;
%wdir(wdir > 360) = wdir(wdir > 360) - 360;

%aa = struct('time',mtime,'lon',lon,'lat',lat,'wvht',wvht,'tpp', ...
%    tpp,'tm1',tm1,'wavd',wavd,'wspd',wspd,'wdir',wdir);