function [aa, fflag] = read_WIS_h5_stat(fname)
fid = fopen(fname);
if fid == -1
    fflag = 0;aa = 0;
    return
end
tt = double(h5read(fname,'/datetime')');
aa.timec = intdate_2_strdate(tt(:,1),tt(:,2),tt(:,3),tt(:,4),tt(:,5),tt(:,6));
aa.time = datenum(tt(:,1),tt(:,2),tt(:,3),tt(:,4),tt(:,5),tt(:,6));

%aa.stat = data{2}(1);
aa.lat = h5readatt(fname,'latitude');
aa.lon = h5readatt(fname,'longitude');
aa.wndspd = h5read(fname,'/wndspd');
aa.wnddir = h5read(fname,'/wnddir');
aa.ustar = h5read(fname,'/ustar');
aa.cdrag = h5read(fname,'/cd');
aa.norm = repmat(-999,size(aa.wspd));
aa.wavhs = h5read(fname,'/wavhs');
aa.wavtp = h5read(fname,'/wavtp');
aa.wavtpp = h5read(fname,'/wavtpp');
aa.wavtm = h5read(fname,'/wavtm');
aa.wavtm1 = h5read(fname,'/wavtm1');
aa.wavtm2 = h5read(fname,'/wavtm2');
aa.wavdir = h5read(fname,'/wavdir');
aa.wavspr = h5read(fname,'/wavspr');

aa.wavhs_wndsea = h5read(fname,'/wavhs_wndsea');
aa.wavtp_wndsea = h5read(fname,'/wavtp_wndsea');
aa.wavtpp_wndsea = h5read(fname,'/wavtpp_wndsea');
aa.wavtm_wndsea = h5read(fname,'/wavtm_wndsea');
aa.wavtm1_wndsea = h5read(fname,'/wavtm1_wndsea');
aa.wavtm2_wndsea = h5read(fname,'/wavtm2_wndsea');
aa.wavdir_wndsea = h5read(fname,'/wavdir_wndsea');
aa.wavspr_wndsea = h5read(fname,'/wavspr_wndsea');

aa.wavhs_swell = h5read(fname,'/wavhs_swell');
aa.wavtp_swell = h5read(fname,'/wavtp_swell');
aa.wavtpp_swell = h5read(fname,'/wavtpp_swell');
aa.wavtm_swell = h5read(fname,'/wavtm_swell');
aa.wavtm1_swell = h5read(fname,'/wavtm1_swell');
aa.wavtm2_swell = h5read(fname,'/wavtm2_swell');
aa.wavdir_swell= h5read(fname,'/wavdir_swell');
aa.wavspr_swell = h5read(fname,'/wavspr_swell');
