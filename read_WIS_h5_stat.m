function [aa, fflag] = read_WIS_h5_stat(fname)
fid = fopen(fname);
if fid == -1
    fflag = 0;aa = 0;
    return
end
tt = double(h5read(fname,'/datetime')');
aa.timec = intdate_2_strdate(tt(:,1),tt(:,2),tt(:,3),tt(:,4),tt(:,5),tt(:,6));
aa.time = datenum(tt(:,1),tt(:,2),tt(:,3),tt(:,4),tt(:,5),tt(:,6));

aa.stat = str2double(h5readatt(fname,'/','Station'));
aa.lat = double(h5readatt(fname,'/','Latitude'));
aa.lon = double(h5readatt(fname,'/','Longitude'));
aa.wndspd = double(h5read(fname,'/wndspd'));
aa.wnddir = double(h5read(fname,'/wnddir'));
aa.ustar = double(h5read(fname,'/ustar'));
aa.cdrag = double(h5read(fname,'/cd'));
aa.norm = repmat(-999,size(aa.wndspd));
aa.wavhs = double(h5read(fname,'/wavhs'));
aa.wavtp = double(h5read(fname,'/wavtp'));
aa.wavtpp = double(h5read(fname,'/wavtpp'));
aa.wavtm = double(h5read(fname,'/wavtm'));
aa.wavtm1 = double(h5read(fname,'/wavtm1'));
aa.wavtm2 = double(h5read(fname,'/wavtm2'));
aa.wavdir = double(h5read(fname,'/wavdir'));
aa.wavspr = double(h5read(fname,'/wavspr'));

aa.wavhs_wndsea = double(h5read(fname,'/wavhs_wndsea'));
aa.wavtp_wndsea = double(h5read(fname,'/wavtp_wndsea'));
aa.wavtpp_wndsea = double(h5read(fname,'/wavtpp_wndsea'));
aa.wavtm_wndsea = double(h5read(fname,'/wavtm_wndsea'));
aa.wavtm1_wndsea = double(h5read(fname,'/wavtm1_wndsea'));
aa.wavtm2_wndsea = double(h5read(fname,'/wavtm2_wndsea'));
aa.wavdir_wndsea = double(h5read(fname,'/wavdir_wndsea'));
aa.wavspr_wndsea = double(h5read(fname,'/wavspr_wndsea'));

aa.wavhs_swell = double(h5read(fname,'/wavhs_swell'));
aa.wavtp_swell = double(h5read(fname,'/wavtp_swell'));
aa.wavtpp_swell = double(h5read(fname,'/wavtpp_swell'));
aa.wavtm_swell = double(h5read(fname,'/wavtm_swell'));
aa.wavtm1_swell = double(h5read(fname,'/wavtm1_swell'));
aa.wavtm2_swell = double(h5read(fname,'/wavtm2_swell'));
aa.wavdir_swell= double(h5read(fname,'/wavdir_swell'));
aa.wavspr_swell = double(h5read(fname,'/wavspr_swell'));
