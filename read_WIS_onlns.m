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
aa.wndspd = data{5};
aa.wnddir = data{6};
aa.ustar = data{7};
aa.cdrag = data{8};
aa.norm = data{9};
aa.wavhs = data{10};
aa.wavtp = data{11};
aa.wavtpp = data{12};
aa.wavtm = data{13};
aa.wavtm1 = data{14};
aa.wavtm2 = data{15};
aa.wavdir = data{16};
aa.wavspr = data{17};

aa.wavhs_wndsea = data{18};
aa.wavtp_wndsea = data{19};
aa.wavtpp_wndsea = data{20};
aa.wavtm_wndsea = data{21};
aa.wavtm1_wndsea = data{22};
aa.wavtm2_wndsea = data{23};
aa.wavdir_wndsea = data{24};
aa.wavspr_wndsea = data{25};

aa.wavhs_swell = data{26};
aa.wavtp_swell = data{27};
aa.wavtpp_swell = data{28};
aa.wavtm_swell = data{29};
aa.wavtm1_swell = data{30};
aa.wavtm2_swell = data{31};
aa.wavdir_swell = data{32};
aa.wavspr_swell = data{33};
