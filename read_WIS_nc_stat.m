function [aa, fflag] = read_WIS_nc_stat(fname)
fid = fopen(fname);
if fid == -1
    fflag = 0;aa = 0;
    return
end
%tt = double(ncread(fname,'/datetime')');
%aa.timec = intdate_2_strdate(tt(:,1),tt(:,2),tt(:,3),tt(:,4),tt(:,5),tt(:,6));
%aa.time = datenum(tt(:,1),tt(:,2),tt(:,3),tt(:,4),tt(:,5),tt(:,6));
tt = double(ncread(fname,'/time'));
aa.time = tt/3600./24. + datenum(1970,01,01,0,0,0);

aa.stat = str2double(ncreadatt(fname,'/','station'));
aa.lat = double(ncreadatt(fname,'/','geospatial_lat'));
aa.lon = double(ncreadatt(fname,'/','geospatial_lon'));
aa.wndspd = double(ncread(fname,'/wndspd'));
aa.wnddir = double(ncread(fname,'/wnddir'));
aa.ustar = double(ncread(fname,'/ustar'));
aa.cdrag = double(ncread(fname,'/cd'));
aa.norm = repmat(-999,size(aa.wndspd));
aa.wavhs = double(ncread(fname,'/wavhs'));
aa.wavtp = double(ncread(fname,'/wavtp'));
aa.wavtpp = double(ncread(fname,'/wavtpp'));
aa.wavtm = double(ncread(fname,'/wavtm'));
aa.wavtm1 = double(ncread(fname,'/wavtm1'));
aa.wavtm2 = double(ncread(fname,'/wavtm2'));
aa.wavdir = double(ncread(fname,'/wavdir'));
aa.wavspr = double(ncread(fname,'/wavspr'));

aa.wavhs_wndsea = double(ncread(fname,'/wavhs_wndsea'));
aa.wavtp_wndsea = double(ncread(fname,'/wavtp_wndsea'));
aa.wavtpp_wndsea = double(ncread(fname,'/wavtpp_wndsea'));
aa.wavtm_wndsea = double(ncread(fname,'/wavtm_wndsea'));
aa.wavtm1_wndsea = double(ncread(fname,'/wavtm1_wndsea'));
aa.wavtm2_wndsea = double(ncread(fname,'/wavtm2_wndsea'));
aa.wavdir_wndsea = double(ncread(fname,'/wavdir_wndsea'));
aa.wavspr_wndsea = double(ncread(fname,'/wavspr_wndsea'));

aa.wavhs_swell = double(ncread(fname,'/wavhs_swell'));
aa.wavtp_swell = double(ncread(fname,'/wavtp_swell'));
aa.wavtpp_swell = double(ncread(fname,'/wavtpp_swell'));
aa.wavtm_swell = double(ncread(fname,'/wavtm_swell'));
aa.wavtm1_swell = double(ncread(fname,'/wavtm1_swell'));
aa.wavtm2_swell = double(ncread(fname,'/wavtm2_swell'));
aa.wavdir_swell= double(ncread(fname,'/wavdir_swell'));
aa.wavspr_swell = double(ncread(fname,'/wavspr_swell'));
