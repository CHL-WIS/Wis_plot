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
aa.wndspd = double(ncread(fname,'/windspeed'));
aa.wnddir = double(ncread(fname,'/winddir'));
aa.ustar = double(ncread(fname,'/ustar'));
aa.cdrag = double(ncread(fname,'/cd'));
aa.norm = repmat(-999,size(aa.wndspd));
aa.wavhs = double(ncread(fname,'/wavehs'));
aa.wavtp = double(ncread(fname,'/wavetp'));
aa.wavtpp = double(ncread(fname,'/wavetpp'));
aa.wavtm = double(ncread(fname,'/wavetm'));
aa.wavtm1 = double(ncread(fname,'/wavetm1'));
aa.wavtm2 = double(ncread(fname,'/wavetm2'));
aa.wavdir = double(ncread(fname,'/wavedir'));
aa.wavspr = double(ncread(fname,'/wavespr'));

aa.wavhs_wndsea = double(ncread(fname,'/wavehs_wndsea'));
aa.wavtp_wndsea = double(ncread(fname,'/wavetp_wndsea'));
aa.wavtpp_wndsea = double(ncread(fname,'/wavetpp_wndsea'));
aa.wavtm_wndsea = double(ncread(fname,'/wavetm_wndsea'));
aa.wavtm1_wndsea = double(ncread(fname,'/wavetm1_wndsea'));
aa.wavtm2_wndsea = double(ncread(fname,'/wavetm2_wndsea'));
aa.wavdir_wndsea = double(ncread(fname,'/wavedir_wndsea'));
aa.wavspr_wndsea = double(ncread(fname,'/wavespr_wndsea'));

aa.wavhs_swell = double(ncread(fname,'/wavehs_swell'));
aa.wavtp_swell = double(ncread(fname,'/wavetp_swell'));
aa.wavtpp_swell = double(ncread(fname,'/wavetpp_swell'));
aa.wavtm_swell = double(ncread(fname,'/wavetm_swell'));
aa.wavtm1_swell = double(ncread(fname,'/wavetm1_swell'));
aa.wavtm2_swell = double(ncread(fname,'/wavetm2_swell'));
aa.wavdir_swell= double(ncread(fname,'/wavedir_swell'));
aa.wavspr_swell = double(ncread(fname,'/wavespr_swell'));
